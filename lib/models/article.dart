class Article {
  final String? title;
  final String? description;
  final String? content;
  final String? url;
  final String? image;
  final String? publishedAt;
  final String? source;

  Article({
    this.title,
    this.description,
    this.content,
    this.url,
    this.image,
    this.publishedAt,
    this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      content: json['content'],
      url: json['url'],
      image: json['image'],
      publishedAt: json['publishedAt'],
      source: json['source']?['name'],
    );
  }
} 