import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prueba_tecnica/models/task.dart';

class CompletedSlidableWidget extends StatelessWidget {
  const CompletedSlidableWidget({
    super.key,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth, required this.task,
  }) : _firestore = firestore, _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (context) {
        _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('tasks')
            .doc(task.id)
            .update(
                {'isCompleted': !task.isCompleted});
      },
      backgroundColor: task.isCompleted
          ? Colors.orange
          : Colors.green,
      foregroundColor: Colors.white,
      icon:
          task.isCompleted ? Icons.undo : Icons.check,
      label: task.isCompleted
          ? 'No Realizada'
          : 'Realizada',
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
