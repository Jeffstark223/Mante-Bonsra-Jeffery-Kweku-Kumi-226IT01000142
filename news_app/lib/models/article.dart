class Article {
  final String title;
  final String description;
  final String? imageUrl;
  final String source;
  final String publishedAt;
  final String content;
  final String url;

  Article({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.content,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title available',
      description: json['description'] ?? 'No description available',
      imageUrl: json['urlToImage'],
      source: json['source']?['name'] ?? 'Unknown Source',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? 'No content available',
      url: json['url'] ?? '',
    );
  }

  String get formattedDate {
    if (publishedAt.isEmpty) return 'Date unknown';
    try {
      final date = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Date unknown';
    }
  }
}