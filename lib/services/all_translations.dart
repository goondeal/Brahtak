import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GlobalTranslations with ChangeNotifier {
  static const List<String> supportedLanguages = ['en', 'ar'];
  Locale _locale;
  Map<String, dynamic> _localizedValues;
  String savedLang;
  
  /// Returns the translation that corresponds to the [key].
  String translate(String key) {
    return _localizedValues[key] ?? '** $key';
  }

  /// Returns the current Locale.
  Locale get locale => _locale;
  String get currentLang => _locale.languageCode;

  /// One-time initialization.
  Future<void> init([String language]) async {
    savedLang = await _getAppLang();
    if (_locale == null) {
      await setNewLanguage(language);
    }
  }

  /// Routine to change the language.
  Future<void> setNewLanguage([String lang, bool saveInPrefs = true]) async {
    
    String language = lang ?? await _getAppLang()?? 'ar';

    if(_locale?.languageCode == language){ return; }

    // Set the locale.
    _locale = Locale(language);

    // Load the language strings.
    String jsonContent = await rootBundle
        .loadString("assets/langs/${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    // If we are asked to save the new language in the application preferences.
    if (saveInPrefs) {
      await _setApplang(language);
    }

    notifyListeners();
  }


  Future<String> _getAppLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_lang');
  }

  Future<bool> _setApplang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('app_lang', lang);
  }

  ///
  /// Singleton Factory
  ///
  static final GlobalTranslations _translations =
      GlobalTranslations._internal();

  factory GlobalTranslations() {
    return _translations;
  }
  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = GlobalTranslations();
