import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba_tecnica/presentation/screens/auth_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _auth = FirebaseAuth.instance;
  late Brightness brightness;
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
                title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
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
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Contraseña actual'),
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Confirmar nueva contraseña'),
                obscureText: true,
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
            ElevatedButton(
              onPressed: () {
                // Implementa la lógica para cambiar la contraseña
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
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
                  // Cambiar a tema claro
                },
              ),
              ListTile(
                title: const Text('Oscuro'),
                onTap: () {
                  // Cambiar a tema oscuro
                },
              ),
              ListTile(
                title: const Text('Sistema'),
                onTap: () {
                  // Cambiar a tema del sistema
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
