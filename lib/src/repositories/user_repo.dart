import 'package:news_app/src/models/users.dart';

import '../db/database_helper.dart';

class UserRepo {
  final handler = DatabaseHelper();

  UserRepo() {
    _createUsers();
  }

  List<User> getUsers() {
    final userList = <User>[];
    userList.add(User.create("Alice", "alice@mail.com", "alice123"));
    userList.add(User.create("Bob", "bob@mail.com", "bob123"));
    userList.add(User.create("Aldrin", "aldrinjoe@gmail.com", "1234"));
    return userList;
  }

  Future _createUsers() async {
    if (!(await handler.isUsersAvailable()))
      getUsers().forEach((user) async {
        await handler.createUser(user);
      });
  }

  Future<User?> loginUser(String? email, String? password) async {
    if (email == null || email
        .trim()
        .isEmpty || password == null || password
        .trim()
        .isEmpty) return null;
    return await handler.login(email, password);
  }
}
