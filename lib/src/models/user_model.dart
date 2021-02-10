import 'package:flutter/material.dart';
import 'package:news_app/src/models/users.dart';

class UserModel extends ChangeNotifier {
  User user;

  void updateUserDetails(User user) {
    this.user = user;
    notifyListeners();
    print("notified: ${this.user?.name}");
  }
}
