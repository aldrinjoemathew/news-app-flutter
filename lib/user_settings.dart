import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/users.dart';
import 'package:news_app/utils/app_theme_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  User _user;
  SharedPreferences prefs;

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = Image.asset(
      "assets/ic_profile_dummy.png",
      width: 150,
      height: 150,
      fit: BoxFit.fill,
    );
    final imageParent = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: profileImage,
    );
    final textContainer = Container(
        child: Column(children: [
      Text(_user?.name ?? "",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      Text(_user?.email ?? "", style: TextStyle(fontSize: 20))
    ]));
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            imageParent,
            SizedBox(
              height: 16,
            ),
            textContainer,
            SizedBox(
              height: 16,
            ),
            getAppFlatBtn("Log out", _logout)
          ],
        )
      ],
    );
  }

  void _logout() {
    prefs.remove("email");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return LoginPage();
    }));
  }

  void _getUserDetails() async {
    prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    setState(() {
      _user = getUsers()
          .firstWhere((element) => element.email == email, orElse: () => null);
    });
  }
}
