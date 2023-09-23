import 'package:flutter/material.dart';

class QuizReview extends StatelessWidget {
  final List<Map<String, dynamic>> reviewList;
  final List<dynamic> userAnswers;

  const QuizReview({super.key, required this.reviewList, required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: reviewList.length,
        itemBuilder: (context, index) {
          final question = reviewList[index];
          final questionNumber = index + 1;

          return QuestionReviewCard(
            questionNumber: questionNumber,
            question: question,
            userAnswer: userAnswers[index], // get user's answer for this question
          );
        },
      ),
    );
  }
}

class QuestionReviewCard extends StatelessWidget {
  final int questionNumber;
  final Map<String, dynamic> question;
  final dynamic userAnswer;

  const QuestionReviewCard({super.key, 
    required this.questionNumber,
    required this.question,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    bool isCorrect = userAnswer == question['correctAnswer'];
    Color answerColor = isCorrect ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Question $questionNumber: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: question['question'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            Text(
              '$userAnswer',
              style: TextStyle(
                color: answerColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (!isCorrect) // Only show the correct answer if the user's answer is incorrect
              Text(
                'Correct Answer: ${question['correctAnswer']}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
