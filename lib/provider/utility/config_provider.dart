import 'dart:async';
import 'dart:convert';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  final _keyConfig = '_keyConfig';
  static StreamController onFilterChanged =
      StreamController<AppFilter>.broadcast();

  ConfigProvider() {
    _isEditFilter = false;
    loadConfig();
  }

  AppFilter filter;

  int get sort => filter.sort;

  set sort(int sort) {
    filter.sort = sort;
    saveConfig();
    onFilterChanged.add(filter);
  }


  set priceMin(value) {
    filter.priceMin = value;
    _isEditFilter = true;
  }

  set priceMax(value) {
    filter.priceMax = value;
    _isEditFilter = true;
  }

  set badge(value){
    _isEditFilter = true;
    filter.badge = value;
    notifyListeners();
  }

  bool _isEditFilter;

  saveFilter() {
    if (_isEditFilter) {
      onFilterChanged.add(filter);
      saveConfig();
      _isEditFilter = false;
    }
  }

  refreshFilter() {
    _isEditFilter = true;
    filter = AppFilter();
  }

  int _view;

  int get view => _view;

  set view(int view) {
    _view = view;
    saveConfig();
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
        _view = ViewType.grid;
        filter = AppFilter();
      } else {
        var json = jsonDecode(response);
        _view = json['view'] ?? ViewType.grid;
        filter = AppFilter.fromJson(json['filter']);
      }
    } catch (e) {
      _view = ViewType.grid;
      filter = AppFilter();
    }
  }

  saveConfig() {
    notifyListeners();
    var myJsonString = json.encode(toJson());
    StorageManager.setObject(_keyConfig, myJsonString);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view'] = this.view;
    data['filter'] = this.filter.toJson();
    return data;
  }
}

class ViewType {
  static const list = 0;
  static const grid = 1;
  static const big = 2;
}
