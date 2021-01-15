import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_models.g.dart';

@JsonSerializable()
class NewsResponse {
  String status;
  int totalResult;
  List<NewsArticle> articles;

  NewsResponse();

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

@JsonSerializable()
class NewsArticle {
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  String publishedAt;
  Source source;

  NewsArticle();

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleToJson(this);
}

@JsonSerializable()
class Source {
  String id;
  String name;

  Source();

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
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
  return articles;
}
