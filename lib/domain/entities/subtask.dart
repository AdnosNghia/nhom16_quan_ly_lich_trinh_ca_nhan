class SubTask {
  final String id;
  final String eventId;
  final String title;
  final bool isCompleted;
  final int sortOrder;

  const SubTask({
    this.id = '',
    this.eventId = '',
    required this.title,
    this.isCompleted = false,
    this.sortOrder = 0,
  });

  SubTask copyWith({
    String? id,
    String? eventId,
    String? title,
    bool? isCompleted,
    int? sortOrder,
  }) {
    return SubTask(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
