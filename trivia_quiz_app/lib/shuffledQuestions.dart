import 'package:flutter/material.dart';

class ShuffledQuestionsWidget extends StatelessWidget {
  final List<dynamic> shuffledQuestions;

  const ShuffledQuestionsWidget({required this.shuffledQuestions});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: shuffledQuestions.map((questionText) {
        return Text(
          questionText.toString(),
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        );
      }).toList(),
    );
  }
}
