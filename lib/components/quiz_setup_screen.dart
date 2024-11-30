import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import '../services/api.service.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int numberOfQuestions = 5;
  String category = '9'; // Default: General Knowledge
  String difficulty = 'easy';
  String questionType = 'multiple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Setup')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Configure Your Quiz',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: numberOfQuestions,
                  decoration: const InputDecoration(labelText: 'Number of Questions'),
                  items: [5, 10, 15].map((value) {
                    return DropdownMenuItem(
                        value: value, child: Text('$value'));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => numberOfQuestions = value!),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: difficulty,
                  decoration: const InputDecoration(labelText: 'Difficulty Level'),
                  items: ['easy', 'medium', 'hard'].map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) => setState(() => difficulty = value!),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: questionType,
                  decoration: const InputDecoration(labelText: 'Question Type'),
                  items: ['multiple', 'boolean'].map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) => setState(() => questionType = value!),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      var questions = await APIService.fetchQuestions(
                        numberOfQuestions,
                        category,
                        difficulty,
                        questionType,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuizScreen(questions: questions),
                        ),
                      );
                    },
                    child: const Text('Start Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
