import 'package:flutter/material.dart';
import 'package:mynote/view/login.dart';
import 'package:mynote/view/note.dart';
import 'package:mynote/view/settings.dart';
import 'package:mynote/view/signup.dart';
import 'package:mynote/view/home.dart';
import 'package:mynote/view/themes.dart';
import 'package:mynote/model/sqldb.dart';
import 'package:mynote/view/update_password.dart';

Sqldb sqldb = Sqldb();
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isLoggedIn = await sqldb.isLoggedin();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // The root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note',
      debugShowCheckedModeBanner: false,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: isLoggedIn ? const Home() : const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const Home(),
        '/settings': (context) => const Settings(),
        '/note': (context) => const Note(),
        '/update_password': (context) => const UpdatePassword(),
      },
    );
  }
}
