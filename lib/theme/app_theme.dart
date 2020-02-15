import 'package:flutter/material.dart';

var _title = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.15,
    color: Colors.black87);

final ThemeData primaryTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    primaryColor: Colors.orange,
    buttonColor: Colors.orange,

    /// App bar theme
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
//        color: Colors.white,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        title: _title.merge(
          TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
    textTheme: TextTheme(title: _title),
    iconTheme: IconThemeData(
      color: Colors.grey[800],
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(12),
      border: OutlineInputBorder(),
      hintStyle: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
    ),
    buttonTheme: ButtonThemeData(height: 40),

    /// Support swipe from edge to navigate the previous scene
    /// for both iOS and android
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ));
