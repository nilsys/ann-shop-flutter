import 'dart:async';
import 'dart:convert';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/utility/copy_setting.dart';
import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  final _keyConfig = '_keyConfig';
  static StreamController onSortChanged = StreamController<int>.broadcast();
  static StreamController onFilterChanged = StreamController<int>.broadcast();

  int _sort;

  int get sort => _sort;

  set sort(int sort) {
    _sort = sort;
    saveConfig();
    onSortChanged.add(_sort);
  }

  int _filter;

  int get filter => _filter;

  set filter(int filter) {
    _filter = filter;
    saveConfig();
    onFilterChanged.add(_filter);
  }

  CopySetting copySetting;

  ConfigProvider() {
    loadConfig();
  }

  @override
  void dispose() {
    onSortChanged.close();
    super.dispose();
  }

  loadConfig() async {
    try {
      /// shopping
      String response = await StorageManager.getObjectByKey(_keyConfig);
      if (response == null || response.isEmpty) {
        _sort = 1;
        _filter = 1;
        copySetting = CopySetting(
            productCode: true,
            productName: true,
            bonusPrice: 50000,
            phoneNumber: '',
            address: '');
      } else {
        var json = jsonDecode(response);
        _sort = json['sort'] ?? 1;
        _filter = json['filter'] ?? 1;
        copySetting = CopySetting.fromJson(json['copySetting']);
      }
    } catch (e) {
      _sort = 1;
      _filter = 1;
    }
  }

  saveConfig() {
    notifyListeners();
    var myJsonString = json.encode(toJson());
    StorageManager.setObject(_keyConfig, myJsonString);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['filter'] = this.filter;
    data['copySetting'] = this.copySetting.toJson();
    return data;
  }
}
