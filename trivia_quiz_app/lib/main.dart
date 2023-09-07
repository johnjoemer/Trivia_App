
import 'package:flutter/material.dart';
// import 'package:trivia_quiz_app/resources/api_fetcher.dart';
import 'package:trivia_quiz_app/screens/home_page.dart';
// import 'package:trivia_quiz_app/screens/home_page.dart';
// import 'package:trivia_quiz_app/resources/api_fetcher.dart';
// import 'package:trivia_quiz_app/screens/quizfinish_page.dart';


void main() async {
  runApp(const MyApp());
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

  // Future<List<Map<String, dynamic>>>? _dataFuture;
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
              // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
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
              onPressed: namePresent ? null:  () async { // 
                // setState(() {
                //   _dataFuture = fetchData(); 
                // });
              // await _dataFuture; // uncomment if itetest ang data fetching
              Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const HomePage()),
              );
              },
              child: const Text("Proceed"),
            ),
          ),

          // Pang test lang to ng data fetching, uncomment or comment out na lang if need
          // const SizedBox(height: 20),
          // FutureBuilder<List<Map<String, dynamic>>>(
          //   future: _dataFuture,
          //   builder: (context, snapshot){
          //     if (snapshot.connectionState == ConnectionState.waiting){
          //       return const CircularProgressIndicator();
          //     }
          //     else if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     }
          //     else if (!snapshot.hasData){
          //       return const Text('Press the Proceed button to fetch data.');
          //     }
          //     else{
          //       final data = snapshot.data!;
          //       // print('Category: ${data.first['category']}');
          //       return Text('Difficulty: ${data.first['difficulty']}');
          //     }
          //   },
          // ),


        ]
      ),
    )
          
    );
  }
}



