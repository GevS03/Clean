import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'ToDo App',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(' App')),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}