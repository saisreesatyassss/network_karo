import 'package:flutter/material.dart';
import 'package:network_karo/screens/Get_started.dart';
import 'package:network_karo/screens/Opening.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the initialRoute to '/Get_started' if you want '/Get_started' as the first screen.
      // initialRoute: '/Get_started',

      // Define  routes
      routes: {
        '/': (context) => const Opening(),
        '/Get_started': (context) => Get_started(),
      },
    );
  }
}
