import 'package:flutter/material.dart';
import 'package:news_app/src/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/database_helper.dart';

class UserModel extends ChangeNotifier {
  final handler = DatabaseHelper();
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<User?> getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");
    var user;
    try {
      user = userFromJson(userJson ?? '');
    } catch (e) {
      print('${e.toString()}');
      user = null;
    }
    _user = user;
    if(_user == null)
      this._isLoggedIn = false;
    notifyListeners();
    return _user;
  }

  void logout() {
    this._user = null;
    this._isLoggedIn = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("user");
    });
  }

  void updateUserDetails(User user) {
    this._user = user;
    this._isLoggedIn = true;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("user", userToJson(user));
    });
    notifyListeners();
    print("notified: ${this._user?.name}");
    handler.updateUser(user);
  }
}
