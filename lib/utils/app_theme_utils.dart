import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.white),
          actionsIconTheme: IconThemeData(color: AppColors.white)),
      colorScheme: _shrineColorScheme,
      toggleableActiveColor: AppColors.lightSteelBlue,
      accentColor: AppColors.darkKhaki,
      primaryColor: AppColors.darkOlive,
      buttonColor: AppColors.darkOlive,
      scaffoldBackgroundColor: AppColors.white,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkOlive,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.darkKhaki,
      ),
      cardColor: AppColors.cardColor,
      textSelectionColor: AppColors.lightSteelBlue,
      errorColor: AppColors.errorRed,
      primaryIconTheme: _customIconTheme(base.iconTheme),
      iconTheme: _customIconTheme(base.iconTheme),
      textTheme: _getTextTheme(base.textTheme));
}

TextTheme _getTextTheme(TextTheme base) {
  return base.apply(fontFamily: "Merriweather");
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: AppColors.darkOlive);
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: AppColors.darkOlive,
  primaryVariant: AppColors.sienna,
  secondary: AppColors.darkKhaki,
  secondaryVariant: AppColors.beige,
  surface: AppColors.white,
  background: AppColors.white,
  error: AppColors.errorRed,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: AppColors.darkOlive,
  onBackground: AppColors.darkOlive,
  onError: Colors.white,
  brightness: Brightness.light,
);

class AppColors {
  static const sienna = Color.fromRGBO(116, 70, 34, 1);
  static const darkOlive = Color.fromRGBO(57, 35, 19, 1);
  static const lightSteelBlue = Color.fromRGBO(170, 240, 209, 1);
  static const beige = Color.fromRGBO(240, 231, 227, 1);
  static const darkKhaki = Color.fromRGBO(168, 117, 80, 1);
  static const cardColor = beige;
  static const listBg = lightSteelBlue;
  static const white = Colors.white;
  static const surfaceBg = beige;
  static const errorRed = Colors.redAccent;
  static const favoriteRed = Colors.red;
}

MaterialButton getAppFlatBtn(String btnText, VoidCallback onPressed,
    {Color btnColor = AppColors.sienna,
    double borderRadius = 16,
    double padding = 16,
    double textSize = 16}) {
  return FlatButton(
      padding: EdgeInsets.all(padding),
      color: btnColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      onPressed: onPressed,
      child: Text(
        btnText,
        style: TextStyle(color: AppColors.white, fontSize: textSize),
      ));
}