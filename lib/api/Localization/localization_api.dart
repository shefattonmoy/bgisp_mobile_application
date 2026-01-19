import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  
  Locale _locale = const Locale('en', 'US'); // Default to English
  
  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == 'en';
  String get toggleButtonText => isEnglish ? 'EN' : 'বাংলা';
  
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    
    // FORCE ENGLISH ON FIRST LAUNCH
    if (savedLanguage == null) {
      _locale = const Locale('en', 'US');
      await prefs.setString(_languageKey, 'en');
    } else if (savedLanguage == 'bn') {
      _locale = const Locale('bn', 'BD');
    } else {
      _locale = const Locale('en', 'US');
    }
    
    notifyListeners();
  }
  
  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('bn', 'BD');
    } else {
      _locale = const Locale('en', 'US');
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _locale.languageCode);
    
    notifyListeners();
  }
  
  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    notifyListeners();
  }
  
  // Reset to English forcefully
  Future<void> resetToEnglish() async {
    _locale = const Locale('en', 'US');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, 'en');
    
    notifyListeners();
  }
}