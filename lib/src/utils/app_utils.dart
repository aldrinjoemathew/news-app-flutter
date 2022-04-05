import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/src/models/users.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_utils.dart';

Color getAppThemeColor() {
  return AppColors.darkOlive;
}

void showOkAlert(BuildContext context, String title, String msg,
    {VoidCallback? okAction, bool showCancel = false, String okText = "Ok"}) {
  final actions = [
    FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          okAction?.call();
        },
        child: getCommonText(okText))
  ];
  if (showCancel) {
    actions.insert(
        0,
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: getCommonText("Cancel")));
  }
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getCommonText(title),
          content: getCommonText(msg),
          actions: actions,
        );
      });
}

final commonTextStyle = TextStyle(
  fontSize: 16,
);

Text getCommonText(String text) {
  return Text(
    text,
    style: commonTextStyle,
  );
}

void showAppBottomSheet(String text, ScaffoldState scaffoldState) {
  scaffoldState.showSnackBar(SnackBar(
    padding: EdgeInsets.all(8),
    backgroundColor: Colors.black,
    content: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ));
}

void saveLoggedInUser(User user) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.setString("user", userToJson(user));
  });
}

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("user")?.isNotEmpty == true;
}

Future<bool> hasNetworkConnection() async {
  final result = await Connectivity().checkConnectivity();
  // print("hasConnection => $result");
  if (result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

/*
String getFormattedDate(String utcString) {
  // sample date: 2021-01-18T08:03:16Z
  try {
    final date = DateFormat(DateFormats.Utc).parse(utcString);
    return DateFormat("DateFormats.NewsListing").format(date);
  } on FormatException catch (e) {
    print("Date format exception: ${e.message}");
  }
  return null;
}
*/

String? getFormattedDate(DateTime? utcDateTime) {
  // sample date: 2021-01-18T08:03:16Z
  try {
    return DateFormat(DateFormats.NewsListing).format(utcDateTime!);
  } on FormatException catch (e) {
    print("Date format exception: ${e.message}");
  }
  return null;
}
