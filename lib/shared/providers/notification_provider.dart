import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  static const _keyPush = 'schedulr_notif_push';
  static const _keySound = 'schedulr_notif_sound';
  static const _keyReminder = 'schedulr_notif_reminder';
  static const _keyWeeklyReport = 'schedulr_notif_weekly';

  bool _pushEnabled = true;
  bool _soundEnabled = true;
  bool _reminderEnabled = true;
  bool _weeklyReportEnabled = false;
  int _defaultReminderMinutes = 15;

  bool get pushEnabled => _pushEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get reminderEnabled => _reminderEnabled;
  bool get weeklyReportEnabled => _weeklyReportEnabled;
  int get defaultReminderMinutes => _defaultReminderMinutes;

  /// Load persisted notification settings.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _pushEnabled = prefs.getBool(_keyPush) ?? true;
    _soundEnabled = prefs.getBool(_keySound) ?? true;
    _reminderEnabled = prefs.getBool(_keyReminder) ?? true;
    _weeklyReportEnabled = prefs.getBool(_keyWeeklyReport) ?? false;
    _defaultReminderMinutes = prefs.getInt('schedulr_default_reminder_mins') ?? 15;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPush, _pushEnabled);
    await prefs.setBool(_keySound, _soundEnabled);
    await prefs.setBool(_keyReminder, _reminderEnabled);
    await prefs.setBool(_keyWeeklyReport, _weeklyReportEnabled);
    await prefs.setInt('schedulr_default_reminder_mins', _defaultReminderMinutes);
  }

  Future<void> togglePush(bool value) async {
    _pushEnabled = value;
    notifyListeners();
    await _persist();

    if (!value) {
      // Cancel all notifications when push is disabled
      await NotificationService().cancelAllReminders();
    }
  }

  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> toggleReminder(bool value) async {
    _reminderEnabled = value;
    notifyListeners();
    await _persist();

    if (!value) {
      // Cancel all event reminders when disabled
      await NotificationService().cancelAllReminders();
    }
  }

  Future<void> toggleWeeklyReport(bool value) async {
    _weeklyReportEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> setDefaultReminderMinutes(int minutes) async {
    _defaultReminderMinutes = minutes;
    notifyListeners();
    await _persist();
  }
}
