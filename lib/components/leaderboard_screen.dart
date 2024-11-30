import 'package:flutter/material.dart';
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
            return ListView(
              children: scores.map((score) {
                return ListTile(
                  title: Text(score['player']),
                  subtitle: Text('${score['category']} - ${score['score']}'),
                );
              }).toList(),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
