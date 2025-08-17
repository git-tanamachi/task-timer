class Task {
  final String name;
  final DateTime notificationTime;
  final DateTime? lastCompletionTime;

  Task({
    required this.name,
    required this.notificationTime,
    this.lastCompletionTime,
  });
}
