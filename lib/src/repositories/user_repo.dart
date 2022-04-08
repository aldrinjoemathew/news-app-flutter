import 'package:news_app/src/models/users.dart';

import '../db/database_helper.dart';

class UserRepo {
  final handler = DatabaseHelper();

  UserRepo() {
    _createUsers();
  }

  List<User> defaultLogins() {
    final userList = <User>[];
    userList.add(User.create("Alice", "alice@mail.com", "alice123"));
    userList.add(User.create("Bob", "bob@mail.com", "bob123"));
    return userList;
  }

  Future _createUsers() async {
    if (!(await handler.isUsersAvailable()))
      defaultLogins().forEach((user) async {
        await handler.createUser(user);
      });
  }

  Future<User?> loginUser(String? email, String? password) async {
    if (email == null ||
        email.trim().isEmpty ||
        password == null ||
        password.trim().isEmpty) return null;
    return await handler.login(email, password);
  }

  Future<User?> addUser(String name, String email, String password) async {
    var success = await handler.createUser(User(
          name: name,
          email: email,
          password: password,
        )) !=
        0;
    if (success) {
      return await handler.login(email, password);
    } else
      return null;
  }
}
