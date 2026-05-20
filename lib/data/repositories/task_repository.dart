import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task_item.dart';

class TaskRepository {
  final CollectionReference _tasks = FirebaseFirestore.instance.collection('tasks');

  Stream<List<TaskItem>> watchAllTasks() {
    return _tasks.orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TaskItem(
          id: doc.id,
          title: data['title'] as String,
          description: data['description'] as String?,
          quadrant: data['quadrant'] as int,
          isCompleted: data['isCompleted'] as bool,
          dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate'] as String) : null,
        );
      }).toList();
    });
  }

  Future<List<TaskItem>> getAllTasks() async {
    final snapshot = await _tasks.orderBy('createdAt').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TaskItem(
        id: doc.id,
        title: data['title'] as String,
        description: data['description'] as String?,
        quadrant: data['quadrant'] as int,
        isCompleted: data['isCompleted'] as bool,
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate'] as String) : null,
      );
    }).toList();
  }

  Future<List<TaskItem>> getTasksByQuadrant(int quadrant) async {
    final snapshot = await _tasks
        .where('quadrant', isEqualTo: quadrant)
        .orderBy('createdAt')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TaskItem(
        id: doc.id,
        title: data['title'] as String,
        description: data['description'] as String?,
        quadrant: data['quadrant'] as int,
        isCompleted: data['isCompleted'] as bool,
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate'] as String) : null,
      );
    }).toList();
  }

  Future<void> insertTask(TaskItem task) async {
    final id = const Uuid().v4();
    await _tasks.doc(id).set({
      'title': task.title,
      'description': task.description,
      'quadrant': task.quadrant,
      'isCompleted': task.isCompleted,
      'dueDate': task.dueDate?.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateTask(TaskItem task) async {
    await _tasks.doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'quadrant': task.quadrant,
      'isCompleted': task.isCompleted,
      'dueDate': task.dueDate?.toIso8601String(),
    });
  }

  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }

  Future<void> toggleTaskComplete(String id) async {
    final doc = await _tasks.doc(id).get();
    if (!doc.exists) return;
    final current = doc.data() as Map<String, dynamic>;
    await _tasks.doc(id).update({
      'isCompleted': !(current['isCompleted'] as bool),
    });
  }

  Future<int> getCompletedCount() async {
    final snapshot = await _tasks.where('isCompleted', isEqualTo: true).get();
    return snapshot.docs.length;
  }

  Future<int> getTotalCount() async {
    final snapshot = await _tasks.get();
    return snapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>> getCompletedTasksByDay({int days = 7}) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final snapshot = await _tasks
        .where('isCompleted', isEqualTo: true)
        .where('createdAt', isGreaterThanOrEqualTo: start.toIso8601String())
        .get();
    final map = <String, int>{};
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final day = (data['createdAt'] as String).substring(0, 10);
      map[day] = (map[day] ?? 0) + 1;
    }
    return map.entries
        .map((e) => {'day': e.key, 'count': e.value})
        .toList()
      ..sort((a, b) => (a['day'] as String).compareTo(b['day'] as String));
  }
}
