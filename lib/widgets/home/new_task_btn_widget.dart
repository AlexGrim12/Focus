import 'package:flutter/material.dart';
import 'package:prueba_tecnica/presentation/screens/create_task_screen.dart';

class NewTaskBtnWidget extends StatelessWidget {
  const NewTaskBtnWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
    );
  }
}

