import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    fontFamily: "Inter",
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4F46E5), // Indigo / NavigatorBar ve Ana Buton rengi
      secondary: Color(
        0xFF06B6D4,
      ), // Canlı Camgöbeği / Takvim gösterimi ve vurgular
      surface: Color(0xFFE5E7EB), // Slate / Sayfa arka plan rengi
      onSurface: Color(
        0xFF475569,
      ), // Slate Gri / Tarih, saat ve normal yazıların rengi
      tertiary: Color(
        0xFF0D172A,
      ), // Koyu Slate / Başlıkların ve ana etkinlik adlarının rengi
      onSecondary: Color(
        0xFFFFFFFF,
      ), // Saf Beyaz / Kartların ve TextField'ın iç kutu rengi

      onPrimaryContainer: Color(0xFF10B981), // Yeşil / Tik işareti (Onay) rengi
      error: Color(0xFFEF4444), // Kırmızı / Çöp kutusu (Silme) rengi
      /*
      primary: Color(0xFF4F46E5), //navigatorBar rengi
      secondary: Color(
        0xFF06B6D4,
      ), //onayla-ekle butonu / takvimdeki gosterimdeki renk
      surface: Color(0xFFF8FAFC), //background rengi
      onSurface: Color(0xFF475569), // normal yazilarin rengi
      tertiary: Color(0xFF0D172A), // baslik rengi
      onSecondary: Color(0xFFD5E9ED), //kutu rengi
*/
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Color(0xFF4F46E5)),
    ),
  );
}
