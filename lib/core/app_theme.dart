import 'package:flutter/material.dart';

// Define primary and secondary colors
final primaryColor = const Color(0xff2E8BC0);
final secondaryColor = const Color(0xffd3e312);

final appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    onPrimary: Colors.white, // Text/icon color on primary backgrounds
    onSecondary: Colors.black, // Text/icon color on secondary backgrounds
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white, // Fixed for better contrast
    centerTitle: true,
    elevation: 2,
    titleTextStyle: const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Color(0xff000305),
    ),
    bodyLarge: TextStyle(
      fontSize: 20.0,
      color: Colors.grey[900], // Slightly darker for better readability
    ),
    bodyMedium: const TextStyle(
      fontSize: 16.0,
      color: Color(0xff757575), // Consistent grey tone
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: primaryColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white, // Improved contrast
    elevation: 4,
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: primaryColor),
    iconColor: primaryColor,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  iconTheme: IconThemeData(
    color: primaryColor,
    size: 24.0,
  ),
);
