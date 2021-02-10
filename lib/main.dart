import 'package:flutter/material.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/validation/edit_profile_validation.dart';
import 'package:news_app/src/validation/login_validation.dart';
import 'package:provider/provider.dart';

import 'src/ui/home.dart';
import 'src/ui/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialPage = await _getInitialPage();
  final materialApp = MaterialApp(
    title: "NewsApp",
    home: initialPage,
    theme: buildAppTheme(),
  );
  final changeProviders = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => UserModel()),
      ChangeNotifierProvider(create: (c) => LoginValidation()),
      ChangeNotifierProvider(create: (c) => EditProfileValidation())
    ],
    child: materialApp,
  );
  runApp(changeProviders);
}

Future<Widget> _getInitialPage() async {
  if (await isLoggedIn())
    return HomePage();
  else
    return LoginPage();
}