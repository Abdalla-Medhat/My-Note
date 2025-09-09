import 'package:flutter/material.dart';
import 'package:mynote/homepage.dart';
import 'package:mynote/add_edit.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        "home": (context) => const HomeScreen(),
        "addEditNote": (context) => const AddEditNote(),
      },
    );
  }
}
