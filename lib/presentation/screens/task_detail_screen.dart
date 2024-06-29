import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prueba_tecnica/models/task.dart';
import 'package:prueba_tecnica/presentation/router/app_routes.dart';
import 'package:prueba_tecnica/services/api_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late int _selectedPriority;
  bool _isCompleted = false;
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description ?? '';
    _selectedDate = widget.task.deadline;
    _selectedPriority = widget.task.priority;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descripción (opcional)'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Fecha límite: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                  ),
                  IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Prioridad'),
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: const Text('Baja'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: const Text('Media'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: const Text('Alta'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: const Text('Completada'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateTask();
                  }
                },
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _deleteTask();
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateTask() async {
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      deadline: _selectedDate,
      priority: _selectedPriority,
      isCompleted: _isCompleted,
    );

    try {
      await _apiService.updateTask(updatedTask);
      // Navega a la pantalla de inicio o muestra un mensaje de éxito
      Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
    } catch (e) {
      // Manejar el error
      print('Error al actualizar la tarea: ${e.toString()}');
      _showErrorSnackBar('Error al actualizar la tarea');
    }
  }

  Future<void> _deleteTask() async {
    try {
      await _apiService.deleteTask(widget.task.id!);
      // Navega a la pantalla de inicio o muestra un mensaje de éxito
      Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
    } catch (e) {
      // Manejar el error
      print('Error al eliminar la tarea: ${e.toString()}');
      _showErrorSnackBar('Error al eliminar la tarea');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}