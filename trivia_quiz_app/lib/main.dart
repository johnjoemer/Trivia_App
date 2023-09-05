
import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/screens/checkanswers_page.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
import 'package:trivia_quiz_app/screens/quiz_page.dart';
import 'package:trivia_quiz_app/screens/quizfinish_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 4, 15, 116),),
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

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: const Text("Home Page", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
      ),

      body: Center(
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
          const Text("Please Select One"),

          const SizedBox(height: 15),

          SizedBox(
          width: 200,
          child: ElevatedButton(
            child: const Text("Adult"),
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ),
          
          const SizedBox(height: 5),

          SizedBox(
          width: 200,
          child: ElevatedButton(
            child: const Text("Child"),
            onPressed: (){
             Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const QuizPage()),
              );
            },
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          width: 200,
          child: ElevatedButton(
            child: const Text("Future Builder"),
            onPressed: (){
             Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const FinishPage()),
              );
            },
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          width: 200,
          child: ElevatedButton(
            child: const Text("HTTP Request"),
            onPressed: (){
             Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const CheckPage()),
              );
            },
          ),
        ),

        ]
      ),
    )
          
    );
  }
}


