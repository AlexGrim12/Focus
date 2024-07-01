import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prueba_tecnica/models/task.dart';
import 'package:prueba_tecnica/widgets/home/tasks_widget/slidables/completed_slidable_widget.dart';
import 'package:prueba_tecnica/widgets/home/tasks_widget/slidables/delete_slidable_widget.dart';
import 'package:prueba_tecnica/widgets/home/tasks_widget/task_widget.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required this.brightness,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final tasks = snapshot.data!.docs
              .map((doc) => Task.fromFirestore(doc))
              .toList();

          // Ordenar las tareas
          tasks.sort((a, b) {
            // Ordenar por fecha (más cercana a más lejana)
            int dateComparison = a.deadline.compareTo(b.deadline);
            if (dateComparison != 0) return dateComparison;
            // Ordenar por prioridad
            return a.priority.compareTo(b.priority);
          });

          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: brightness == Brightness.light
                    ? Colors.white
                    : Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: tasks.map((task) {
                  return Column(
                    children: [
                      Slidable(
                        key: Key(task.id),
                        startActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            CompletedSlidableWidget(
                                firestore: _firestore, auth: _auth, task: task),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            DeleteSlidableWidget(
                                firestore: _firestore, auth: _auth, task: task),
                          ],
                        ),
                        child: TaskWidget(task: task),
                      ),
                      if (tasks.indexOf(task) < tasks.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Divider(
                            height: 0.0,
                            thickness: 1.0,
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar las tareas'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


