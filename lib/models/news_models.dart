class NewsResponse {
  String status;
  int totalResult;
  List<NewsArticle> articles;
}

class NewsArticle {
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  String publishedAt;
  Source source;
}

class Source {
  String id;
  String name;
}

void main() {
  var articles = new List<NewsArticle>();
  for (int i = 0; i < 10; i++) {
    var news = NewsArticle();
    news.title = "Title $i";
    articles.add(news);
  }
}
