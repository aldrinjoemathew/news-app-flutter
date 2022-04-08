import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/db/favorites_provider.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/ui/edit_profile.dart';
import 'package:news_app/src/ui/news_detail.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/validation/edit_profile_validation.dart';
import 'package:provider/provider.dart';

import 'src/ui/home.dart';
import 'src/ui/login.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _isLoggedIn;

    return FutureBuilder<bool>(
      //TODO Causing a slight freeze while future task is being execute, need to investigate further
      future: _checkIfUserIsLoggedIn(context),
      initialData: null,
      builder: (context, snapshot) {
        _isLoggedIn = snapshot.data;
        if (_isLoggedIn == null)
          return Container(
            color: AppColors.sienna,
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: AppColors.white,
            ),
          );
        else
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => UserModel()),
              ChangeNotifierProvider(create: (context) => FavoritesProvider()),
            ],
            child: MaterialApp(
              title: "NewsApp",
              theme: buildAppTheme(),
              initialRoute:
                  _isLoggedIn == true ? AppRoutes.Home : AppRoutes.Login,
              debugShowCheckedModeBanner: false,
              routes: {
                AppRoutes.Login: (context) => LoginPage(),
                AppRoutes.Home: (context) => HomePage(),
              },
              onGenerateRoute: (routeSettings) {
                switch (routeSettings.name) {
                  case AppRoutes.NewsDetail:
                    return CupertinoPageRoute(builder: (context) {
                      return NewsDetailPage(
                          routeSettings.arguments as NewsArticle);
                    });
                  case AppRoutes.NewsWebView:
                    return CupertinoPageRoute(builder: (context) {
                      return NewsWebPage(routeSettings.arguments as String);
                    });
                  case AppRoutes.EditProfile:
                    return CupertinoPageRoute(builder: (context) {
                      return ChangeNotifierProvider(
                        create: (_) => EditProfileValidation(),
                        child: EditProfilePage(),
                      );
                    });
                  default:
                    return null;
                }
              },
            ),
          );
      },
    );
  }

  Future<bool> _checkIfUserIsLoggedIn(BuildContext context) async {
    await Future.delayed(Duration(
      seconds: 2,
    ));
    return await isLoggedIn();
  }
}
