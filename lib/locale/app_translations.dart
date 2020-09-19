import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:ping9/ping9.dart';

import 'application.dart';

class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues = new Map();

  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);

    Map<dynamic, dynamic> _tmpLocale;
    String _localeCode = locale.languageCode;
    Application.instance.language = _localeCode;
    // Load multiple language file
    for (int i = 0; i < Application.instance.locale[_localeCode].length; i++) {
      String jsonContent = await rootBundle.loadString(
          "assets/locale/$_localeCode/${Application.instance.locale[_localeCode][i]}.json");
      _tmpLocale = json.decode(jsonContent);
      _localisedValues.addAll(_tmpLocale);
    }
    // Load Remote
    String pathRemote =
        "http://dev-mobileapp.bigc.vn:8080/files/mobile-app/locale/remote_${locale.languageCode}.json";
    try {
      final response = await http.get(pathRemote).timeout(Duration(seconds: 5));
      if (response.statusCode == HttpStatus.ok) {
        if (isNullOrEmpty(response.body) == false) {
          _tmpLocale = json.decode(utf8.decode(response.bodyBytes));
          _localisedValues.addAll(_tmpLocale);
        }
      }
    } catch (e) {
      print(e);
    }

    // return
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  /// Detects if _localisedValues has the given key
  /// for translation
  bool isKeyExist(String key) => _localisedValues.containsKey(key);

  String text(String key) {
    return _localisedValues[key] ?? "$key";
  }

  String textFormat(String key, List<dynamic> replace) {
    String _value = _localisedValues[key] ?? "$key";
    for (int i = 0; i < replace.length; i++) {
      _value = _value.replaceAll('{$i}', replace[i].toString());
    }
    return _value;
  }
}
