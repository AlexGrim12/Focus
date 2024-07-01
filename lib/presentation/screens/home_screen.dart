import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba_tecnica/presentation/screens/profile_settings_screen.dart';
import 'package:prueba_tecnica/widgets/home/new_task_btn_widget.dart';
import 'package:prueba_tecnica/widgets/home/tasks_widget/tasks_widget.dart';
class HomeScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HomeScreen({Key? key, required this.themeModeNotifier}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Color primaryColor;
  late Brightness brightness;

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
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsScreen(themeModeNotifier: widget.themeModeNotifier),
                ),
              );
            },
          ),
        ],
      ),
      body: TaskListWidget(firestore: _firestore, auth: _auth, brightness: brightness),
      floatingActionButton: const NewTaskBtnWidget(),
    );
  }
}
