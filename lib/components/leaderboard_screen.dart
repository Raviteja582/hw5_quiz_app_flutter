import 'package:flutter/material.dart';
import 'package:hw5_quiz_app/components/quiz_setup_screen.dart';
import '../services/database.service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: FutureBuilder(
        future: DatabaseService.getTopScores(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final scores = snapshot.data as List<Map<String, dynamic>>;
            return Stack(
              children: [
                ListView(
                  children: scores.map((score) {
                    return ListTile(
                      title: Text(score['player']),
                      subtitle:
                          Text('${score['category']} - ${score['score']}'),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizSetupScreen(),
                            ),
                          )
                        },
                    child: const Text('Go Back'))
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
