import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/login_history.dart';

class LoginHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const int _maxRecords = 20;

  CollectionReference _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('login_history');

  /// Record a new login event.
  Future<void> recordLogin(String uid, String loginMethod) async {
    try {
      final deviceInfo = _getDeviceInfo();

      await _collection(uid).add({
        'deviceName': deviceInfo['deviceName'],
        'deviceType': deviceInfo['deviceType'],
        'platform': deviceInfo['platform'],
        'loginTime': FieldValue.serverTimestamp(),
        'loginMethod': loginMethod,
      });

      // Cleanup old records if more than max
      await _cleanupOldRecords(uid);
    } catch (e) {
      debugPrint('[LoginHistory] Error recording login: $e');
    }
  }

  /// Get login history sorted by time descending.
  Future<List<LoginHistory>> getLoginHistory(String uid) async {
    try {
      final snapshot = await _collection(uid)
          .orderBy('loginTime', descending: true)
          .limit(_maxRecords)
          .get()
          .timeout(const Duration(seconds: 10));

      return snapshot.docs.map((doc) {
        return LoginHistory.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      debugPrint('[LoginHistory] Error getting history: $e');
      return [];
    }
  }

  /// Delete a single login record.
  Future<void> deleteRecord(String uid, String recordId) async {
    try {
      await _collection(uid).doc(recordId).delete();
    } catch (e) {
      debugPrint('[LoginHistory] Error deleting record: $e');
    }
  }

  /// Clear all login history for a user.
  Future<void> clearHistory(String uid) async {
    try {
      final snapshot = await _collection(uid).get();
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('[LoginHistory] Error clearing history: $e');
    }
  }

  /// Remove old records exceeding the max limit.
  Future<void> _cleanupOldRecords(String uid) async {
    try {
      final snapshot = await _collection(uid)
          .orderBy('loginTime', descending: true)
          .get();

      if (snapshot.docs.length > _maxRecords) {
        final batch = _firestore.batch();
        for (int i = _maxRecords; i < snapshot.docs.length; i++) {
          batch.delete(snapshot.docs[i].reference);
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint('[LoginHistory] Error cleaning up: $e');
    }
  }

  /// Get device information for the current platform.
  Map<String, String> _getDeviceInfo() {
    if (kIsWeb) {
      return {
        'deviceName': 'Web Browser',
        'deviceType': 'web',
        'platform': 'Web',
      };
    }

    try {
      String deviceName;
      String deviceType;
      String platform;

      if (Platform.isAndroid) {
        deviceName = 'Android Device';
        deviceType = 'mobile';
        platform = 'Android ${Platform.operatingSystemVersion}';
      } else if (Platform.isIOS) {
        deviceName = 'iPhone / iPad';
        deviceType = 'mobile';
        platform = 'iOS ${Platform.operatingSystemVersion}';
      } else if (Platform.isWindows) {
        deviceName = 'Windows PC';
        deviceType = 'desktop';
        platform = 'Windows ${Platform.operatingSystemVersion}';
      } else if (Platform.isMacOS) {
        deviceName = 'Mac';
        deviceType = 'desktop';
        platform = 'macOS ${Platform.operatingSystemVersion}';
      } else if (Platform.isLinux) {
        deviceName = 'Linux PC';
        deviceType = 'desktop';
        platform = 'Linux';
      } else {
        deviceName = 'Unknown Device';
        deviceType = 'unknown';
        platform = Platform.operatingSystem;
      }

      return {
        'deviceName': deviceName,
        'deviceType': deviceType,
        'platform': platform,
      };
    } catch (_) {
      return {
        'deviceName': 'Unknown Device',
        'deviceType': 'unknown',
        'platform': 'Unknown',
      };
    }
  }
}
