import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/postservices.dart';
import '../services/category_service.dart';


class ArticleProvider with ChangeNotifier {
  final Postservices _postService = Postservices();
  final CategoryService _categoryService = CategoryService();
  
  List<Article> _articles = [];
  String? _error;
  bool _isLoading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _currentCategory = 'general';
  final List<String> _categories = ['general', 'technology', 'business', 'sports', 'entertainment'];
  bool _hasInitiallyLoaded = false; // Track if we've successfully loaded articles at least once

  List<Article> get articles => _articles;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String get currentCategory => _currentCategory;
  List<String> get categories => _categories;
  bool get hasInitiallyLoaded => _hasInitiallyLoaded;

  Future<void> fetchArticles() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final articles = await _postService.fetchArticles(
        page: 1, 
        category: _currentCategory != 'general' ? _currentCategory : null
      );
      _articles = articles.map((json) => Article.fromJson(json)).toList();
      _currentPage = 1;
      _hasMore = articles.isNotEmpty;
      _hasInitiallyLoaded = true; // Mark that we've successfully loaded articles
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArticlesByCategory(String category) async {
    if (_currentCategory == category || _isLoading) return;
    
    _currentCategory = category;
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
    
    try {
      final articles = await _categoryService.fetchArticlesByCategory(
        category: category,
        page: 1,
      );
      _articles = articles.map((json) => Article.fromJson(json)).toList();
      _hasMore = articles.isNotEmpty;
      _hasInitiallyLoaded = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreArticles() async {
    if (_isLoading || _loadingMore || !_hasMore) return;

    _loadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final articles = _currentCategory == 'general'
          ? await _postService.fetchArticles(page: nextPage)
          : await _categoryService.fetchArticlesByCategory(
              category: _currentCategory,
              page: nextPage,
            );
      
      if (articles.isNotEmpty) {
        _articles.addAll(articles.map((json) => Article.fromJson(json)));
        _currentPage = nextPage;
        _hasMore = articles.length >= 10; // Assuming page size is 10
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _error = e.toString();
      _hasMore = false;
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  // Method to handle offline/online transitions
  void handleConnectivityChange(bool isConnected) {
    if (isConnected && _error != null && _error!.contains('offline')) {
      // If we're back online and we previously showed an offline error, refresh data
      _error = null;
      fetchArticles();
    }
  }
}