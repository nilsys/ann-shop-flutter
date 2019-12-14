import 'dart:async';
import 'dart:convert';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/utility/copy_setting.dart';
import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  final _keyConfig = '_keyConfig';
  static StreamController onFilterChanged = StreamController<int>.broadcast();

  int _sort;

  int get sort => _sort;

  set sort(int sort) {
    _sort = sort;
    saveConfig();
    onFilterChanged.add(_sort);
  }

  double priceMin;

  double priceMax;

  List<int> badge;

  addBadge(id) {
    badge.add(id);
    notifyListeners();
  }

  removeBadge(id) {
    badge.remove(id);
    notifyListeners();
  }

  saveFilter() {
    onFilterChanged.add(0);
    saveConfig();
  }

  int _view;

  int get view => _view;

  set view(int view) {
    _view = view;
    saveConfig();
  }

  CopySetting copySetting;

  ConfigProvider() {
    loadConfig();
  }

  @override
  void dispose() {
    onFilterChanged.close();
    super.dispose();
  }

  loadConfig() async {
    try {
      /// shopping
      String response = await StorageManager.getObjectByKey(_keyConfig);
      if (response == null || response.isEmpty) {
        reset();
      } else {
        var json = jsonDecode(response);
        _view = json['view'] ?? ViewType.list;
        _sort = json['sort'] ?? 1;
        priceMin = json['priceMin'] ?? -1;
        priceMax = json['priceMax'] ?? 501;
        badge = json['badge'].cast<int>();
        copySetting = CopySetting.fromJson(json['copySetting']);
      }
    } catch (e) {
      reset();
    }
  }

  reset() {
    _view = ViewType.list;
    _sort = 1;
    priceMin = -1;
    priceMax = 501;
    badge = [];
    copySetting = CopySetting(
        productCode: true,
        productName: true,
        bonusPrice: 50000,
        phoneNumber: '',
        address: '');
  }

  saveConfig() {
    notifyListeners();
    var myJsonString = json.encode(toJson());
    StorageManager.setObject(_keyConfig, myJsonString);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view'] = this.view;
    data['sort'] = this.sort;
    data['badge'] = this.badge;
    data['priceMin'] = this.priceMin;
    data['priceMax'] = this.priceMax;
    data['copySetting'] = this.copySetting.toJson();
    return data;
  }
}

class ViewType {
  static const list = 0;
  static const grid = 1;
  static const big = 2;
}
