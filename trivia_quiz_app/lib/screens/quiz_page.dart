// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/screens/quizfinish_page.dart';
// import 'package:trivia_quiz_app/resources/api_fetcher.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> widgets = [];
  int index = 0;

  @override
  Widget build(BuildContext context){
    
    if(index < 10){
      widgets.clear();
      widgets.add(Text('Question Field $index'));
      widgets.add(ElevatedButton(
        onPressed: () {
          
        },
        child: Text('Answer 1'),
      ));
      widgets.add(ElevatedButton(
        onPressed: () {
          
        },
        child: Text('Answer 2'),
      ));
      widgets.add(ElevatedButton(
        onPressed: () {
          
        },
        child: Text('Answer 3'),
      ));
      widgets.add(ElevatedButton(
        onPressed: () {
          
        },
        child: Text('Answer 4'),
      ));
      if(index < 9){
        widgets.add(ElevatedButton(
        onPressed: () {
          setState(() {
            index++;
          });
        },
        child: Text('Next'),
      ));
      }
      else if(index == 9){
        widgets.add(ElevatedButton(
          onPressed:() {
            setState(() {
              index = 0;
            });
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const FinishPage()),
            );
          },
          child: Text('Finish'),
        ));
      }
    }
    else{
      throw Exception("Can't load page");
    }
    

    return Scaffold(
      appBar: AppBar(
      title: const Text('Quiz Category Here'),
      centerTitle: true,
    ),
    body:Column(
      children: widgets,
    ),
    );
  }
}