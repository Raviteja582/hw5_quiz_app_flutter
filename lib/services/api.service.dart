import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static Future<List<dynamic>> fetchQuestions(
      int amount, String category, String difficulty, String type) async {
    final url =
        'https://opentdb.com/api.php?amount=$amount&category=$category&difficulty=$difficulty&type=$type';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
