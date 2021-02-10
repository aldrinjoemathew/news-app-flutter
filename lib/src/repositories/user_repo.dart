import 'package:news_app/src/models/users.dart';

class UserRepo {
  List<User> getUsers() {
    final userList = <User>[];
    userList.add(User.create("Alice", "alice@mail.com", "alice123"));
    userList.add(User.create("Bob", "bob@mail.com", "bob123"));
    return userList;
  }
}
