class User {
  User(this.name, this.email, this.password);

  String name;
  String email;
  String password;
  String address;
  String phone;
}

List<User> getUsers() {
  final userList = <User>[];
  userList.add(User("Alice", "alice@mail.com", "alice123"));
  userList.add(User("Bob", "bob@mail.com", "bob123"));
  return userList;
}
