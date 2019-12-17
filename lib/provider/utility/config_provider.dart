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

  double get priceMin => filter.priceMin;

  set priceMin(double priceMin) {
    filter.priceMin = priceMin;
    _isEditFilter = true;
  }

  double get priceMax => filter.priceMax;

  set priceMax(double priceMax) {
    filter.priceMax = priceMax;
    _isEditFilter = true;
  }

  addBadge(id) {
    _isEditFilter = true;
    filter.badge.add(id);
    notifyListeners();
  }

  removeBadge(id) {
    _isEditFilter = true;
    filter.badge.remove(id);
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
        reset();
      } else {
        var json = jsonDecode(response);
        _view = json['view'] ?? ViewType.list;
        filter = AppFilter.fromJson(json['filter']);
      }
    } catch (e) {
      reset();
    }
  }

  reset() {
    _view = ViewType.list;
    filter = AppFilter();
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
