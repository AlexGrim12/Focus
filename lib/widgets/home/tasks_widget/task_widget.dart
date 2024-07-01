import 'package:flutter/material.dart';
import 'package:prueba_tecnica/models/task.dart';
import 'package:prueba_tecnica/presentation/screens/task_detail_screen.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${task.deadline.day}/${task.deadline.month}/${task.deadline.year}'),
          ],
        ),
      ),
      trailing: Icon(
        task.isCompleted
            ? Icons.check_circle
            : Icons.circle,
        color: task.priority == 0
            ? Colors.green
            : task.priority == 1
                ? Colors.orange
                : Colors.red,
      ),
      onTap: () {
        _showTaskPreview(context, task);
      },
    );
  }
}

void _showTaskPreview(BuildContext context, Task task) {
  final brightness = Theme.of(context).brightness;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(task.title),
        content: Container(
          padding: const EdgeInsets.all(16.0),
          // bg
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? Colors.white
                : Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10.0),
          ),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description!.isNotEmpty)
                  Text('Descripción: ${task.description}'),
                if (task.description!.isNotEmpty) SizedBox(height: 16),
                Text(
                    'Fecha límite: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}'),
                SizedBox(height: 16),
                Text(
                    'Prioridad: ${task.priority == 0 ? 'Baja' : task.priority == 1 ? 'Media' : 'Alta'}'),
                SizedBox(height: 16),
                Text(
                    'Estado: ${task.isCompleted ? 'Completada' : 'Pendiente'}'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(task: task),
                ),
              );
            },
            child: Text('Editar'),
          ),
        ],
      );
    },
  );
}