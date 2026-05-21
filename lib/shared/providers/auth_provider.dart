import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  firebase_auth.User? get firebaseUser => _auth.currentUser;
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  Future<void> _loadUserFromFirestore(firebase_auth.User firebaseUser) async {
    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get()
          .timeout(const Duration(seconds: 8));
      if (doc.exists) {
        _user = User.fromFirestore(doc.data()!);
      } else {
        _user = User(
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? '',
        );
        _saveUserToFirestore(firebaseUser.uid); // fire-and-forget
      }
    } catch (_) {
      _user = User(
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? '',
      );
    }
  }

  Future<void> _saveUserToFirestore(String uid) async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(uid).set(_user!.toFirestore())
          .timeout(const Duration(seconds: 8));
    } catch (_) {}
  }

  Future<void> checkLoginStatus() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _loadUserFromFirestore(firebaseUser);
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      if (firebaseUser != null) {
        await _loadUserFromFirestore(firebaseUser);
      }
      _isLoading = false;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        _errorMessage = 'Email hoặc mật khẩu không đúng';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Mật khẩu không đúng';
      } else {
        _errorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(name);
      _user = User(email: email, name: name);
      if (result.user != null) {
        await _saveUserToFirestore(result.user!.uid);
      }
      _isLoading = false;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'Email này đã được đăng ký';
      } else if (e.code == 'weak-password') {
        _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
      } else {
        _errorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? phoneNumber}) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (name != null) {
        await firebaseUser.updateDisplayName(name);
        await firebaseUser.reload();
      }
      _user = _user?.copyWith(name: name, phoneNumber: phoneNumber);
      await _saveUserToFirestore(firebaseUser.uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Cập nhật thất bại, vui lòng thử lại';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
