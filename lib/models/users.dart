import 'dart:convert';

import 'package:flutter/cupertino.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.name,
    this.email,
    this.password,
    this.address,
    this.phone,
    this.profileImagePath,
  });

  User.create(this.name, this.email, this.password);

  String name;
  String email;
  String password;
  String address;
  String phone;
  String profileImagePath;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        address: json["address"],
        phone: json["phone"],
        profileImagePath: json["profileImagePath"],
      );

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "email": email,
        "password": password,
        "address": address,
        "phone": phone,
        "profileImagePath": profileImagePath,
      };
}

List<User> getUsers() {
  final userList = <User>[];
  userList.add(User.create("Alice", "alice@mail.com", "alice123"));
  userList.add(User.create("Bob", "bob@mail.com", "bob123"));
  return userList;
}

class UserModel extends ChangeNotifier {
  User user;

  void updateUserDetails(User user) {
    this.user = user;
    notifyListeners();
    print("notified: ${this.user?.name}");
  }
}
