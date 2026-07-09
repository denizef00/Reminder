import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  static const String _storageKey = "theme_mode";

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_storageKey);

    if (savedTheme == "dark") {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final currentMode = state.value ?? ThemeMode.light;
    final newMode = currentMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    state = AsyncValue.data(newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      newMode == ThemeMode.dark ? "dark" : "light",
    );
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
