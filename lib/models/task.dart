class Task {
  final int? id;
  final String title;
  final String? description;
  late final DateTime deadline;
  final int priority;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.deadline,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      priority: json['priority'],
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // eliminar la T y lo que sigue después de la T
      'deadline': deadline.toIso8601String().split('T')[0],
      'priority': priority,
      'is_completed': isCompleted,
    };
  }

   
}