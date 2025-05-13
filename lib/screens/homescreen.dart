import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_card.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch articles when the screen loads
    Future.microtask(() {
      Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
    });
    
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final articleProvider = Provider.of<ArticleProvider>(context, listen: false);
      if (!articleProvider.isLoading && !articleProvider.loadingMore && articleProvider.hasMore) {
        articleProvider.loadMoreArticles();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Articles", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
            },
          ),
        ],
      ),
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          return Column(
            children: [
              // Categories
              Container(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: articleProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = articleProvider.categories[index];
                    final isSelected = category == articleProvider.currentCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () {
                          articleProvider.fetchArticlesByCategory(category);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected ? Colors.blue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.black,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // Articles list
              Expanded(
                child: _buildArticlesList(articleProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArticlesList(ArticleProvider articleProvider) {
    // Show loading indicator for initial load
    if (articleProvider.isLoading && articleProvider.articles.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Show error message if there's an error and no articles
    if (articleProvider.error != null && articleProvider.articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${articleProvider.error}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => articleProvider.fetchArticles(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    // Show no articles message if there are no articles to display
    if (articleProvider.articles.isEmpty) {
      return Center(
        child: Text('No articles found'),
      );
    }
    
    // Show articles list with refresh indicator
    return RefreshIndicator(
      onRefresh: () async {
        await articleProvider.fetchArticles();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: articleProvider.articles.length + (articleProvider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more
          if (index == articleProvider.articles.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: articleProvider.loadingMore
                    ? CircularProgressIndicator()
                    : SizedBox.shrink(),
              ),
            );
          }

          // Show article card
          final article = articleProvider.articles[index];
          return ArticleCard(
            article: article,
            currentCategory: articleProvider.currentCategory,
          );
        },
      ),
    );
  }
}