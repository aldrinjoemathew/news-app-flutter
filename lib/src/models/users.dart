import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User(
      {required this.name,
      required this.email,
      required this.password,
      this.address,
      this.phone,
      this.profileImagePath,
      this.dob});

  User.create(this.name, this.email, this.password);

  String name;
  String email;
  String password;
  String? address;
  String? phone;
  String? profileImagePath;
  String? dob;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        address: json["address"],
        phone: json["phone"],
        profileImagePath: json["profileImagePath"],
        dob: json["dob"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "address": address,
        "phone": phone,
        "profileImagePath": profileImagePath,
        "dob": dob
      };
}