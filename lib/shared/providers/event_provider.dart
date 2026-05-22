import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/event_repository.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/subtask.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _repository = EventRepository();
  StreamSubscription<List<Event>>? _subscription;
  bool _initialized = false;

  String? _userId;
  List<Event> _events = [];
  List<Event> _currentDayEvents = [];
  Map<String, int> _currentDaySubtaskCounts = {};
  DateTime? _lastLoadedDate;

  String? get userId => _userId;
  List<Event> get events => _events;
  List<Event> get currentDayEvents => _currentDayEvents;
  Map<String, int> get currentDaySubtaskCounts => _currentDaySubtaskCounts;
  bool get initialized => _initialized;

  /// Called by ChangeNotifierProxyProvider when AuthProvider changes.
  void updateUser(String? newUserId) {
    if (_userId == newUserId) return;
    _userId = newUserId;
    if (newUserId == null || newUserId.isEmpty) {
      // User logged out – clear everything
      _subscription?.cancel();
      _subscription = null;
      _events = [];
      _currentDayEvents = [];
      _currentDaySubtaskCounts = {};
      _initialized = false;
      _lastLoadedDate = null;
      notifyListeners();
    } else {
      // User logged in – reload data for this user
      _initialized = false;
      loadEvents();
    }
  }

  Future<void> ensureLoaded() async {
    if (!_initialized) await loadEvents();
  }

  Future<void> loadEvents() async {
    if (_userId == null || _userId!.isEmpty) return;
    _initialized = true;
    try {
      _events = await _repository.getAllEvents(_userId!).timeout(const Duration(seconds: 15));
    } catch (_) {
      _events = [];
    }
    notifyListeners();
    try {
      _startListening();
    } catch (_) {}
  }

  void _startListening() {
    if (_userId == null || _userId!.isEmpty) return;
    _subscription?.cancel();
    _subscription = _repository.watchAllEvents(_userId!).listen((events) {
      _events = events;
      _refreshCurrentDay();
      notifyListeners();
    });
  }

  void _refreshCurrentDay() {
    if (_lastLoadedDate == null) return;
    final startOfDay = DateTime(_lastLoadedDate!.year, _lastLoadedDate!.month, _lastLoadedDate!.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    _currentDayEvents = _events.where((e) =>
      e.startTime.isBefore(endOfDay) && e.endTime.isAfter(startOfDay)
    ).toList();
    _currentDaySubtaskCounts = {};
    for (final e in _currentDayEvents) {
      _currentDaySubtaskCounts[e.id] = e.subtasks.length;
    }
  }

  Future<void> loadEventsForDate(DateTime date) async {
    _lastLoadedDate = date;
    _refreshCurrentDay();
    notifyListeners();
  }

  Future<List<Event>> getUpcomingEvents({int limit = 5}) async {
    if (_userId == null || _userId!.isEmpty) return [];
    return await _repository.getUpcomingEvents(_userId!, limit: limit);
  }

  Future<Event?> getEventById(String id) async {
    return _events.where((e) => e.id == id).firstOrNull ?? await _repository.getEventById(id);
  }

  Future<void> addEvent(Event event) async {
    final eventWithUser = event.copyWith(userId: _userId ?? '');
    _events = [eventWithUser, ..._events];
    _refreshCurrentDay();
    notifyListeners();
    _repository.insertEvent(eventWithUser).catchError((_) {});

    // Schedule notification reminder
    NotificationService().scheduleEventReminder(eventWithUser);
  }

  Future<void> updateEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
    _refreshCurrentDay();
    notifyListeners();
    _repository.updateEvent(event).catchError((_) {});

    // Re-schedule notification: cancel old, schedule new
    await NotificationService().cancelEventReminder(event.id);
    NotificationService().scheduleEventReminder(event);
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
    _refreshCurrentDay();
    notifyListeners();
    _repository.deleteEvent(id).catchError((_) {});

    // Cancel notification for deleted event
    NotificationService().cancelEventReminder(id);
  }

  Future<void> toggleEventComplete(String id) async {
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index] = _events[index].copyWith(isCompleted: !_events[index].isCompleted);
    }
    _refreshCurrentDay();
    notifyListeners();
    _repository.toggleEventComplete(id).catchError((_) {});
  }

  Future<int> getCompletedCountForDate(DateTime date) async {
    if (_userId == null || _userId!.isEmpty) return 0;
    return await _repository.getCompletedCountForDate(_userId!, date);
  }

  Future<int> getTotalCountForDate(DateTime date) async {
    if (_userId == null || _userId!.isEmpty) return 0;
    return await _repository.getTotalCountForDate(_userId!, date);
  }

  Future<Map<String, int>> getCategoryDistribution() async {
    if (_userId == null || _userId!.isEmpty) return {};
    return await _repository.getCategoryDistribution(_userId!);
  }

  Future<List<SubTask>> getSubTasksForEvent(String eventId) async {
    return await _repository.getSubTasksForEvent(eventId);
  }

  List<Event> getEventsOnDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return _events.where((event) {
      return event.startTime.isBefore(endOfDay) && event.endTime.isAfter(startOfDay);
    }).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
