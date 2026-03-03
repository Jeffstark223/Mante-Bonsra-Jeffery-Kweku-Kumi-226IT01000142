import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/article_viewmodel.dart';
import '../models/article.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('News App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Top News'),
              Tab(text: 'Categories'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: NewsSearchDelegate(),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Top News Tab
            Consumer<ArticleViewModel>(
              builder: (context, viewModel, child) {
                return RefreshIndicator(
                  onRefresh: () => viewModel.refreshArticles(),
                  child: _buildNewsList(
                    viewModel,
                    viewModel.articles,
                    viewModel.isLoading,
                    viewModel.errorMessage,
                    context,
                  ),
                );
              },
            ),
            
            // Categories Tab
            CategoriesView(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(
    ArticleViewModel viewModel,
    List<Article> articles,
    bool isLoading,
    String? error,
    BuildContext context,
  ) {
    // Show loading
    if (isLoading && articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Fetching latest news...'),
          ],
        ),
      );
    }
    
    // Show error
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.loadArticles(),
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show empty state
    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No articles available',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => viewModel.loadArticles(),
              child: Text('Refresh'),
            ),
          ],
        ),
      );
    }
    
    // Show articles list
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ArticleCard(article: article);
      },
    );
  }
}

// Article Card Widget
class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showArticleDetails(context, article);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  article.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Image not available'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          article.source,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        article.formattedDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // Title
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Description
                  Text(
                    article.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Read more button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Read more',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showArticleDetails(BuildContext context, Article article) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            children: [
              // Header with source and close button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            article.formattedDate,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            article.imageUrl!,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: Center(
                                  child: Text('Image not available'),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 16),
                      
                      // Title
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Content
                      Text(
                        article.content,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Read full article button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Would open browser to read full article'),
                              ),
                            );
                          },
                          icon: Icon(Icons.open_in_browser),
                          label: Text('Read Full Article'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Categories View
class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // Category chips
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.categories.length,
                itemBuilder: (context, index) {
                  final category = viewModel.categories[index];
                  final isSelected = viewModel.currentCategory == category;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(
                        category[0].toUpperCase() + category.substring(1),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          viewModel.loadCategoryNews(category);
                        }
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // News list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.refreshCategoryNews(),
                child: _buildCategoryNewsList(viewModel, context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryNewsList(ArticleViewModel viewModel, BuildContext context) {
    if (viewModel.isCategoryLoading && viewModel.categoryArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading category news...'),
          ],
        ),
      );
    }
    
    if (viewModel.categoryError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(viewModel.categoryError!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.refreshCategoryNews(),
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (viewModel.categoryArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No articles in this category'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.refreshCategoryNews(),
              child: Text('Refresh'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: viewModel.categoryArticles.length,
      itemBuilder: (context, index) {
        return ArticleCard(article: viewModel.categoryArticles[index]);
      },
    );
  }
}

// Search Delegate
class NewsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          final viewModel = Provider.of<ArticleViewModel>(context, listen: false);
          viewModel.clearSearch();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        final viewModel = Provider.of<ArticleViewModel>(context, listen: false);
        viewModel.clearSearch();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final viewModel = Provider.of<ArticleViewModel>(context, listen: false);
    
    // Trigger search when user submits
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      viewModel.searchNews(query);
    });
    
    return Consumer<ArticleViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isSearching) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Searching...'),
              ],
            ),
          );
        }
        
        if (viewModel.searchError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(viewModel.searchError!),
              ],
            ),
          );
        }
        
        if (viewModel.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No results found for "$query"',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: viewModel.searchResults.length,
          itemBuilder: (context, index) {
            return ArticleCard(article: viewModel.searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Search for news...',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}