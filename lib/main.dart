import 'package:flutter/material.dart';
import './components/quiz_setup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customizable Quiz App',
      theme: ThemeData.dark(), // Enable dark mode
      home: const QuizSetupScreen(),
    );
  }
}
