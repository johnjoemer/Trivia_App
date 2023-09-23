import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
import 'package:trivia_quiz_app/screens/quiz_page.dart';
import 'package:trivia_quiz_app/main.dart';

//once the game is done, it will provide the score and an option to start the game again
class QuizSummary extends StatelessWidget {
  final int correctAnswers;

  const QuizSummary({Key? key, required this.correctAnswers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Icon(
              Icons.celebration,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
           
            const SizedBox(height: 20),
           
            Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 15),
            
            Text(
              'Correct Answers: $correctAnswers',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showText = true;
                  questionCounter = 1;
                  highScore = correctAnswers;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Colors.white,
                ),
                child: const Text(
                  'Start Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}


