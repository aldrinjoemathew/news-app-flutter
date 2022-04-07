import 'package:news_app/src/models/news_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  var database;

  DatabaseHelper() {
    database = initializeDB();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'news_db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE favorites(id TEXT PRIMARY KEY, name TEXT, author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT)');
      },
    );
  }

  Future<int> addFavorite(NewsArticle favorite) async {
    final Database db = await initializeDB();
    return await db.insert('favorites', favorite.toDbJson());
  }

  void removeFavorite(String url) async {
    final Database db = await initializeDB();
    await db.rawDelete('DELETE FROM favorites WHERE url = ?', ['$url']);
  }

  Future<List<NewsArticle>> retrieveFavorites() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('favorites', orderBy: 'publishedAt DESC');
    return queryResult.map((e) => NewsArticle.fromDbJson(e)).toList();
  }
}
