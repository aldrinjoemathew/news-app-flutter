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

List<NewsArticle> getNewsList() {
  var articles = new List<NewsArticle>();
  for (int i = 1; i <= 10; i++) {
    var news = NewsArticle();
    news.title = "Title $i";
    news.description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    news.urlToImage = "https://i.guim.co.uk/img/media/35aeafa11eb387d6ebd42027b6fb9a0fcf3c4323/0_333_5269_3163/master/5269.jpg?width=1200&height=630&quality=85&auto=format&fit=crop&overlay-align=bottom%2Cleft&overlay-width=100p&overlay-base64=L2ltZy9zdGF0aWMvb3ZlcmxheXMvdGctbGl2ZS5wbmc&enable=upscale&s=aefa89872b03d19d596108137e6f0b59";
    articles.add(news);
  }
  return articles;
}
