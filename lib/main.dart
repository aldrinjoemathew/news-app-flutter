import 'package:flutter/material.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/ui/edit_profile.dart';
import 'package:news_app/src/ui/news_detail.dart';
import 'package:news_app/src/ui/splash.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/validation/edit_profile_validation.dart';
import 'package:news_app/src/validation/login_validation.dart';
import 'package:provider/provider.dart';

import 'src/ui/home.dart';
import 'src/ui/login.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => LoginValidation()),
        ChangeNotifierProvider(create: (context) => EditProfileValidation()),
      ],
      child: MaterialApp(
        title: "NewsApp",
        theme: buildAppTheme(),
        initialRoute: AppRoutes.Splash,
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.Splash: (context) => SplashPage(),
          AppRoutes.Login: (context) => LoginPage(),
          AppRoutes.Home: (context) => HomePage(),
          AppRoutes.EditProfile: (context) => EditProfilePage(),
          AppRoutes.NewsDetail: (context) => NewsDetailPage(
              ModalRoute.of(context)!.settings.arguments as NewsArticle),
          AppRoutes.NewsWebView: (context) =>
              NewsWebPage(ModalRoute.of(context)!.settings.arguments as String),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            default:
              return null;
          }
        },
      ),
    );
  }
}
