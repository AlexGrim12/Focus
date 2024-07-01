import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba_tecnica/presentation/screens/auth_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const ProfileSettingsScreen({Key? key, required this.themeModeNotifier}) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _auth = FirebaseAuth.instance;
  late Brightness brightness;
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de perfil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? Colors.white
                : Theme.of(context).colorScheme.surfaceContainerLow,
            border: brightness == Brightness.light
                ? Border.all(color: Colors.black26)
                : Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: const Text('Correo electrónico'),
                subtitle: Text('${_auth.currentUser!.email}'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Divider(
                  height: 0.0,
                  thickness: 1.0,
                ),
              ),
              ListTile(
                title: const Text('Contraseña'),
                subtitle: const Text('********'),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  _showEditPasswordDialog();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Divider(
                  height: 0.0,
                  thickness: 1.0,
                ),
              ),
              ListTile(
                title: const Text('Tema'),
                subtitle: Text(Theme.of(context).brightness == Brightness.light
                    ? 'Claro'
                    : 'Oscuro'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showThemeSettingsDialog();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Divider(
                  height: 0.0,
                  thickness: 1.0,
                ),
              ),
              ListTile(
                title: const Text('Cerrar sesión',
                    style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar contraseña'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Contraseña actual'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña actual.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _currentPassword = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nueva contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una nueva contraseña.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _newPassword = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Confirmar nueva contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirma la nueva contraseña.';
                    }
                    if (value != _newPassword) {
                      return 'Las contraseñas no coinciden.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _confirmPassword = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Lógica para cambiar la contraseña usando Firebase Auth
                  _changePassword();
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_newPassword);
        // Mostrar un mensaje de éxito al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actualizada')),
        );
      } else {
        // Manejar el caso en el que el usuario no está autenticado
      }
    } catch (e) {
      // Manejar el error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showThemeSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Claro'),
                onTap: () {
                  widget.themeModeNotifier.value = ThemeMode.light;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Oscuro'),
                onTap: () {
                  widget.themeModeNotifier.value = ThemeMode.dark;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sistema'),
                onTap: () {
                  widget.themeModeNotifier.value = ThemeMode.system;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}

