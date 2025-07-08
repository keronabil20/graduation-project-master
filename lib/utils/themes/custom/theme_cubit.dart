// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  static const String _themeKey = 'isDarkMode';

  ThemeCubit() : super(false) {
    loadTheme();
  }

  Future<void> toggleTheme() async {
    final newState = !state;
    emit(newState);
    await _saveTheme(newState);
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      emit(prefs.getBool(_themeKey) ?? false);
    } catch (e) {
      debugPrint('Error loading theme: $e');
      emit(false);
    }
  }

  Future<void> _saveTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}
