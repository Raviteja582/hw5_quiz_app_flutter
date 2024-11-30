import 'package:flutter/material.dart';
import 'package:hw5_quiz_app/services/database.service.dart';
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
  String category = 'Sports'; // Default: General Knowledge
  String difficulty = 'easy';
  String questionType = 'multiple';
  TextEditingController textController = TextEditingController();

  static const Map<String, int> frequencyOptions = {
    "Sports": 21,
    "Geography": 22,
    "History": 23,
    "Computers": 18,
    "General Knowledge": 9,
  };

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
                DropdownButtonFormField<String>(
                  value: category,
                  decoration:
                      const InputDecoration(labelText: 'Choose Categpory'),
                  items: [
                    'Sports',
                    'Geography',
                    'History',
                    'Computers',
                    'General Knowledge',
                  ].map((obj) {
                    return DropdownMenuItem(value: obj, child: Text(obj));
                  }).toList(),
                  onChanged: (value) => setState(() => category = value!),
                ),
                DropdownButtonFormField<int>(
                  value: numberOfQuestions,
                  decoration:
                      const InputDecoration(labelText: 'Number of Questions'),
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
                  decoration:
                      const InputDecoration(labelText: 'Difficulty Level'),
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
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.blue),
                      hintText: "Enter your name"),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (textController.text == "") {
                        const AlertDialog(
                            title: Text('Pending UserName'),
                            content: Text('Pending Username'));
                        return;
                      }
                      await DatabaseService.addUser(
                          textController.text, category);
                      var questions = await APIService.fetchQuestions(
                        numberOfQuestions,
                        frequencyOptions[category].toString(),
                        difficulty,
                        questionType,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            questions: questions,
                            userName: textController.text,
                            category: category,
                          ),
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
