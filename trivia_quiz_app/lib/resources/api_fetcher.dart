import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple";
Future<List<Map<String, dynamic>>> fetchData() async {
   final response = await http.get(Uri.parse(baseUrl));

   if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> results = data['results'];

    List<Map<String, dynamic>> dataList = [];

    for (var result in results) {
      dataList.add({
        'category': result['category'],
        'type': result['type'],
        'difficulty': result['difficulty'],
        'question': result['question'],
        'correct_answer': result['correct_answer'],
        'incorrect_answer': result['incorrect_answer'],
      });
    }
    return dataList;
   }   
   
   else {
    throw Exception ('Failed to load data');
   }
}