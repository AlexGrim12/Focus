import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa la biblioteca para formatear fechas
import 'package:prueba_tecnica/models/task.dart';
import 'package:prueba_tecnica/presentation/router/app_routes.dart';
import 'package:prueba_tecnica/services/api_service.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedPriority = 1; // Media por defecto
  final _apiService = ApiService();

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
        title: const Text('Crear Tarea'),
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
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createTask();
                  }
                },
                child: const Text('Crear'),
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

  Future<void> _createTask() async {
    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      deadline: _selectedDate,
      priority: _selectedPriority,
      isCompleted: false,
    );

    try {
      final createdTask = await _apiService.createTask(task);
      // Navega a la pantalla de inicio o muestra un mensaje de éxito
      // Por ejemplo, puedes usar Navigator.pop(context); para volver a la pantalla anterior
      Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
    } catch (e) {
      Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
      
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