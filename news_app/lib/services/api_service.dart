import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  // Base URL for NewsAPI
  final String _baseUrl = 'newsapi.org';
  
  // IMPORTANT: Replace with your actual API key from https://newsapi.org/register
  // For testing, you can use this demo key (but sign up for your own)
  final String _apiKey = '42db161bef6b47cea7dee432a58a8050'; // Get from newsapi.org
  
  // Method to fetch news articles
  Future<List<Article>> fetchNewsArticles() async {
    try {
      // 1. Build the URI properly (using Uri.https, not string concatenation)
      final uri = Uri.https(
        _baseUrl,
        '/v2/top-headlines',
        {
          'country': 'us',        // Get US news
          'apiKey': _apiKey,
        },
      );
      
      print('Fetching from: $uri'); // For debugging
      
      // 2. Make the network request with timeout
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet.');
        },
      );
      
      // 3. Check status code
      if (response.statusCode == 200) {
        // 4. Parse JSON response
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        // 5. Check if articles exist
        if (jsonData['status'] == 'error') {
          throw Exception(jsonData['message'] ?? 'API Error');
        }
        
        final List<dynamic> articlesJson = jsonData['articles'] ?? [];
        
        // 6. Convert each JSON to Article model
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your NewsAPI key.');
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else {
        throw Exception('Failed to load news. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Method to fetch news by category
  Future<List<Article>> fetchNewsByCategory(String category) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/v2/top-headlines',
        {
          'country': 'us',
          'category': category,
          'apiKey': _apiKey,
        },
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> articlesJson = jsonData['articles'] ?? [];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category news');
      }
    } catch (e) {
      throw Exception('Error fetching category news: $e');
    }
  }

  // Method to search news
  Future<List<Article>> searchNews(String query) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/v2/everything',
        {
          'q': query,
          'apiKey': _apiKey,
          'pageSize': '20',
        },
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> articlesJson = jsonData['articles'] ?? [];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search news');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }
}