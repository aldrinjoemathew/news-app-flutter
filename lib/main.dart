import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'login.dart';
import 'models/users.dart';
import 'utils/app_theme_utils.dart';
import 'utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialPage = await _getInitialPage();
  final materialApp = MaterialApp(
    title: "NewsApp",
    home: initialPage,
    theme: buildAppTheme(),
  );
  final provider = ChangeNotifierProvider(
    create: (c) {
      return UserModel();
    },
    child: materialApp,
  );
  runApp(provider);
}

Future<Widget> _getInitialPage() async {
  if (await isLoggedIn())
    return HomePage();
  else
    return LoginPage();
}