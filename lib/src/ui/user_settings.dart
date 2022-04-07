import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  late UserModel _userModel;

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    if (_userModel.user == null) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(6),
        child: CircularProgressIndicator(),
      );
    } else {
      final profileImage = _userModel.user!.profileImagePath?.isNotEmpty == true
          ? Image.file(
              File(_userModel.user!.profileImagePath!),
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            )
          : Image.asset(
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
        Text(_userModel.user?.name ?? "",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Text(_userModel.user?.email ?? "", style: TextStyle(fontSize: 20))
      ]));
      final listView = ListView(
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

      return Container(
        color: AppColors.beige,
        child: listView,
      );
    }
  }

  void _logout() {
    showOkAlert(context, "Log out", "Are you sure you want to log out?",
        okText: "Log out", showCancel: true, okAction: () {
      _userModel.logout();
      Navigator.of(context).pushReplacementNamed(AppRoutes.Login);
    });
  }

  void _getUserDetails() async {
    context.read<UserModel>().getCurrentUser();
  }
}
