import 'package:flutter/material.dart';

class AppTheme {
  static AppTheme _instance;

  static AppTheme get instance {
    if (_instance == null) {
      _instance = AppTheme();
    }
    return _instance;
  }

  static const Color yellowPic = Color(0xfffcd86a);
  static const Color redPic = Color(0xfffc0666);
  static const Color bluePic = Color(0xff2b3481);

  /// Light theme of the application
  static ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: bluePic,
      scaffoldBackgroundColor: yellowPic,
      accentColor: redPic,
      primaryTextTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.black, fontSize: 30, fontFamily: 'Montserrat'),
          headline2: TextStyle(
              color: Colors.black, fontSize: 28, fontFamily: 'Montserrat'),
          headline3: TextStyle(
              color: Colors.black, fontSize: 24, fontFamily: 'Montserrat'),
          headline4: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: 'Montserrat'),
          headline5: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'Montserrat'),
          headline6: TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: 'Montserrat'),
          bodyText1: TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 1.75,
              fontFamily: 'Montserrat')));

  /// Dark theme of the application
  static ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.black,
      accentColor: redPic,
      primaryTextTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.white, fontSize: 30, fontFamily: 'Montserrat'),
          headline2: TextStyle(
              color: Colors.white, fontSize: 28, fontFamily: 'Montserrat'),
          headline3: TextStyle(
              color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
          headline4: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
          headline5: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),
          headline6: TextStyle(
              color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
          bodyText1: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.75,
              fontFamily: 'Montserrat')));

  Size _size;

  Size get size => _size;

  void init(MediaQueryData data) {
    _size = data.size;
  }

  double get largeVerticalSpacing => _size.height * 0.1;

  double get mediumVerticalSpacing => _size.height * 0.05;

  double get smallVerticalSpacing => _size.height * 0.03;

  double get largeHorizontalSpacing => _size.width * 0.1;

  double get mediumHorizontalSpacing => _size.width * 0.05;

  double get smallHorizontalSpacing => _size.width * 0.03;
}
