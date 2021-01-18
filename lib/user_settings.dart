import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/users.dart';
import 'package:news_app/utils/app_utils.dart';
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
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 75,
              color: Colors.white,
            ),
            backgroundColor: getAppThemeColor(),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            _user?.name ?? "",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            _user?.email ?? "",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: _logout,
              child: Text("Log out"))
        ],
      ),
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
