import 'dart:convert';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final _keyHistory = '_historyKey';
  TextEditingController controller;
  List<String> _history = [];

  List<String> get history => _history;

  SearchProvider() {
    controller = new TextEditingController();
    loadHistory();
  }

  String get text => controller.text;

  loadHistory() async {
    String response = await StorageManager.getObjectByKey(_keyHistory);
    if (response != null) {
      var json = jsonDecode(response);
      _history = json.cast<String>();
    }
  }

  void setText({String text = ''}) {
    controller = new TextEditingController(text: text);
    if (text.isNotEmpty) {
      if (_history.contains(text) == false) {
        _history.insert(0, text);
      }else{
        _history.remove(text);
        _history.insert(0, text);
      }
      StorageManager.setObject(_keyHistory, jsonEncode(history));
    }
    notifyListeners();
  }

  void removeHistoryUnit(String title) {
    history.removeWhere((m) => m == title);
    StorageManager.setObject(_keyHistory, jsonEncode(history));
    notifyListeners();
  }
  removeHistoryAll(){
    _history=[];
    notifyListeners();
  }
}
