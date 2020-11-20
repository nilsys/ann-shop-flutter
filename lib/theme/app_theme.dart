import 'package:flutter/material.dart';

final ThemeData primaryTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.orange,
  buttonColor: Colors.orange,

  /// App bar theme
  textTheme: TextTheme(
    headline6: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 0.15),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey[800],
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(12),
    border: const OutlineInputBorder(),
    hintStyle:
        TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
  ),
  buttonTheme: const ButtonThemeData(height: 40),

  /// Support swipe from edge to navigate the previous scene
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
