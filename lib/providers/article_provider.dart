import 'package:flutter/foundation.dart';
import 'package:gnews_article/models/articlelist_screen_model.dart';
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

  List<Article> get articles => _articles.where((article) => !article.isEmpty).toList();
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String get currentCategory => _currentCategory;
  List<String> get categories => List.unmodifiable(_categories);
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
      
      if (articles == null || articles.isEmpty) {
        _error = 'No articles found';
        _articles = [];
        _hasMore = false;
      } else {
        _articles = articles
            .map((json) => Article.fromJson(json))
            .where((article) => !article.isEmpty)
            .toList();
        _currentPage = 1;
        _hasMore = _articles.isNotEmpty;
        _hasInitiallyLoaded = true;
      }
    } catch (e) {
      _error = e.toString();
      _articles = [];
      _hasMore = false;
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
      
      if (articles == null || articles.isEmpty) {
        _error = 'No articles found in this category';
        _articles = [];
        _hasMore = false;
      } else {
        _articles = articles
            .map((json) => Article.fromJson(json))
            .where((article) => !article.isEmpty)
            .toList();
        _hasMore = _articles.isNotEmpty;
        _hasInitiallyLoaded = true;
      }
    } catch (e) {
      _error = e.toString();
      _articles = [];
      _hasMore = false;
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
      
      if (articles != null && articles.isNotEmpty) {
        final newArticles = articles
            .map((json) => Article.fromJson(json))
            .where((article) => !article.isEmpty)
            .toList();
            
        if (newArticles.isNotEmpty) {
          _articles.addAll(newArticles);
          _currentPage = nextPage;
          _hasMore = newArticles.length >= 10;
        } else {
          _hasMore = false;
        }
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