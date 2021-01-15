import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

MaterialColor getAppThemeColor() {
  return Colors.brown;
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

void showBottomSheet(String text, ScaffoldState scaffoldState) {
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