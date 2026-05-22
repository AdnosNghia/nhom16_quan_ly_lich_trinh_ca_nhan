import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Service gửi email OTP qua EmailJS API
class EmailJsService {
  // ============ CẤU HÌNH EMAILJS ============
  static const String _serviceId = 'service_dgsnjqn';
  static const String _templateId = 'template_uelrbem';
  static const String _publicKey = '1Dq8iXnjYT93WOj1K';
  static const String _privateKey = 'XEpp2ZBg_KUl270TgOasC';
  // ===========================================

  static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  static bool get isConfigured => true;

  /// Gui email OTP
  static Future<bool> sendOtpEmail({
    required String toEmail,
    required String toName,
    required String otpCode,
  }) async {
    debugPrint('[EmailJS] Sending OTP to $toEmail...');

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'accessToken': _privateKey,
          'template_params': {
            'to_email': toEmail,
            'to_name': toName.isNotEmpty ? toName : 'Nguoi dung',
            'otp_code': otpCode,
            'app_name': 'Schedulr',
          },
        }),
      ).timeout(const Duration(seconds: 15));

      debugPrint('[EmailJS] Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('[EmailJS] OK - Da gui OTP den $toEmail');
        return true;
      } else {
        debugPrint('[EmailJS] FAIL: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('[EmailJS] ERROR: $e');
      return false;
    }
  }
}
