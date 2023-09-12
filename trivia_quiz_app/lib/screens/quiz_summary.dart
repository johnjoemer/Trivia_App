import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
import 'package:trivia_quiz_app/screens/quiz_page.dart';
import 'package:trivia_quiz_app/main.dart';

//once the game is done, it will provide the score and an option to start the game again
class QuizSummary extends StatelessWidget {
  final int correctAnswers;

  const QuizSummary({super.key, required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox (
            height: 30,
            child: Text('Quiz Completed!')
          ),
          SizedBox (
            height: 30,
            child: Text('Correct Answers: $correctAnswers')
          ),

          const SizedBox(height: 15),

          ElevatedButton(
              onPressed: () {
                showText = true;
                questionCounter = 1;
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Start Again'),
            ),

          const SizedBox(height: 15),

          Container(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                questionCounter = 1;
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              child: const Text('Home'),
            ),
          ),

          const SizedBox(height: 15),
        ],
      )
    );
  }
}
