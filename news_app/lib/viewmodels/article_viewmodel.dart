import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleViewModel extends ChangeNotifier {
  // Dependencies
  final ApiService _apiService = ApiService();
  
  // State variables
  List<Article> _articles = [];
  List<Article> _categoryArticles = [];
  List<Article> _searchResults = [];
  bool _isLoading = false;
  bool _isCategoryLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String? _categoryError;
  String? _searchError;
  String _currentCategory = 'general';
  
  // Getters for UI
  List<Article> get articles => _articles;
  List<Article> get categoryArticles => _categoryArticles;
  List<Article> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isCategoryLoading => _isCategoryLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String? get categoryError => _categoryError;
  String? get searchError => _searchError;
  String get currentCategory => _currentCategory;
  
  // Available categories
  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Load main news articles
  Future<void> loadArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _articles = await _apiService.fetchNewsArticles();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Load news by category
  Future<void> loadCategoryNews(String category) async {
    _currentCategory = category;
    _isCategoryLoading = true;
    _categoryError = null;
    notifyListeners();
    
    try {
      _categoryArticles = await _apiService.fetchNewsByCategory(category);
      _isCategoryLoading = false;
      notifyListeners();
    } catch (e) {
      _isCategoryLoading = false;
      _categoryError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Search news
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isSearching = true;
    _searchError = null;
    notifyListeners();
    
    try {
      _searchResults = await _apiService.searchNews(query);
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _isSearching = false;
      _searchError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Clear search results
  void clearSearch() {
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }

  // Refresh all news
  Future<void> refreshArticles() async {
    await loadArticles();
  }

  // Refresh category news
  Future<void> refreshCategoryNews() async {
    await loadCategoryNews(_currentCategory);
  }
}