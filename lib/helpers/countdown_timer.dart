import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int initialSeconds;
  final Function onTimerComplete;

  const CountdownTimer({
    super.key,
    required this.initialSeconds,
    required this.onTimerComplete,
  });

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.initialSeconds;
    startTimer();
  }

  /// Start the timer
  void startTimer() {
    stopTimer(); // Ensure no multiple timers are running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        widget.onTimerComplete();
      }
    });
  }

  /// Stop the timer
  void stopTimer() {
    _timer?.cancel();
  }

  /// Reset the timer
  void resetTimer() {
    stopTimer();
    setState(() {
      remainingSeconds = widget.initialSeconds;
    });
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _formatTime(remainingSeconds),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Format time in MM:SS
  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
