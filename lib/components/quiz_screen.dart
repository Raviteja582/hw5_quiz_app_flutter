import 'package:flutter/material.dart';
import '../helpers/countdown_timer.dart';
import 'result_screen.dart';
import '../helpers/progress_indicator.dart';
import 'package:hw5_quiz_app/services/database.service.dart';

class QuizScreen extends StatefulWidget {
  final List<dynamic> questions;
  final String userName;
  final String category;

  const QuizScreen(
      {super.key,
      required this.questions,
      required this.userName,
      required this.category});

  @override
  // ignore: library_private_types_in_public_api
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  String feedback = '';

  final GlobalKey<CountdownTimerState> _timerKey =
      GlobalKey<CountdownTimerState>();

  void updateScore(int score) async {
    await DatabaseService.updateScore(widget.userName, widget.category, score);
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          total: widget.questions.length,
        ),
      ),
    );
  }

  void handleAnswer(String selectedAnswer) {
    _timerKey.currentState?.stopTimer();
    final correctAnswer = widget.questions[currentQuestion]['correct_answer'];
    setState(() {
      late String currentfeedback;
      if (selectedAnswer == correctAnswer) {
        currentfeedback = 'Correct!';
        score++;
      } else if (selectedAnswer == 'NOT_SELECTED') {
        currentfeedback = 'Times Up!!, The correct answer  was: $correctAnswer';
      } else {
        currentfeedback = 'Incorrect! The correct answer was: $correctAnswer';
      }
      feedback = currentfeedback;

      Future.delayed(const Duration(seconds: 2), () {
        if (currentQuestion < widget.questions.length - 1) {
          _timerKey.currentState?.resetTimer();
          setState(() {
            currentQuestion++;
            feedback = '';
          });
          _timerKey.currentState?.startTimer();
        } else {
          updateScore(score);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                score: score,
                total: widget.questions.length,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestion];
    final options = List<String>.from(question['incorrect_answers']);
    options.add(question['correct_answer']);
    options.shuffle();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressIndicatorWidget(
              currentQuestion: currentQuestion,
              totalQuestions: widget.questions.length,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question['question'],
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (feedback.isNotEmpty)
              Text(
                feedback,
                style: TextStyle(
                    fontSize: 16,
                    color: feedback == 'Correct!' ? Colors.green : Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton(
                  onPressed: () => handleAnswer(option),
                  child: Text(option, textAlign: TextAlign.center),
                ),
              );
            }),
            CountdownTimer(
              key: _timerKey,
              initialSeconds: 30,
              onTimerComplete: () => handleAnswer('NOT_SELECTED'),
            )
          ],
        ),
      ),
    );
  }
}
