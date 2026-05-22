import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/emailjs_service.dart';
import '../../core/services/login_history_service.dart';
import '../../domain/entities/login_history.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginHistoryService _loginHistoryService = LoginHistoryService();
  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _pendingTwoFactor = false;

  firebase_auth.User? get firebaseUser => _auth.currentUser;
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null && !_pendingTwoFactor;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  bool get pendingTwoFactor => _pendingTwoFactor;

  Future<void> _loadUserFromFirestore(firebase_auth.User firebaseUser) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .timeout(const Duration(seconds: 8));
      if (doc.exists) {
        _user = User.fromFirestore(doc.data()!);
      } else {
        _user = User(
          email: firebaseUser.email ?? '',
          name:
              firebaseUser.displayName ??
              firebaseUser.email?.split('@').first ??
              '',
        );
        _saveUserToFirestore(firebaseUser.uid); // fire-and-forget
      }
    } catch (_) {
      _user = User(
        email: firebaseUser.email ?? '',
        name:
            firebaseUser.displayName ??
            firebaseUser.email?.split('@').first ??
            '',
      );
    }
  }

  Future<void> _saveUserToFirestore(String uid) async {
    if (_user == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(_user!.toFirestore())
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

        // Kiểm tra xem 2FA có bật không
        if (_user?.twoFactorEnabled == true) {
          _pendingTwoFactor = true;
          await _generateAndSaveOtp(firebaseUser.uid);
        }
      }
      _isLoading = false;
      notifyListeners();

      // Record login history (fire-and-forget)
      if (firebaseUser != null && !_pendingTwoFactor) {
        _loginHistoryService.recordLogin(firebaseUser.uid, 'email');
      }
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

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        _isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final firebaseUser = result.user;

      if (firebaseUser != null) {
        await _loadUserFromFirestore(firebaseUser);
        // If user is new (no Firestore doc yet), create profile from Google data
        if (_user?.name.isEmpty ?? true) {
          _user = User(
            email: firebaseUser.email ?? '',
            name:
                firebaseUser.displayName ??
                firebaseUser.email?.split('@').first ??
                '',
          );
          await _saveUserToFirestore(firebaseUser.uid);
        }

        // Kiểm tra 2FA cho Google Sign-In
        if (_user?.twoFactorEnabled == true) {
          _pendingTwoFactor = true;
          await _generateAndSaveOtp(firebaseUser.uid);
        }
      }

      _isLoading = false;
      notifyListeners();

      // Record login history (fire-and-forget)
      if (firebaseUser != null && !_pendingTwoFactor) {
        _loginHistoryService.recordLogin(firebaseUser.uid, 'google');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        _errorMessage = 'Email này đã được đăng ký bằng phương thức khác';
      } else {
        _errorMessage = 'Đăng nhập Google thất bại, vui lòng thử lại';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Đăng nhập Google thất bại, vui lòng thử lại';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== 2FA Methods ====================

  /// Tạo mã OTP 6 số, lưu vào Firestore và gửi email xác thực
  Future<void> _generateAndSaveOtp(String uid) async {
    final code = (100000 + Random().nextInt(900000)).toString();
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));

    try {
      await _firestore.collection('otp_codes').doc(uid).set({
        'code': code,
        'expiresAt': Timestamp.fromDate(expiresAt),
        'verified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Gửi email OTP qua EmailJS
      final sent = await EmailJsService.sendOtpEmail(
        toEmail: _user?.email ?? '',
        toName: _user?.name ?? '',
        otpCode: code,
      );
      if (!sent) {
        debugPrint('[2FA] Gui email OTP that bai');
      }
    } catch (e) {
      debugPrint('[2FA] Error: $e');
    }
  }

  /// Gửi lại mã OTP mới
  Future<void> resendOtp() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _generateAndSaveOtp(uid);
  }

  /// Xác thực mã OTP
  Future<bool> verifyOtp(String inputCode) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    try {
      final doc = await _firestore.collection('otp_codes').doc(uid).get();
      if (!doc.exists) return false;

      final data = doc.data()!;
      final storedCode = data['code'] as String?;
      final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
      final verified = data['verified'] as bool? ?? false;

      if (verified) return false; // Mã đã được sử dụng
      if (expiresAt != null && DateTime.now().isAfter(expiresAt))
        return false; // Hết hạn
      if (storedCode != inputCode) return false; // Sai mã

      // Đánh dấu đã xác thực
      await _firestore.collection('otp_codes').doc(uid).update({
        'verified': true,
      });
      _pendingTwoFactor = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[2FA] Verify OTP error: $e');
      return false;
    }
  }

  /// Hủy xác thực 2FA (quay lại đăng nhập)
  Future<void> cancelTwoFactor() async {
    _pendingTwoFactor = false;
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  /// Bật/tắt xác thực 2 lớp
  Future<bool> toggleTwoFactor(bool enabled) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null || _user == null) return false;

    try {
      _user = _user!.copyWith(twoFactorEnabled: enabled);
      await _saveUserToFirestore(firebaseUser.uid);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[2FA] Toggle error: $e');
      return false;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // success — hiển thị thông báo kiểm tra hộp thư
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('[resetPassword] Error: ${e.code} - ${e.message}');
      if (e.code == 'invalid-email') {
        return 'Địa chỉ email không hợp lệ';
      } else if (e.code == 'user-not-found') {
        return 'Email này chưa được đăng ký trong hệ thống';
      } else {
        return 'Đã có lỗi xảy ra, vui lòng thử lại';
      }
    } catch (e) {
      debugPrint('[resetPassword] Unknown error: $e');
      return 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    _pendingTwoFactor = false;
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get login history for the current user.
  Future<List<LoginHistory>> getLoginHistory() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    return await _loginHistoryService.getLoginHistory(uid);
  }

  /// Clear all login history for the current user.
  Future<void> clearLoginHistory() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _loginHistoryService.clearHistory(uid);
  }
}
