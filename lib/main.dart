import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/protected_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/protected': (context) => ProtectedPage(),
      },
    );
  }
}
