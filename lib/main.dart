import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'utils/app_theme_utils.dart';
import 'utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialPage = await _getInitialPage();
  runApp(MaterialApp(
    title: "NewsApp",
    home: initialPage,
    theme: buildAppTheme(),
  ));
}

Future<Widget> _getInitialPage() async {
  if (await isLoggedIn())
    return HomePage();
  else
    return LoginPage();
}