import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_utils.dart';

Color getAppThemeColor() {
  return AppColors.darkOlive;
}

void showOkAlert(BuildContext context, String title, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getCommonText(title),
          content: getCommonText(msg),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: getCommonText("Ok"))
          ],
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

void setLoggedIn(String email) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.setString("email", email);
  });
}

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("email")?.isNotEmpty == true;
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
    final date = DateFormat("yyyy-mm-dd hh:mm:ssZ").parse(utcString);
    return DateFormat("dd MMM, yyyy hh:mm a").format(date);
  } on FormatException catch (e) {
    print("Date format exception: ${e.message}");
  }
  return null;
}
*/

String getFormattedDate(DateTime utcDateTime) {
  // sample date: 2021-01-18T08:03:16Z
  try {
    return DateFormat("dd MMM, yyyy hh:mm a").format(utcDateTime);
  } on FormatException catch (e) {
    print("Date format exception: ${e.message}");
  }
  return null;
}
