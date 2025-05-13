class MyArticleListClass {
  int? totalArticles;
  List<Article>? articles;

  MyArticleListClass({this.totalArticles, this.articles});

  MyArticleListClass.fromJson(Map<String, dynamic> json) {
    totalArticles = json['totalArticles'] ?? 0;
    articles = [];
    if (json['articles'] != null && json['articles'] is List) {
      json['articles'].forEach((v) {
        if (v != null) {
          articles!.add(Article.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalArticles'] = totalArticles ?? 0;
    data['articles'] = articles?.map((v) => v.toJson()).toList() ?? [];
    return data;
  }
}

class Article {
  String? title;
  String? description;
  String? content;
  String? url;
  String? image;
  String? publishedAt;
  Source? source;

  Article({
    this.title,
    this.description,
    this.content,
    this.url,
    this.image,
    this.publishedAt,
    this.source,
  });

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString().trim();
    description = json['description']?.toString().trim();
    content = json['content']?.toString().trim();
    url = json['url']?.toString().trim();
    image = json['image']?.toString().trim();
    publishedAt = json['publishedAt']?.toString().trim();
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title ?? '';
    data['description'] = description ?? '';
    data['content'] = content ?? '';
    data['url'] = url ?? '';
    data['image'] = image ?? '';
    data['publishedAt'] = publishedAt ?? '';
    data['source'] = source?.toJson() ?? {};
    return data;
  }

  bool get isEmpty => 
    (title?.isEmpty ?? true) && 
    (description?.isEmpty ?? true) && 
    (content?.isEmpty ?? true) && 
    (url?.isEmpty ?? true) && 
    (image?.isEmpty ?? true) && 
    (publishedAt?.isEmpty ?? true) && 
    (source == null);
}

class Source {
  String? name;
  String? url;

  Source({this.name, this.url});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString().trim();
    url = json['url']?.toString().trim();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name ?? '';
    data['url'] = url ?? '';
    return data;
  }

  bool get isEmpty => (name?.isEmpty ?? true) && (url?.isEmpty ?? true);
}