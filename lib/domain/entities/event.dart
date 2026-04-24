class Event {
  final int id;
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

  const Event({
    this.id = 0,
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
  });
}

class Category {
  final int id;
  final String name;
  final int colorHex;
  final String iconCode;

  const Category({
    this.id = 0,
    required this.name,
    required this.colorHex,
    this.iconCode = '',
  });
}

class SubTask {
  final int id;
  final int eventId;
  final String title;
  final bool isCompleted;
  final int sortOrder;

  const SubTask({
    this.id = 0,
    this.eventId = 0,
    required this.title,
    this.isCompleted = false,
    this.sortOrder = 0,
  });
}
