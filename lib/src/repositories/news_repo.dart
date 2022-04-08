import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/models/resource.dart';
import 'package:news_app/src/utils/app_utils.dart';

class NewsRepo {
  static const NEWS_URL = "https://newsapi.org";
  static const NEWS_URL_PATH = "/v2/top-headlines";
  static const NEWS_API_KEY = "dfb1b2de8ed5464cb6ca6d242afd32f4";
  static const PAGE_SIZE = 10;
  static List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  static Future<List<NewsArticle>> getNewsList(BuildContext context) async {
    final newsJsonString =
        await DefaultAssetBundle.of(context).loadString("assets/news.json");
    final json = jsonDecode(newsJsonString)['articles'];
    final newsJsonList = List.from(json);
    List<NewsArticle> articles = [];
    for (final item in newsJsonList) {
      articles.add(NewsArticle.fromJson(item));
    }
    await Future.delayed(Duration(seconds: 3));
    return articles;
  }

  static Future<List<NewsArticle>> fetchNewsPage(int pageKey, {String? category}) async {
    if (!await hasNetworkConnection()) {
      return throw Exception("No internet connection");
    }
    var queryParams = {
      'country': 'in',
      'page': '$pageKey',
      'pageSize': '$PAGE_SIZE'
    };
    if (category?.isNotEmpty == true) {
      queryParams['category'] = category!;
    }
    Uri uri = Uri.parse("$NEWS_URL$NEWS_URL_PATH");
    uri = uri.replace(queryParameters: queryParams);
    print("URI: $uri");
    final response = await http.get(
      uri,
      headers: {HttpHeaders.authorizationHeader: NEWS_API_KEY},
    );
    final newsJsonList = jsonDecode(response.body)['articles'];
    final List<NewsArticle> articles = List.from(newsJsonList)
        .map((e) => NewsArticle.fromJson(e))
        .toList();
    return articles;
  }

  static Future<Resource<List<NewsArticle>>> fetchNews(
      {bool refresh = false, bool paginate = false, String? category}) async {
    if (!refresh &&
        !paginate &&
        NewsData.getInstance().newsList.isNotEmpty == true) {
      return Resource.success(NewsData.getInstance().newsList);
    }
    if (!await hasNetworkConnection()) {
      return Resource.failure("No internet connection");
    }
    try {
      int? page = 1;
      if (paginate) page = NewsData.getInstance().getPage(pageSize: PAGE_SIZE);
      if (page == null || page < 1) return Resource.empty();
      var queryParams = {
        'country': 'in',
        'page': '$page',
        'pageSize': '$PAGE_SIZE'
      };
      if (category?.isNotEmpty == true) {
        queryParams['category'] = category!;
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

  static void updateCategory(String? selectedCategory) {
    NewsData.getInstance().category = selectedCategory;
  }
}

class NewsData {
  String? category;

  NewsData._privateConstructor();

  static NewsData _instance = NewsData._privateConstructor();

  static NewsData getInstance() => _instance;

  List<NewsArticle> newsList = <NewsArticle>[];
  List<NewsArticle> favorites = <NewsArticle>[];

  void updateFavorites(NewsArticle newsItem) {
    if (favorites == null) favorites = <NewsArticle>[];
    if (isFavorite(newsItem)) {
      favorites.remove(newsItem);
    } else {
      favorites.insert(0, newsItem);
    }
  }

  bool isFavorite(NewsArticle newsItem) {
    return favorites.contains(newsItem) == true;
  }

  void addNewsArticles(List<NewsArticle> articles) {
    if (newsList.isEmpty != false) {
      newsList = [];
    }
    newsList.addAll(articles);
  }

  int? getPage({int pageSize = 10}) {
    if (newsList.isEmpty != false) return 1;
    if (newsList.length % pageSize == 0)
      return (newsList.length ~/ pageSize) + 1;
    else
      return null;
  }
}
