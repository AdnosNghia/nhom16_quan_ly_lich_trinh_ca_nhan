class TaskItem {
  final String id;
  final String title;
  final String? description;
  final int quadrant;
  final bool isCompleted;
  final DateTime? dueDate;

  const TaskItem({
    this.id = '',
    required this.title,
    this.description,
    this.quadrant = 0,
    this.isCompleted = false,
    this.dueDate,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    int? quadrant,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      quadrant: quadrant ?? this.quadrant,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
