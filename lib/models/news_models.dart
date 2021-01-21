import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/resource.dart';
import 'package:news_app/utils/app_utils.dart';
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

NewsResponse welcomeFromJson(String str) =>
    NewsResponse.fromJson(json.decode(str));

String welcomeToJson(NewsResponse data) => json.encode(data.toJson());

class NewsResponse {
  NewsResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  String status;
  int totalResults;
  List<NewsArticle> articles;

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<NewsArticle>.from(
            json["articles"].map((x) => NewsArticle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
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

  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

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

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author == null ? null : author,
        "title": title,
        "description": description == null ? null : description,
        "url": url,
        "urlToImage": urlToImage == null ? null : urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content == null ? null : content,
      };

  @override
  bool operator ==(Object other) {
    NewsArticle otherNews;
    if (other is NewsArticle) otherNews = other;
    return this.url == otherNews?.url;
  }
}

class Source {
  Source({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name,
      };
}

Future<List<NewsArticle>> getNewsList(BuildContext context) async {
  final newsJsonString =
      await DefaultAssetBundle.of(context).loadString("assets/news.json");
  final json = jsonDecode(newsJsonString)['articles'];
  final newsJsonList = List.from(json);
  var articles = new List<NewsArticle>();
  for (final item in newsJsonList) {
    articles.add(NewsArticle.fromJson(item));
  }
  await Future.delayed(Duration(seconds: 3));
  return articles;
}

const NEWS_URL =
    'https://newsapi.org/v2/top-headlines?country=in&apiKey=96c1c14cda3d41fd8a1af286982fa02e&pageSize=10';

Future<Resource<List<NewsArticle>>> fetchNews(bool refresh) async {
  if (!refresh && NewsData.getInstance().newsList?.isNotEmpty == true) {
    return Resource.success(NewsData.getInstance().newsList);
  }
  if (!await hasNetworkConnection()) {
    return Resource.failure("No internet connection");
  }
  try {
    final response = await http.get(NEWS_URL);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body.isNotEmpty) {
      final newsJsonList = jsonDecode(response.body)['articles'];
      // print("newsJsonList => $newsJsonList");
      final List<NewsArticle> articles =
          List.from(newsJsonList).map((e) => NewsArticle.fromJson(e)).toList();
      print("articles => $articles");
      NewsData.getInstance().newsList = articles;
      return Resource.success(articles);
    } else {
      return Resource.failure(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
  return Resource.failure("Unknown error");
}

class NewsData {
  NewsData._privateConstructor();

  static NewsData _instance = NewsData._privateConstructor();

  static NewsData getInstance() => _instance;

  List<NewsArticle> newsList = <NewsArticle>[];
  List<NewsArticle> favorites = <NewsArticle>[];

  void updateFavorites(NewsArticle newsItem) {
    if (favorites == null) favorites = <NewsArticle>[];
    if (isFavorite(newsItem)) {
      favorites?.remove(newsItem);
    } else {
      favorites?.insert(0, newsItem);
    }
  }

  bool isFavorite(NewsArticle newsItem) {
    return favorites?.contains(newsItem) == true;
  }
}
