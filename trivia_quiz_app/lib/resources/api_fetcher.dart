// import 'dart:convert';
// import 'package:http/http.dart' as http;

// String baseUrl = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple";
// Future<List<Map<String, dynamic>>> fetchData() async {
//    final response = await http.get(Uri.parse(baseUrl));

//    if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     final List<dynamic> results = data['results'];

//     List<Map<String, dynamic>> dataList = [];

//     for (var result in results) {
//       List<dynamic> incorrectAnswers = result['incorrect_answers'];
//       dataList.add({
//         'categories': result['category'],
//         'types': result['type'],
//         'difficulteis': result['difficulty'],
//         'questions': result['question'],
//         'correctAnswers': result['correct_answer'],
//         'incorrect_answers': incorrectAnswers,
//       });
//     }
//     print(dataList);
//     return dataList;
//    }   

//    else {
//     throw Exception ('Failed to load data');
//    }
// }