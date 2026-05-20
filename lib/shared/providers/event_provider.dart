import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/event_repository.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/subtask.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _repository = EventRepository();
  StreamSubscription<List<Event>>? _subscription;
  bool _initialized = false;

  List<Event> _events = [];
  List<Event> _currentDayEvents = [];
  Map<String, int> _currentDaySubtaskCounts = {};
  DateTime? _lastLoadedDate;

  List<Event> get events => _events;
  List<Event> get currentDayEvents => _currentDayEvents;
  Map<String, int> get currentDaySubtaskCounts => _currentDaySubtaskCounts;
  bool get initialized => _initialized;

  Future<void> ensureLoaded() async {
    if (!_initialized) await loadEvents();
  }

  Future<void> loadEvents() async {
    _initialized = true;
    try {
      _events = await _repository.getAllEvents().timeout(const Duration(seconds: 15));
    } catch (_) {
      _events = [];
    }
    notifyListeners();
    try {
      _startListening();
    } catch (_) {}
  }

  void _startListening() {
    _subscription?.cancel();
    _subscription = _repository.watchAllEvents().listen((events) {
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
    return await _repository.getUpcomingEvents(limit: limit);
  }

  Future<Event?> getEventById(String id) async {
    return _events.where((e) => e.id == id).firstOrNull ?? await _repository.getEventById(id);
  }

  Future<void> addEvent(Event event) async {
    _events = [event, ..._events];
    _refreshCurrentDay();
    notifyListeners();
    _repository.insertEvent(event).catchError((_) {});
  }

  Future<void> updateEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
    _refreshCurrentDay();
    notifyListeners();
    _repository.updateEvent(event).catchError((_) {});
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
    _refreshCurrentDay();
    notifyListeners();
    _repository.deleteEvent(id).catchError((_) {});
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
    return await _repository.getCompletedCountForDate(date);
  }

  Future<int> getTotalCountForDate(DateTime date) async {
    return await _repository.getTotalCountForDate(date);
  }

  Future<Map<String, int>> getCategoryDistribution() async {
    return await _repository.getCategoryDistribution();
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
