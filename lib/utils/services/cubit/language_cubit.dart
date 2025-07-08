// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    emit(Locale(languageCode));
  }

  void toggleLocale() {
    final newLanguageCode = state.languageCode == 'en' ? 'ar' : 'en';
    _saveLocale(newLanguageCode);
    emit(Locale(newLanguageCode));
  }

  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
