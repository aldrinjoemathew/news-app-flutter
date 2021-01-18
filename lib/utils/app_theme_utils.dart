import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    toggleableActiveColor: AppColors.lightSteelBlue,
    accentColor: AppColors.lightSteelBlue,
    primaryColor: AppColors.darkOlive,
    buttonColor: AppColors.darkOlive,
    scaffoldBackgroundColor: AppColors.surfaceWhite,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkOlive,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.darkKhaki),
    cardColor: AppColors.surfaceWhite,
    textSelectionColor: AppColors.lightSteelBlue,
    errorColor: AppColors.errorRed,
    primaryIconTheme: _customIconTheme(base.iconTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: AppColors.darkOlive);
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: AppColors.darkOlive,
  primaryVariant: AppColors.sienna,
  secondary: AppColors.lightSteelBlue,
  secondaryVariant: AppColors.beige,
  surface: AppColors.surfaceWhite,
  background: AppColors.surfaceWhite,
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
  static const cardColor = Colors.white;
  static const listBg = lightSteelBlue;
  static const surfaceWhite = Colors.white;
  static const errorRed = Colors.redAccent;
}
