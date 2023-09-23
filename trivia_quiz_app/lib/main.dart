import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
import 'package:trivia_quiz_app/services/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';


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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 83, 117, 255),),
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quizzy',
                      style: GoogleFonts.bungee(
                        fontSize: 50,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      'Quest',
                      style: GoogleFonts.bungee(
                        fontSize: 50,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 140,
                      child: Icon(
                        Icons.category,
                        color: Theme.of(context).colorScheme.primary,
                        size: 120,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: 400,
              height: 60,
              child: TextField(
                controller: _playerName,
                onChanged: (playerName) {
                  setState(() {
                    namePresent = false;
                  });
                },
                
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  
                  labelText: "Player Name",
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: namePresent ? null:  () async {
                  //final username = _playerName.text;
                  dispName = _playerName.text;
                  Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Text("Proceed"),
              ),
            ),
          ]
        ),
      )      
    );
  }
}

class MyHomePageWithScore extends StatefulWidget {
  final String playerName;
  final int highestScore;

  MyHomePageWithScore({
    required this.playerName,
    required this.highestScore,
  });

  @override
  State<MyHomePageWithScore> createState() => _MyHomePageWithScoreState();
}

class _MyHomePageWithScoreState extends State<MyHomePageWithScore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(34.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Top Score',
                style: GoogleFonts.bungee(
                  fontSize: 40,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2), 
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12.0), 
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white, 
                          size: 40.0,
                        ),
                      ),
                    ),

                    SizedBox(height: 22.0), 

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, 
                      children: [
                        Text(
                          '  Name    :',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary, 
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(width: 6.0), 

                        Text(
                          '   ${widget.playerName}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary, 
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, 
                      children: [
                        Text(
                          '  Score    :',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary, 
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(width: 6.0), 

                        Text(
                          '   ${widget.highestScore}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary, 
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary, 
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                      child: const Text(
                        'New Player',
                        style: TextStyle(
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20.0), 

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary, 
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: const Text(
                        'Play Again',
                        style: TextStyle(
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}