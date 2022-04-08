import 'package:news_app/src/models/news_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/users.dart';

class DatabaseHelper {
  final databaseVersion = 2;
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      var version = await _db!.getVersion();
      if (version == databaseVersion) return _db!;
    }
    _db = await initializeDB();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(path);
    return openDatabase(
      join(path, 'news_db'),
      version: databaseVersion,
      onCreate: (db, version) async {
        var batch = db.batch();
        batch.execute(
            'CREATE TABLE favorites(id TEXT PRIMARY KEY, name TEXT, author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT)');
        batch.execute(
            'CREATE TABLE users(email TEXT PRIMARY KEY, name TEXT, password TEXT, address TEXT, phone TEXT, profileImagePath TEXT, dob TEXT)');
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute(
              'CREATE TABLE users(email TEXT PRIMARY KEY, name TEXT, password TEXT, address TEXT, phone TEXT, profileImagePath TEXT, dob TEXT)');
        }
      },
    );
  }

  Future<int> addFavorite(NewsArticle favorite) async {
    final Database db = await this.db;
    return await db.insert('favorites', favorite.toDbJson());
  }

  void removeFavorite(String url) async {
    final Database db = await this.db;
    await db.rawDelete('DELETE FROM favorites WHERE url = ?', ['$url']);
  }

  Future<List<NewsArticle>> retrieveFavorites() async {
    final Database db = await this.db;
    final List<Map<String, Object?>> queryResult =
        await db.query('favorites', orderBy: 'publishedAt DESC');
    return queryResult.map((e) => NewsArticle.fromDbJson(e)).toList();
  }

  Future<int> createUser(User user) async {
    final Database db = await this.db;
    return await db.insert('users', user.toJson());
  }

  Future<bool> isUsersAvailable() async {
    var db = await this.db;
    var count =
        Sqflite.firstIntValue(await db.rawQuery('select count(*) from users'));
    return count != null && count > 0;
  }

  Future<User?> login(String email, String password) async {
    final Database db = await this.db;
    final List<Map<String, Object?>> queryResult = await db.query(
      'users',
      where: 'email=? and password=?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (queryResult.isEmpty)
      return null;
    else
      return User.fromJson(queryResult.first);
  }

  Future updateUser(User user) async {
    final Database db = await this.db;
    await db.update(
      'users',
      user.toJson(),
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }

  Future<User?> getUserDetails(String email) async {
    final Database db = await this.db;
    final List<Map<String, Object?>> queryResult = await db.query(
      'users',
      where: 'email=?',
      whereArgs: [email],
      limit: 1,
    );
    if (queryResult.isEmpty)
      return null;
    else
      return User.fromJson(queryResult.first);
  }
}
