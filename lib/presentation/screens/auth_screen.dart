import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoginMode = true;
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

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
                  decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Correo electrónico inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value ?? "";
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce una contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    // print(value);
                    _password = value;

                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                // Mostrar el campo de confirmación solo en modo de registro
                if (!_isLoginMode) const SizedBox(height: 16.0),
                if (!_isLoginMode)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      if (value != _password) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _confirmPassword = value ?? "";
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_isLoginMode) {
          // Iniciar sesión
          await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
        } else if (!_isLoginMode) {
          // Registrarse
          await _auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
        }
        // Redirigir a la pantalla principal
        Navigator.pushReplacementNamed(context,
            '/home'); // Reemplaza '/' con la ruta de tu HomeScreen
      } catch (e) {
        print('Error de autenticación: ${e.toString()}');
        // Mostrar un mensaje de error al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de autenticación'),
          ),
        );
      }
    }
  }
}