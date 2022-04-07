import 'package:flutter/cupertino.dart';
import 'package:news_app/src/models/news_models.dart';

import 'database_helper.dart';

class FavoritesProvider with ChangeNotifier {
  final handler = DatabaseHelper();
  List<NewsArticle> _favorites = [];

  List<NewsArticle>? get favorites => _favorites;

  void getFavorites() async {
    _favorites = await handler.retrieveFavorites();
  }

  void toggleFavorite(NewsArticle article) {
    isFavorite(article) ? removeFavorite(article) : addFavorite(article);
  }

  void addFavorite(NewsArticle article) {
    handler.addFavorite(article);
    _favorites.add(article);
    _favorites.sort((b,a) => (a.publishedAt?.millisecondsSinceEpoch ?? 0).compareTo(b.publishedAt?.millisecondsSinceEpoch ?? 0));
    notifyListeners();
  }

  void removeFavorite(NewsArticle article) {
    if (article.url != null) {
      handler.removeFavorite(article.url!);
      _favorites.remove(article);
    }
    notifyListeners();
  }

  bool isFavorite(NewsArticle article) {
    return _favorites.any((element) => element.url == article.url) == true;
  }
}
