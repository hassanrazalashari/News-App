import 'dart:convert';

import 'package:flutter_news_app/models/article.dart';
import 'package:http/http.dart' as http;
import 'news_repository.dart';

class NewsApi extends NewsRepository {
  final keyApi = '310e9e608f1e4367b5da7b24b9c3402a';

  @override
  Future<List<Article>> fetchAllNews() async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$keyApi';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final json = body['articles']!;

      return json.map<Article>((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception(
          'Status Code: ${response.statusCode} Body: ${response.body}');
    }
  }

  @override
  Future<List<Article>> fetchCategory(Category category) async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&category=${category.name}&apiKey=$keyApi';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final json = body['articles']!;

      return json.map<Article>((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception(
          'Status Code: ${response.statusCode} Body: ${response.body}');
    }
  }

  Future<List<Article>> searchNews(String query) async {
    final url = 'https://newsapi.org/v2/everything?q=$query&apiKey=$keyApi';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final json = body['articles']!;

      return json.map<Article>((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception(
          'Status Code: ${response.statusCode} Body: ${response.body}');
    }
  }
}
