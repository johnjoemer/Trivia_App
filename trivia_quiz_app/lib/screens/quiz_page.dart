import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_quiz_app/main.dart';
import 'package:trivia_quiz_app/screens/checkanswers_page.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
// import 'package:trivia_quiz_app/screens/home_page.dart';
import 'dart:convert';
import 'package:trivia_quiz_app/screens/quiz_summary.dart';
import 'package:trivia_quiz_app/services/database_helper.dart';

// String baseUrl = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple";
String baseUrl = "https://api.api-ninjas.com/v1/trivia?category=";
int questionCounter = 1;
int currentScore = 0;
int currentHighScore = 0;
// List<Map<String, dynamic>> highScoresList = [];

class TriviaQuizPage extends StatefulWidget {

  final String category;
  final String description;

  const TriviaQuizPage({super.key, 
    required this.category,
    required this.description,
  });

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
      print(questionList);
      return questionList; //After processing all trivia questions, the function returns the questionList
    }
    
    else {
      print('HTTP Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load questions');
    }
  }

  void _handleHomeButtonPressed() async {
    final highestScoreData = await DatabaseHelper().getHighestScore();

    if(highestScoreData != null){
      final playerName = highestScoreData['playerName'];
      final highestScore = highestScoreData['highestScore'] as int;

      // ignore: use_build_context_synchronously
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => MyHomePageWithScore(
            playerName: playerName,
            highestScore: highestScore,
          ),
        ),
      );
    }
    else {
      // Handle the case where no data is found 
      throw('no data found');
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isGameStarted)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  
                  padding: const EdgeInsets.all(24),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 120,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      
                      const SizedBox(height: 36),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.category,
                                  style: GoogleFonts.bungee(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 20
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            widget.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 38),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 46,
                            width: 130,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary,
                                onPrimary: Colors.white,
                              ),
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          SizedBox(
                            height: 46,
                            width: 130,
                            child: ElevatedButton(
                              onPressed: startGame,
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary,
                                onPrimary: Colors.white,
                              ),
                              child: const Text(
                                'Start Game',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
 
          //checks if the game has started or is over
          if (isGameStarted || isGameOver)
            if (isGameOver)
              Column(
                children: [
                  QuizSummary(correctAnswers: correctAnswers),

                  //button for viewing all the questions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0), // Add horizontal padding
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizReview(reviewList: questions, userAnswers: userAnswers),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          onPrimary: Colors.white,
                        ),
                        child: const Text(
                          'View All Questions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _handleHomeButtonPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                        onPrimary: Colors.white,
                      ),
                      child: const Text(
                        'High Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),

                  //home button icon after the quiz is done
                  Container(
                    margin: const EdgeInsets.only(top: 140.0),
                    decoration: const ShapeDecoration(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                      showText = true;
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      //view high score code _handleHomeButtonPressed();
                    },
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
                    
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    
                    else if (snapshot.hasData) {
                      questions = snapshot.data!;
                      return PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final questionNumber = index + 1;
                          final question = questions[index]; //retrieves questions at the current index
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
                              onHomeButtonPressed: _handleHomeButtonPressed,
                            );
                          },
                      );
                    }
                    
                    else {
                      return const Center(
                        child: CircularProgressIndicator()
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
    questionsFuture = fetchQuestions();
  });
   

  // ensure that _pageController is initialized
  if (_pageController.hasClients) {
    _pageController.jumpToPage(0);
  }
}

  void handleAnswer(bool isCorrect, dynamic selectedAnswer) async {
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

      // Insert or update the player's score in the database
      await DatabaseHelper().insertOrUpdateScore(dispName, correctAnswers);
    }
  }
}


class QuestionCard extends StatelessWidget {
  final int questionNumber;
  final Map<String, dynamic> question;
  final List<dynamic> allAnswers;
  final Function(dynamic) onAnswerSelected; // callback function that will be called when the user selects an answer
  final Function() onHomeButtonPressed;
  

  const QuestionCard({super.key,
    required this.questionNumber,
    required this.question,
    required this.allAnswers,
    required this.onAnswerSelected,
    required this.onHomeButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),

        // Content inside a white box
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                children: [

                  // For each answer in the allAnswers list, create a rounded button
                  ...allAnswers.map((answer) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            questionCounter++;
                            onAnswerSelected(answer);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            answer.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Home icon button inside the white box
                  Container(
                    margin: const EdgeInsets.only(top: 160.0),
                    decoration: const ShapeDecoration(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        showText = true;
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        Positioned(
          left: 24.0,
          right: 24.0,
          top: 100.0, // Adjust the top value to move the question number downward
          child: Column(
            children: [
              Text(
                'Question $questionNumber',
                style: GoogleFonts.bungee(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                question['question'],
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
