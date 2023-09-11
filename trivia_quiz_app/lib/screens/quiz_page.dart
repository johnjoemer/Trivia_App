import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(quiz_page());
}

class quiz_page extends StatelessWidget {
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

  Future<List<Map<String, dynamic>>>? questionsFuture;

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http.get(
        Uri.parse('https://opentdb.com/api.php?amount=10&category=9')); //sends http get request

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body); //the JSON from the HTTP is decoded
      final List<dynamic> results = jsonData['results']; //extracts the result 

      List<Map<String, dynamic>> questionList = []; //empty list for the trivia questions

      for (var result in results) { //iterate through each questions in the result list
        List<dynamic> incorrectAnswers = result['incorrect_answers']; // extracts the 'incorrect_answers' from the trivia question
        questionList.add({
          'category': result['category'],
          'type': result['type'],
          'difficulty': result['difficulty'],
          'question': result['question'],
          'correctAnswer': result['correct_answer'],
          'incorrectAnswers': incorrectAnswers,
        });
      }

      return questionList; //After processing all trivia questions, the function returns the questionList
    }
    
    else {
      throw Exception('Failed to load questions');
    }
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
          //checks if the game has not started yet and display a "start game" button
          if (!isGameStarted)
            ElevatedButton(
              onPressed: startGame,
              child: Text('Start Game'),
            ),
          
          //checks if the game has started or is over
          if (isGameStarted || isGameOver)
            // if the game is over, it will call QuizSummary and show how many correct answers the player gets
            if (isGameOver)
              QuizSummary(correctAnswers: correctAnswers)
            //else if the game is not over, it will continue showing the questions
            else
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: questionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    
                    else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    
                    else if (snapshot.hasData) {
                      questions = snapshot.data!;
                      return PageView.builder(
                        controller: _pageController,
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index]; //retrieves questions at the current index
                          final List<dynamic> allAnswers = [...question['incorrectAnswers'], question['correctAnswer']]; //store all answers / choices in a list
                          allAnswers.shuffle(); //shuffle the answers / choices

                          //then it will pass question, allAnswers, and handleAnswer to QuestionCard
                          return QuestionCard(
                            question: question,
                            allAnswers: allAnswers,
                            onAnswerSelected: handleAnswer,
                          );
                        },
                      );
                    }
                    
                    else {
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
    questionsFuture = fetchQuestions(); // Start fetching questions
  });

  // ensure that _pageController is initialized
  if (_pageController.hasClients) {
    _pageController.jumpToPage(0);
  }
}

  void handleAnswer(bool isCorrect) {
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
  final Function(bool) onAnswerSelected; // callback function that will be called when the user selects an answer

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
        //print the questions
        Text(
          question['question'],
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 20),

        //for each answer in the allAnswer list, the function will be executed
        ...allAnswers.map((answer) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              onPressed: () {
                onAnswerSelected(answer == question['correctAnswer']);
              },
              child: Text(answer),
            ),
          );
        }),
      ],
    );
  }
}

//once the game is done, it will provide the score and an option to start the game again
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
