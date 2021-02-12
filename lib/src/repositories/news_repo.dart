import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/src/models/news_category.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/models/resource.dart';
import 'package:news_app/src/utils/app_utils.dart';

class NewsRepo {
  static const NEWS_URL = "https://newsapi.org";
  static const NEWS_URL_PATH = "/v2/top-headlines";
  static const NEWS_API_KEY = "96c1c14cda3d41fd8a1af286982fa02e";
  static const PAGE_SIZE = 10;

  static Future<List<NewsArticle>> getNewsList(BuildContext context) async {
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

  static Future<Resource<List<NewsArticle>>> fetchNews(
      {bool refresh = false, bool paginate = false, String category}) async {
    if (!refresh &&
        !paginate &&
        NewsData.getInstance().newsList?.isNotEmpty == true) {
      return Resource.success(NewsData.getInstance().newsList);
    }
    if (!await hasNetworkConnection()) {
      return Resource.failure("No internet connection");
    }
    try {
      int page = 1;
      if (paginate) page = NewsData.getInstance().getPage(pageSize: PAGE_SIZE);
      if (page == null || page < 1) return Resource.empty();
      var queryParams = {
        'country': 'in',
        'page': '$page',
        'pageSize': '$PAGE_SIZE'
      };
      if (category?.isNotEmpty == true) {
        queryParams['category'] = category;
      }
      Uri uri = Uri.parse("$NEWS_URL$NEWS_URL_PATH");
      uri = uri.replace(queryParameters: queryParams);
      print("URI: $uri");
      final response = await http.get(
        uri,
        headers: {HttpHeaders.authorizationHeader: NEWS_API_KEY},
      );
      // print("Request: ${response.request}");
      // print("Headers: ${response.headers}");
      // print("Response: ${response.body}");
      if (response.statusCode == 200 && response.body != null) {
        final newsJsonList = jsonDecode(response.body)['articles'];
        // print("newsJsonList => $newsJsonList");
        final List<NewsArticle> articles = List.from(newsJsonList)
            .map((e) => NewsArticle.fromJson(e))
            .toList();
        if (articles.isEmpty) {
          return Resource.empty();
        } else {
          if (refresh) {
            NewsData.getInstance().newsList = articles;
          } else {
            NewsData.getInstance().addNewsArticles(articles);
          }
          return Resource.success(NewsData.getInstance().newsList);
        }
      } else {
        return Resource.failure(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return Resource.failure("Unknown error");
  }

  static void updateCategory(String selectedCategory) {
    NewsData.getInstance().category = selectedCategory;
  }

  static List<NewsCategory> getNewsCategories() {
    return [
      NewsCategory("business", imageAsset: "assets/ic_category_business.png"),
      NewsCategory("entertainment",
          imageAsset: "assets/ic_category_entertainment.png"),
      NewsCategory("general", imageAsset: "assets/ic_category_general.png"),
      NewsCategory("health", imageAsset: "assets/ic_category_health.png"),
      NewsCategory("science", imageAsset: "assets/ic_category_science.png"),
      NewsCategory("sports", imageAsset: "assets/ic_category_sports.png"),
      NewsCategory("technology",
          imageAsset: "assets/ic_category_technology.png")
    ];
  }
}

class NewsData {
  String category;

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

  void addNewsArticles(List<NewsArticle> articles) {
    if (newsList.isEmpty != false) {
      newsList = [];
    }
    newsList.addAll(articles);
  }

  int getPage({int pageSize = 10}) {
    if (newsList.isEmpty != false) return 1;
    if (newsList.length % pageSize == 0)
      return (newsList.length ~/ pageSize) + 1;
    else
      return null;
  }
}
