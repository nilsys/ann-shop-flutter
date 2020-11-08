import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UserDefaults {
  factory UserDefaults() => instance;

  UserDefaults._internal();

  static final UserDefaults instance = UserDefaults._internal();
  SharedPreferences _pref;

  Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static const String storageDomain = "my_app_storage_key";

  Future setObject(String keyName, Object keyValue) async {
    switch (keyValue.runtimeType) {
      case String:
        await _pref.setString(storageDomain + keyName, keyValue);
        break;
      case int:
        await _pref.setInt(storageDomain + keyName, keyValue);
        break;
      case bool:
        await _pref.setBool(storageDomain + keyName, keyValue);
        break;
      case double:
        await _pref.setDouble(storageDomain + keyName, keyValue);
        break;
      case List:
        await _pref.setStringList(storageDomain + keyName, keyValue);
        break;
    }
  }

  dynamic getObjectByKey(String keyName) {
    return _pref.get(storageDomain + keyName);
  }

  bool containsKey(String keyName) {
    return _pref.containsKey(storageDomain + keyName);
  }

  void clearAll() {
    _pref.clear();
  }

  void clearObjectByKey(String keyName) {
    _pref.remove(storageDomain + keyName);
  }
}
