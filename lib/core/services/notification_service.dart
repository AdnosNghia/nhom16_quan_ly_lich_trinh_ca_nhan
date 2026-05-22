import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/event.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notification plugin. Must be called once in main().
  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      // Fallback to UTC if timezone detection fails
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request Android 13+ notification permission
    await _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('[Notification] Tapped: ${response.payload}');
    // Could navigate to event detail here if needed
  }

  /// Schedule a notification for an event reminder.
  Future<void> scheduleEventReminder(Event event) async {
    if (!_initialized) return;
    if (event.reminderMinutes.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final isReminderEnabled = prefs.getBool('schedulr_notif_reminder') ?? true;
    if (!isReminderEnabled) return;

    for (final minutes in event.reminderMinutes) {
      final scheduledTime = event.startTime.subtract(Duration(minutes: minutes));

      // Don't schedule if the time has already passed
      if (scheduledTime.isBefore(DateTime.now())) continue;

      final notificationId = _generateNotificationId(event.id, minutes);

      final androidDetails = AndroidNotificationDetails(
        'schedulr_reminders',
        'Nhắc nhở sự kiện',
        channelDescription: 'Thông báo nhắc nhở trước sự kiện',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      try {
        await _plugin.zonedSchedule(
          notificationId,
          'Nhắc nhở sự kiện',
          'Sự kiện "${event.title}" bắt đầu sau $minutes phút',
          tz.TZDateTime.from(scheduledTime, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: event.id,
        );
      } catch (e) {
        debugPrint('[Notification] Error scheduling: $e');
      }
    }
  }

  /// Cancel all notifications for a specific event.
  Future<void> cancelEventReminder(String eventId) async {
    if (!_initialized) return;
    // Cancel for common reminder times: 5, 10, 15, 30, 60 minutes
    for (final minutes in [5, 10, 15, 30, 60]) {
      final id = _generateNotificationId(eventId, minutes);
      await _plugin.cancel(id);
    }
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAllReminders() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }

  /// Show a notification immediately (for testing).
  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;

    final androidDetails = AndroidNotificationDetails(
      'schedulr_reminders',
      'Nhắc nhở sự kiện',
      channelDescription: 'Thông báo nhắc nhở trước sự kiện',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(0, title, body, details);
  }

  /// Generate a stable notification ID from event ID and reminder minutes.
  int _generateNotificationId(String eventId, int minutes) {
    return (eventId.hashCode + minutes).abs() % 2147483647;
  }
}
