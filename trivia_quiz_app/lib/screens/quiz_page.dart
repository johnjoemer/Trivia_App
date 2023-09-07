// import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:trivia_quiz_app/resources/api_fetcher.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      title: const Text('Quiz Category Here'),
      centerTitle: true,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
       
        Container(
        padding:const EdgeInsets.all(5),
          child: Column(
            children: [
              const SizedBox(
                width: 500,
                height: 300,
                child: Text('Question Field'),
              ),

              const SizedBox(height: 7),

              SizedBox(
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                
                  },
                  child: const Text("Answer 1"),
                ),
              ),

              const SizedBox(height: 7),

              SizedBox(
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                
                  },
                  child: const Text("Answer 2"),
                ),
              ),

               const SizedBox(height: 7),

              SizedBox(
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                
                  },
                  child: const Text("Answer 3"),
                ),
              ),

               const SizedBox(height: 7),

              SizedBox(
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                
                  },
                  child: const Text("Answer 4"),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                
                  },
                  child: const Text("Next"),
                ),
              ),


            ],
          )
        ),
      ]
    ),
    );
  }
}
    
    
