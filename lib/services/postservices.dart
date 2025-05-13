import 'dart:convert';
import 'package:http/http.dart' as http;
import '../appconstants.dart';

class Postservices {

Future<List<dynamic>> fetchArticles({int page = 1, String? category}) async {
  final response = await http.get(
    Uri.parse('https://gnews.io/api/v4/search?q=flutter&lang=en&max=10&page=$page${category != null ? '&topic=$category' : ''}&token=$apiKey'),
  );
  print("article list:: ${response.body}");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['articles'];
  } else {
    throw Exception('Failed to load articles');
  }
}

}