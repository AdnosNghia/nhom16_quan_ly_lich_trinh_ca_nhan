import 'subtask.dart';

class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String categoryId;
  final int colorHex;
  final bool isAllDay;
  final bool isRecurring;
  final String? recurrenceRule;
  final List<int> reminderMinutes;
  final bool isCompleted;
  final List<SubTask> subtasks;

  const Event({
    this.id = '',
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.categoryId = '',
    this.colorHex = 0xFF4D41DF,
    this.isAllDay = false,
    this.isRecurring = false,
    this.recurrenceRule,
    this.reminderMinutes = const [15],
    this.isCompleted = false,
    this.subtasks = const [],
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? categoryId,
    int? colorHex,
    bool? isAllDay,
    bool? isRecurring,
    String? recurrenceRule,
    List<int>? reminderMinutes,
    bool? isCompleted,
    List<SubTask>? subtasks,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      categoryId: categoryId ?? this.categoryId,
      colorHex: colorHex ?? this.colorHex,
      isAllDay: isAllDay ?? this.isAllDay,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
