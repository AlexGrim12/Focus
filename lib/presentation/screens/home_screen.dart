import 'package:flutter/material.dart';
import 'package:prueba_tecnica/models/task.dart';
import 'package:prueba_tecnica/presentation/screens/create_task_screen.dart';
import 'package:prueba_tecnica/presentation/screens/profile_settings_screen.dart';
import 'package:prueba_tecnica/presentation/screens/task_detail_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prueba_tecnica/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  late List<Task> _tasks = [];
  bool _isLoading = true;
  late Color primaryColor;
  late Brightness brightness;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final tasks = await _apiService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      // Manejar el error
      print('Error al obtener tareas: ${e.toString()}');
      _showErrorSnackBar('Error al obtener tareas');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).colorScheme.primary;
    brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus', style: Theme.of(context).textTheme.headlineMedium),
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchTasks,
              child: SingleChildScrollView(
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
                    children: _tasks.map((task) {
                      return Column(
                        children: [
                          Slidable(
                            key: Key(task.id.toString()),
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    try {
                                      // Actualizar el estado de la tarea en el backend
                                      final updatedTask = Task(
                                        id: task.id,
                                        title: task.title,
                                        description: task.description,
                                        deadline: task.deadline,
                                        priority: task.priority,
                                        isCompleted: !task.isCompleted,
                                      );
                                      await _apiService.updateTask(updatedTask);
                                      // Actualizar el estado local de la tarea
                                      setState(() {
                                        _tasks[_tasks.indexOf(task)] = updatedTask;
                                      });
                                    } catch (e) {
                                      // Manejar el error
                                      print('Error al actualizar la tarea: ${e.toString()}');
                                      _showErrorSnackBar('Error al actualizar la tarea');
                                    }
                                  },
                                  backgroundColor: task.isCompleted
                                      ? Colors.orange
                                      : Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: task.isCompleted
                                      ? Icons.undo
                                      : Icons.check,
                                  label: task.isCompleted
                                      ? 'No Realizada'
                                      : 'Realizada',
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    try {
                                      // Eliminar la tarea del backend
                                      await _apiService.deleteTask(task.id!);
                                      // Eliminar la tarea de la lista local
                                      setState(() {
                                        _tasks.remove(task);
                                      });
                                    } catch (e) {
                                      // Manejar el error
                                      print('Error al eliminar la tarea: ${e.toString()}');
                                      _showErrorSnackBar('Error al eliminar la tarea');
                                    }
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Eliminar',
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ],
                            ),
                            child: ListTile(
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
                            ),
                          ),
                          if (_tasks.indexOf(task) < _tasks.length - 1)
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
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
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
                  if (task.description != null && task.description!.isNotEmpty)
                    Text('Descripción: ${task.description}'),
                  if (task.description != null && task.description!.isNotEmpty)
                    SizedBox(height: 16),
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}