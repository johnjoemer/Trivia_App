import 'package:flutter/material.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({super.key});

  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      title: const Text('Quiz Result'),
      centerTitle: true,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text("Total Questions")
                ),

                Flexible(
                  child: Text("5")
                ),
              ],
              
            ),
          ],
        ),

        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text("Score")
                ),

                Flexible(
                  child: Text("50%")
                ),
              ],
              
            ),
          ],
        ),

        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text("Correct Answers")
                ),

                Flexible(
                  child: Text("10/10")
                ),
              ],
              
            ),
          ],
        ),

        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text("Wrong Answers")
                ),

                Flexible(
                  child: Text("0/10")
                ),
              ],
              
            ),
          ],
        ),

        Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Home"),
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  width: 200,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text("Check Answers"),
                  ),
                ),
              ],
              
            ),
          ],
        ),

        
        

        

      ],
    )
  );
  }
}    