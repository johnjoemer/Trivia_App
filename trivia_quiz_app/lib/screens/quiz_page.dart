import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_quiz_app/main.dart';
import 'package:trivia_quiz_app/screens/checkanswers_page.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
import 'dart:convert';
import 'package:trivia_quiz_app/screens/quiz_summary.dart';

String baseUrl = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple";
int questionCounter = 1;

class TriviaQuizPage extends StatefulWidget {
  @override
  _TriviaQuizPageState createState() => _TriviaQuizPageState();
}

class _TriviaQuizPageState extends State<TriviaQuizPage> {
  int correctAnswers = 0;
  bool isGameStarted = false;
  bool isGameOver = false;
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> questions = [];
  List<dynamic> userAnswers = [];

  Future<List<Map<String, dynamic>>>? questionsFuture;

  
  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http.get(
        Uri.parse(baseUrl)); //sends http get request

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
          'userAnswer': null, // Initialize user answer as null
        });
      }
      //print(questionList);
      return questionList; //After processing all trivia questions, the function returns the questionList
    }
    
    else {
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
        title: const Text('Trivia Quiz App'),
      ),
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isGameStarted)
            Center(
              child: ElevatedButton(
                onPressed: startGame,
                child: const Text('Start Game'),
              ),
            ),
            
          //checks if the game has started or is over
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
                    child: const Text('View All Questions and Answers'),
                  ),
                  
                  const SizedBox(height: 15),

                  SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 250, 158, 52),
                    ),
                    onPressed: () {
                      showText = true;
                      highScore = correctAnswers;
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    },
                    child: const Text(
                      'Home',
                      style: TextStyle(
                      color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ],
              )

            //else if the game is not over, it will continue showing the questions
            else
              Flexible(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: questionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator()
                      );
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
                          final questionNumber = index + 1;
                          final question = questions[index]; //retrieves questions at the current index
                          // List<dynamic> shuffledQuestions = [...question[index]];
                          // List<dynamic> shuffledQuestions = [question['question']];
                          // shuffledQuestions.shuffle();
                          final List<dynamic> allAnswers = [...question['incorrectAnswers'], question['correctAnswer']]; //store all answers / choices in a list
                          allAnswers.shuffle(); //shuffle the answers / choices
      
                          //then it will pass question, allAnswers, and handleAnswer to QuestionCard
                          return QuestionCard(
                            // shuffledQuestions : shuffledQuestions,
                            questionNumber: questionNumber,
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
                    }
                    
                    else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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

  void handleAnswer(bool isCorrect, dynamic selectedAnswer) {
    userAnswers.add(selectedAnswer);

    if (isCorrect) {
      setState(() {
        correctAnswers++;
      });
    }

    if (_pageController.page! < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 120),
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
  // final List<dynamic> shuffledQuestions;
  final int questionNumber;
  final Map<String, dynamic> question;
  final List<dynamic> allAnswers;
  final Function(dynamic) onAnswerSelected; // callback function that will be called when the user selects an answer
  

  const QuestionCard({super.key,
    // required this.shuffledQuestions, 
    required this.questionNumber,
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
          'Question $questionNumber | ${question['question']}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        // ShuffledQuestionsWidget(shuffledQuestions: shuffledQuestions),
        const SizedBox(height: 20),

        const SizedBox(height: 20),

        //for each answer in the allAnswer list, the function will be executed
        ...allAnswers.map((answer) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                questionCounter++;
                onAnswerSelected(answer);
              },
              child: Text(answer.toString()),
            ),
          );
        }),
        
        // Question Counter
        // Text('Question $questionCounter out of 10'),

        const SizedBox(height: 70),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 250, 158, 52),
          ),
          onPressed: () {
            showText = true;
            // highScore = correctAnswers;
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
          child: const Text(
            'Home',
            style: TextStyle(
            color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
