import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/main.dart';
import 'package:trivia_quiz_app/screens/quiz_page.dart';

int highScore = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 4, 15, 116),),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String defaultURL = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple";
  
  void categoryNum(int num) {
    setState(() {
      baseUrl = defaultURL.replaceAllMapped(
            RegExp(r'category=\d+'),
            (match) => 'category=$num',
          );
    });
    // print(baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text (
              "Hi, $dispName!",
              style: const TextStyle(fontSize: 30),
            ),

            const SizedBox(
              height: 25,
            ),

            //General Knowledge
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  categoryNum(9);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TriviaQuizPage()),
                  );
                 },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Text( 'General Knowledge' ),
              )
            ),

            //Animals
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(27);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TriviaQuizPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Text( 'Animals' ),
              )
            ),

            //Vehicles
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(28);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TriviaQuizPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Text( 'Vehicles' ),
              )
            ),

            //Science: Computers
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(18);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TriviaQuizPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Text( 'Science: Computers' ),
              )
            ),

            //Science: Mathematics
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(15);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TriviaQuizPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Text( 'Video Games' ),
              )
            ),

            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 250, 158, 52),
              ),
              onPressed: () {
                questionCounter = 1;
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
        ),
      ),
    );
  }
}
