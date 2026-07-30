class Task {
  final String id;
  final String userId;
  final String username;
  final String gmail;
  final String title;
  final bool completed;
  final String category;

  final DateTime createdAt;
  final DateTime? dueDate;

  const Task({
    required this.id,
    required this.userId,
    required this.username,
    required this.gmail,
    required this.title,
    required this.completed,
    this.category = 'personal',

    required this.createdAt,
    this.dueDate,
  });
}