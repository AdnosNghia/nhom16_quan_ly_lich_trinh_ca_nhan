import 'package:cloud_firestore/cloud_firestore.dart';

class LoginHistory {
  final String id;
  final String deviceName;
  final String deviceType; // "mobile", "tablet", "web", "desktop"
  final String platform;   // "Android", "iOS", "Windows", etc.
  final DateTime loginTime;
  final String loginMethod; // "email", "google"
  final bool isCurrentSession;

  const LoginHistory({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.platform,
    required this.loginTime,
    required this.loginMethod,
    this.isCurrentSession = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'deviceName': deviceName,
      'deviceType': deviceType,
      'platform': platform,
      'loginTime': Timestamp.fromDate(loginTime),
      'loginMethod': loginMethod,
    };
  }

  factory LoginHistory.fromFirestore(String id, Map<String, dynamic> data) {
    return LoginHistory(
      id: id,
      deviceName: data['deviceName'] as String? ?? 'Unknown',
      deviceType: data['deviceType'] as String? ?? 'mobile',
      platform: data['platform'] as String? ?? 'Unknown',
      loginTime: (data['loginTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      loginMethod: data['loginMethod'] as String? ?? 'email',
    );
  }
}
