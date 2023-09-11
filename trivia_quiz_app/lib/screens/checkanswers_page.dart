import 'package:flutter/material.dart';

class QuizReview extends StatelessWidget {
  final List<Map<String, dynamic>> reviewList;
  final List<dynamic> userAnswers;

  QuizReview({required this.reviewList, required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Review'),
      ),
      body: ListView.builder(
        itemCount: reviewList.length,
        itemBuilder: (context, index) {
          final question = reviewList[index];

          return QuestionReviewCard(
            question: question,
            userAnswer: userAnswers[index], // get user's answer for this question
          );
        },
      ),
    );
  }
}

class QuestionReviewCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final dynamic userAnswer;

  QuestionReviewCard({
    required this.question,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    bool isCorrect = userAnswer == question['correctAnswer'];
    Color answerColor = isCorrect ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              '${userAnswer}',
              style: TextStyle(
                color: answerColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            if (!isCorrect) // Only show the correct answer if the user's answer is incorrect
              Text(
                'Correct Answer: ${question['correctAnswer']}',
                style: TextStyle(
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
