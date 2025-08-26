import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/home.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Since you are using the GetX package, we use GetMaterialApp instead of MaterialApp.
    // This sets up all the necessary routing and dependency injection for GetX to work.
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // This sets the Home widget as the first screen of your app.
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
