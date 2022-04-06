

class NewsResponse {
  NewsResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  String? status;
  int? totalResults;
  List<NewsArticle>? articles;

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<NewsArticle>.from(
            json["articles"].map((x) => NewsArticle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles != null ? List<dynamic>.from(articles!.map((x) => x.toJson())) : [],
      };
}

class NewsArticle {
  NewsArticle({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        source: Source.fromJson(json["source"]),
        author: json["author"] == null ? null : json["author"],
        title: json["title"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"] == null ? null : json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] == null ? null : json["content"],
      );

  factory NewsArticle.fromDbJson(Map<String, dynamic> json) => NewsArticle(
    source: Source(
      id: json["id"],
      name: json["name"],
    ),
    author: json["author"] == null ? null : json["author"],
    content: json["content"],
    description: json["description"] == null ? null : json["description"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    title: json["title"],
    url: json["url"],
    urlToImage: json["urlToImage"] == null ? null : json["urlToImage"],
  );

  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author == null ? null : author,
        "title": title,
        "description": description == null ? null : description,
        "url": url,
        "urlToImage": urlToImage == null ? null : urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content == null ? null : content,
      };

  Map<String, dynamic> toDbJson() => {
        "id": source?.id,
        "name": source?.toJson(),
        "author": author == null ? null : author,
        "title": title,
        "description": description == null ? null : description,
        "url": url,
        "urlToImage": urlToImage == null ? null : urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content == null ? null : content,
      };

  @override
  bool operator ==(Object other) {
    NewsArticle? otherNews;
    if (other is NewsArticle) otherNews = other;
    return this.url == otherNews?.url;
  }

  @override
  int get hashCode => (this.url?.length ?? 0) + (this.title?.length ?? 0);
}

class Source {
  Source({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name,
      };
}