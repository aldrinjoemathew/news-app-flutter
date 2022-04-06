import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme_utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.sienna,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/ic_news.png",
              width: 150,
              height: 150,
            ),
            Text(
              "News Reader",
              style: TextStyle(
                fontSize: 36,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkIfUserIsLoggedIn() async {
    Timer(Duration(seconds: 2), () async {
      final loggedIn = await context.read<UserModel>().getCurrentUser() != null;
      Navigator.of(context)
          .pushReplacementNamed(loggedIn ? AppRoutes.Home : AppRoutes.Login);
    });
  }
}
