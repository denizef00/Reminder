import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4F46E5), //navigatorBar rengi
      secondary: Color(
        0xFF06B6D4,
      ), //onayla-ekle butonu / takvimdeki gosterimdeki renk
      surface: Color(0xFFF8FAFC), //background rengi
      onSurface: Color(0xFF475569), // normal yazilarin rengi
      tertiary: Color(0xFF0D172A), // baslik rengi
      onSecondary: Color(0xFFD5E9ED), //kutu rengi
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Color(0xFF4F46E5)),
    ),
  );
}
