import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://flask-prueba-tecnica.vercel.app';
  late SharedPreferences _prefs;
  static const String _sessionCookieKey = 'sessionCookie';

  ApiService() {
    _initPrefs(); // Inicializar SharedPreferences
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<http.Response> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({'username': username, 'password': password});
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    return response;
  }

  Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'username': username, 'password': password});
    print('body $body');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 200) {
      // Guardar la cookie de sesión en SharedPreferences
      setSessionCookie(response.headers['set-cookie']!);
    }
    return response;
  }

  Future<http.Response> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final response = await http.get(url);
    // Eliminar la cookie de sesión de SharedPreferences
    _prefs.remove(_sessionCookieKey);
    sessionCookie = null;
    return response;
  }

  Future<List<Task>> getTasks() async {
    final url = Uri.parse('$baseUrl/tasks');
    // obter la cookie de sesión almacenada
    print('Aqui se ejecuta el getSessionCookie');
    sessionCookie = getSessionCookie();
    final response = await http.get(url, headers: {
      'Cookie': 'session=$sessionCookie'
    }); // Obtiene las cookies de la respuesta de inicio de sesión
    print(
        'La peticion fue headers: session=${sessionCookie} body: ${response.body}');
    print('sessionCookie en get tasks $sessionCookie');
    if (response.statusCode == 200) {
      final List<dynamic> tasksData = jsonDecode(response.body);
      return tasksData.map((taskData) => Task.fromJson(taskData)).toList();
    } else {
      throw Exception('Error al obtener las tareas');
    }
  }

  Future<Task> createTask(Task task) async {
    print("La tarea es: ${task.toJson()}");
    final url = Uri.parse('$baseUrl/tasks');
    // cambiar el formato de la fecha a ISO 8601

    final body = jsonEncode(task.toJson());
    // en body, la fecha debe eliminar lo que sigue después de la letra T hasta las comillas

    sessionCookie = getSessionCookie();
    print(
        'La peticion fue headers: session=${sessionCookie} body: ${body} url: ${url}');
    final response = await http.post(url,
        headers: {
          'Cookie': 'session=$sessionCookie',
          'Content-Type': 'application/json'
        },
        body: body);
    print('sessionCookie en create task $sessionCookie');
    print(response.body.toString());
    if (response.statusCode == 201) {
      final Map<String, dynamic> taskData = jsonDecode(response.body);
      print('Tarea creada: $taskData');
      return Task.fromJson(taskData);
    } else {
      throw Exception('Error al crear la tarea');
    }
  }

  Future<http.Response> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/tasks/${task.id}');
    final body = jsonEncode(task.toJson());
    final response = await http.put(url,
        headers: {
          'Cookie': 'session=$sessionCookie',
          'Content-Type': 'application/json'
        },
        body: body);
    return response;
  }

  Future<http.Response> deleteTask(int taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId');
    final response =
        await http.delete(url, headers: {'Cookie': 'session=$sessionCookie'});
    return response;
  }

  // Variable para almacenar la cookie de la sesión
  String? sessionCookie;

  // Función para obtener la cookie de la sesión de la respuesta de inicio de sesión
  setSessionCookie(String cookie) {
    // tratamiento de la cookie de la sesión
    cookie = cookie.split(';')[0];
    cookie = cookie.split('=')[1];
    sessionCookie = cookie;
    _prefs.setString(
        _sessionCookieKey, sessionCookie!); // Guardar en SharedPreferences

    print('sessionCookie en el api service $sessionCookie');
  }

  // Función para obtener la cookie de sesión almacenada
  getSessionCookie() {
    sessionCookie = _prefs.getString(_sessionCookieKey);
    print('sessionCookie recuperado $sessionCookie');
    return sessionCookie;
  }
}
