import 'package:http/http.dart' as http;
import 'dart:convert';
import '../appconstants.dart';

class CategoryService {
  // List of available categories in GNews API
  static const List<String> categories = [
    'general',
    'world',
    'nation',
    'business',
    'technology',
    'entertainment',
    'sports',
    'science',
    'health'
  ];

  // Fetch articles by category
  Future<List<dynamic>> fetchArticlesByCategory({
    required String category,
    int page = 1,
    int max = 10,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://gnews.io/api/v4/top-headlines?category=$category&lang=en&max=$max&page=$page&token=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load articles for category: $category');
    }
  }
} 