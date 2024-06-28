import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:prueba_tecnica/presentation/screens/auth_screen.dart';
import 'package:prueba_tecnica/presentation/screens/home_screen.dart';


class AppRouter {
  static const String authRoute = '/';
  static const String homeRoute = '/home';
  static const String registerRoute = '/register';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authRoute:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case registerRoute:
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Error: Ruta no encontrada'),
            ),
          ),
        );
    }
  }
}