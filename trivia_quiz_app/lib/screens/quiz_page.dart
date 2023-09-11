import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia Quiz App',
      home: TriviaQuizPage(),
    );
  }
}

class TriviaQuizPage extends StatefulWidget {
  @override
  _TriviaQuizPageState createState() => _TriviaQuizPageState();
}

class _TriviaQuizPageState extends State<TriviaQuizPage> {
  int correctAnswers = 0;
  bool isGameStarted = false;
  bool isGameOver = false;
  PageController _pageController = PageController();
  List<Map<String, dynamic>> questions = [];
  List<dynamic> userAnswers = [];

  Future<List<Map<String, dynamic>>>? questionsFuture;

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http.get(
        Uri.parse('https://opentdb.com/api.php?amount=10&category=9'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];

      List<Map<String, dynamic>> questionList = [];

      for (var result in results) {
        List<dynamic> incorrectAnswers = result['incorrect_answers'];
        questionList.add({
          'category': result['category'],
          'type': result['type'],
          'difficulty': result['difficulty'],
          'question': result['question'],
          'correctAnswer': result['correct_answer'],
          'incorrectAnswers': incorrectAnswers,
          'userAnswer': null, // Initialize user answer as null
        });
      }

      return questionList;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  void initState() {
    super.initState();
    userAnswers = [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Quiz App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isGameStarted)
            ElevatedButton(
              onPressed: startGame,
              child: Text('Start Game'),
            ),
          if (isGameStarted || isGameOver)
            if (isGameOver)
              Column(
                children: [
                  QuizSummary(correctAnswers: correctAnswers),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              QuizReview(reviewList: questions, userAnswers: userAnswers),
                        ),
                      );
                    },
                    child: Text('View All Questions and Answers'),
                  ),
                ],
              )
            else
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: questionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      questions = snapshot.data!;
                      return PageView.builder(
                        controller: _pageController,
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index];
                          final List<dynamic> allAnswers = [
                            ...question['incorrectAnswers'],
                            question['correctAnswer']
                          ];
                          allAnswers.shuffle();
                          return QuestionCard(
                            question: question,
                            allAnswers: allAnswers,
                            onAnswerSelected: (selectedAnswer) {
                              handleAnswer(
                                  selectedAnswer == question['correctAnswer'],
                                  selectedAnswer);
                            },
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
        ],
      ),
    );
  }

  void startGame() {
    setState(() {
      correctAnswers = 0;
      isGameStarted = true;
      isGameOver = false;
      questionsFuture = fetchQuestions();
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void handleAnswer(bool isCorrect, dynamic selectedAnswer) {
    userAnswers.add(selectedAnswer);

    if (isCorrect) {
      setState(() {
        correctAnswers++;
      });
    }

    if (_pageController.page! < questions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      setState(() {
        isGameOver = true;
      });
    }
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final List<dynamic> allAnswers;
  final Function(dynamic) onAnswerSelected;

  QuestionCard({
    required this.question,
    required this.allAnswers,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ...allAnswers.map((answer) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              onPressed: () {
                onAnswerSelected(answer);
              },
              child: Text(answer.toString()),
            ),
          );
        }),
      ],
    );
  }
}

class QuizSummary extends StatelessWidget {
  final int correctAnswers;

  QuizSummary({required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Quiz Completed!'),
        Text('Correct Answers: $correctAnswers'),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Start Again'),
        ),
      ],
    );
  }
}

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
