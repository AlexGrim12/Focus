import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime deadline;
  final int priority; // 0: Baja, 1: Media, 2: Alta
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.deadline,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Task(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      deadline: (data['deadline'] as Timestamp).toDate(),
      priority: data['priority'],
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'deadline': Timestamp.fromDate(deadline),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}