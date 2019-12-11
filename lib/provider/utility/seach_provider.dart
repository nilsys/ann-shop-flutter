import 'dart:convert';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final _keyHistory = '_historyKey';
  TextEditingController controller;
  List<String> _history = [];

  List<String> get history => _history;

  set history(List<String> history) {
    _history = history;
    notifyListeners();
  }

  SearchProvider() {
    controller = new TextEditingController();
    loadHistory();
  }

  String get text => controller.text;

  loadHistory() async {
    String response = await StorageManager.getObjectByKey(_keyHistory);
    var json = jsonDecode(response);
    if (json != null) {
      history = json.cast<String>();
    }
  }

  void setText({String text = ''}) {
    controller = new TextEditingController(text: text);
    if (text.isNotEmpty) {
      if (history.contains(text) == false) {
        history.add(text);
        StorageManager.setObject(_keyHistory, jsonEncode(history));
      }
    }
    notifyListeners();
  }

  void removeHistoryUnit(String title) {
    history.removeWhere((m) => m == title);
    StorageManager.setObject(_keyHistory, jsonEncode(history));
    notifyListeners();
  }
}
