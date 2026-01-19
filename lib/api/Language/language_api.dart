import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  
  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isBengali => _currentLocale.languageCode == 'bn';
  
  // Singleton instance
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();
  
  void toggleLanguage() {
    _currentLocale = _currentLocale.languageCode == 'en' 
        ? const Locale('bn', 'BD') 
        : const Locale('en', 'US');
    notifyListeners();
  }
  
  void setEnglish() {
    _currentLocale = const Locale('en', 'US');
    notifyListeners();
  }
  
  void setBengali() {
    _currentLocale = const Locale('bn', 'BD');
    notifyListeners();
  }
}