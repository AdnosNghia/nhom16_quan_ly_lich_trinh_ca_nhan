import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/entities/task_item.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  StreamSubscription<List<TaskItem>>? _subscription;
  bool _initialized = false;

  List<TaskItem> _tasks = [];

  List<TaskItem> get tasks => _tasks;
  List<TaskItem> get urgentImportant => _tasks.where((t) => t.quadrant == 0).toList();
  List<TaskItem> get notUrgentImportant => _tasks.where((t) => t.quadrant == 1).toList();
  List<TaskItem> get urgentNotImportant => _tasks.where((t) => t.quadrant == 2).toList();
  List<TaskItem> get notUrgentNotImportant => _tasks.where((t) => t.quadrant == 3).toList();
  bool get initialized => _initialized;

  Future<void> ensureLoaded() async {
    if (!_initialized) await loadTasks();
  }

  Future<void> loadTasks() async {
    _initialized = true;
    try {
      _tasks = await _repository.getAllTasks().timeout(const Duration(seconds: 10));
    } catch (_) {
      _tasks = [];
    }
    notifyListeners();
    try {
      _startListening();
    } catch (_) {}
  }

  void _startListening() {
    _subscription?.cancel();
    _subscription = _repository.watchAllTasks().listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  Future<void> addTask(TaskItem task) async {
    _tasks = [task, ..._tasks];
    notifyListeners();
    _repository.insertTask(task).catchError((_) {});
  }

  Future<void> updateTask(TaskItem task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _tasks[index] = task;
    notifyListeners();
    _repository.updateTask(task).catchError((_) {});
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    _repository.deleteTask(id).catchError((_) {});
  }

  Future<void> toggleTaskComplete(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    }
    notifyListeners();
    _repository.toggleTaskComplete(id).catchError((_) {});
  }

  Future<int> getCompletedCount() async {
    return await _repository.getCompletedCount();
  }

  Future<int> getTotalCount() async {
    return await _repository.getTotalCount();
  }

  Future<double> getCompletionRate() async {
    final total = await _repository.getTotalCount();
    if (total == 0) return 0;
    final completed = await _repository.getCompletedCount();
    return completed / total;
  }

  Future<List<Map<String, dynamic>>> getCompletedByDay({int days = 7}) async {
    return await _repository.getCompletedTasksByDay(days: days);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
