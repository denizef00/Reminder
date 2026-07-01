import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeData get theme => themeMode == ThemeMode.light ? lightTheme : darkTheme;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

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
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Color(0xFF4F46E5)),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    fontFamily: "Inter",
    colorScheme: ColorScheme.dark(
      primary: Color(
        0xFF6366F1,
      ), // Hafif açık indigo (karanlıkta daha iyi görünür)
      secondary: Color(0xFF22D3EE), // Parlak camgöbeği
      surface: Color(0xFF0F172A), // Çok koyu slate (Arka plan rengi)
      onSurface: Color(0xFF94A3B8), // Açık gri (Tarih, saat ve normal yazılar)
      tertiary: Color(0xFFF8FAFC), // Beyaza yakın (Başlıklar ve ana metinler)
      onSecondary: Color(
        0xFF1E293B,
      ), // Koyu gri/mavi (Kartların ve TextField'ın iç kutu rengi)

      onPrimaryContainer: Color(0xFF34D399), // Yeşil / Tik işareti
      error: Color(0xFFF87171), // Kırmızı / Çöp kutusu
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: const Color(0xFF6366F1)),
    ),
  );
}
