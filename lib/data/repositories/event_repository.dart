import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/subtask.dart';

class EventRepository {
  final CollectionReference _events = FirebaseFirestore.instance.collection('events');

  Stream<List<Event>> watchAllEvents() {
    return _events.orderBy('startTime').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _eventFromDoc(doc)).toList();
    });
  }

  Future<List<Event>> getAllEvents() async {
    final snapshot = await _events.orderBy('startTime').get();
    return snapshot.docs.map((doc) => _eventFromDoc(doc)).toList();
  }

  Future<List<Event>> getEventsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final snapshot = await _events
        .where('startTime', isLessThan: endOfDay.toIso8601String())
        .where('endTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .orderBy('startTime')
        .get();
    return snapshot.docs.map((doc) => _eventFromDoc(doc)).toList();
  }

  Future<List<Event>> getEventsForRange(DateTime start, DateTime end) async {
    final snapshot = await _events
        .where('startTime', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('startTime', isLessThan: end.toIso8601String())
        .orderBy('startTime')
        .get();
    return snapshot.docs.map((doc) => _eventFromDoc(doc)).toList();
  }

  Future<List<Event>> getUpcomingEvents({int limit = 5}) async {
    final now = DateTime.now().toIso8601String();
    final snapshot = await _events
        .where('startTime', isGreaterThanOrEqualTo: now)
        .orderBy('startTime')
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => _eventFromDoc(doc)).toList();
  }

  Future<Event?> getEventById(String id) async {
    final doc = await _events.doc(id).get();
    if (!doc.exists) return null;
    return _eventFromDoc(doc);
  }

  Future<void> insertEvent(Event event) async {
    final id = const Uuid().v4();
    final now = DateTime.now().toIso8601String();
    await _events.doc(id).set({
      'id': id,
      'title': event.title,
      'description': event.description,
      'startTime': event.startTime.toIso8601String(),
      'endTime': event.endTime.toIso8601String(),
      'location': event.location,
      'categoryId': event.categoryId,
      'colorHex': event.colorHex,
      'isAllDay': event.isAllDay,
      'isRecurring': event.isRecurring,
      'recurrenceRule': event.recurrenceRule,
      'reminderMinutes': event.reminderMinutes,
      'isCompleted': event.isCompleted,
      'createdAt': now,
      'updatedAt': now,
    });
    for (final sub in event.subtasks) {
      await _events.doc(id).collection('subtasks').add({
        'eventId': id,
        'title': sub.title,
        'isCompleted': sub.isCompleted,
        'sortOrder': sub.sortOrder,
      });
    }
  }

  Future<void> updateEvent(Event event) async {
    await _events.doc(event.id).update({
      'title': event.title,
      'description': event.description,
      'startTime': event.startTime.toIso8601String(),
      'endTime': event.endTime.toIso8601String(),
      'location': event.location,
      'categoryId': event.categoryId,
      'colorHex': event.colorHex,
      'isAllDay': event.isAllDay,
      'isRecurring': event.isRecurring,
      'recurrenceRule': event.recurrenceRule,
      'reminderMinutes': event.reminderMinutes,
      'isCompleted': event.isCompleted,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    final subSnap = await _events.doc(event.id).collection('subtasks').get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in subSnap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    for (final sub in event.subtasks) {
      await _events.doc(event.id).collection('subtasks').add({
        'eventId': event.id,
        'title': sub.title,
        'isCompleted': sub.isCompleted,
        'sortOrder': sub.sortOrder,
      });
    }
  }

  Future<void> deleteEvent(String id) async {
    final subSnap = await _events.doc(id).collection('subtasks').get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in subSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_events.doc(id));
    await batch.commit();
  }

  Future<void> toggleEventComplete(String id) async {
    final doc = await _events.doc(id).get();
    if (!doc.exists) return;
    final current = doc.data() as Map<String, dynamic>;
    await _events.doc(id).update({
      'isCompleted': !(current['isCompleted'] as bool),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getCompletedCountForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final snapshot = await _events
        .where('isCompleted', isEqualTo: true)
        .where('startTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('startTime', isLessThan: endOfDay.toIso8601String())
        .get();
    return snapshot.docs.length;
  }

  Future<int> getTotalCountForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final snapshot = await _events
        .where('startTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('startTime', isLessThan: endOfDay.toIso8601String())
        .get();
    return snapshot.docs.length;
  }

  Future<Map<String, int>> getCategoryDistribution() async {
    final snapshot = await _events.get();
    final map = <String, int>{};
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final catId = data['categoryId'] as String;
      map[catId] = (map[catId] ?? 0) + 1;
    }
    return map;
  }

  Future<List<SubTask>> getSubTasksForEvent(String eventId) async {
    final snapshot = await _events
        .doc(eventId)
        .collection('subtasks')
        .orderBy('sortOrder')
        .get();
    return snapshot.docs.map((doc) {
      final d = doc.data();
      return SubTask(
        id: doc.id,
        eventId: eventId,
        title: d['title'] as String,
        isCompleted: d['isCompleted'] as bool,
        sortOrder: d['sortOrder'] as int,
      );
    }).toList();
  }

  Future<Map<String, int>> getSubtaskCountsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final snapshot = await _events
        .where('startTime', isLessThan: endOfDay.toIso8601String())
        .where('endTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .get();
    final map = <String, int>{};
    for (final doc in snapshot.docs) {
      final subSnap = await doc.reference.collection('subtasks').count().get();
      map[doc.id] = subSnap.count ?? 0;
    }
    return map;
  }

  Event _eventFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      startTime: DateTime.parse(data['startTime'] as String),
      endTime: DateTime.parse(data['endTime'] as String),
      location: data['location'] as String?,
      categoryId: data['categoryId'] as String,
      colorHex: data['colorHex'] as int,
      isAllDay: data['isAllDay'] as bool,
      isRecurring: data['isRecurring'] as bool,
      recurrenceRule: data['recurrenceRule'] as String?,
      reminderMinutes: List<int>.from(data['reminderMinutes'] as List),
      isCompleted: data['isCompleted'] as bool,
    );
  }
}
