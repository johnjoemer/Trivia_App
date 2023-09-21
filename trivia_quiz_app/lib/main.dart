import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
import 'package:trivia_quiz_app/services/database_helper.dart';

String dispName = "";
bool showText = false;

void main() async {
  runApp(const MyApp());

  final dbHelper = DatabaseHelper();
  final allScores = await dbHelper.getAllScores();

  for (final score in allScores){
    final playerName = score['playerName'];
    final playerScore = score['score'];
    print('Player Name: $playerName, Score: $playerScore');
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 4, 15, 116),),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _playerName = TextEditingController();
  bool namePresent = true;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: const Text("Open Trivia", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
      ),

      body: Center(
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
          // if(showText)
          // Text('Highest Score: $dispName = $highScore'),
          const Text("Enter your name to proceed"),

          const SizedBox(height: 15),

          SizedBox(
            width: 400,
            height: 60,
            child: TextField(
              controller: _playerName,
              onChanged: (playerName){
                setState(() {
                  namePresent = false;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Player Name",
              ),
            ),
          ),

          const SizedBox(height: 5),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: namePresent ? null:  () async {
                //final username = _playerName.text;
                dispName = _playerName.text;
                

                Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text("Proceed"),
            ),
          ),

        ]
      ),
    )
          
    );
  }
}

class MyHomePageWithScore extends StatelessWidget {
  final String playerName;
  final int highestScore;

  MyHomePageWithScore({
    required this.playerName,
    required this.highestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Quiz App'),
      ),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Highest Score is: $highestScore by $playerName',
              style: const TextStyle(fontSize: 18),
            ),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 30, 181, 100),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                    ),
                  ),
                );
              },
              child: const Text(
                'Play Again',
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