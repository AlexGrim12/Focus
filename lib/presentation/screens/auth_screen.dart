import 'package:flutter/material.dart';
import 'package:prueba_tecnica/presentation/router/app_routes.dart';
import 'package:prueba_tecnica/presentation/screens/home_screen.dart';
import 'package:prueba_tecnica/services/api_service.dart'; // Importa HomeScreen

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginMode = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Bienvenido a',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8.0),
                Text('Focus', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: 'Correo Electrónico'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Correo electrónico inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce una contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                // Mostrar el campo de confirmación solo en modo de registro
                if (!_isLoginMode) const SizedBox(height: 16.0),
                if (!_isLoginMode)
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                        labelText: 'Confirmar Contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text(_isLoginMode ? 'Iniciar Sesión' : 'Registrarse'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(_isLoginMode
                      ? '¿No tienes una cuenta? Registrate.'
                      : '¿Ya tienes una cuenta? Inicia sesión.'),
                ),
                const SizedBox(height: 18.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        if (_isLoginMode) {
          // Iniciar sesión
          final response = await _apiService.login(email, password);
          if (response.statusCode == 200) {
            // Inicio de sesión exitoso
            print('response.headers ${response.headers}');
            _apiService.setSessionCookie(response.headers['set-cookie']!);
            Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
            print('sessionCookie ${_apiService.sessionCookie}');
          } else {
            // Error al iniciar sesión
            _showErrorSnackBar('Error al iniciar sesión');
          }
        } else {
          // Registrarse
          final response = await _apiService.register(email, password);
          if (response.statusCode == 201) {
            // Registro exitoso
            Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
          } else {
            // Error al registrarse
            _showErrorSnackBar('Error al registrarse');
          }
        }
      } catch (e) {
        // Error inesperado
        _showErrorSnackBar('Error al procesar la solicitud');
      }
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
