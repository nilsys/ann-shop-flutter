import 'dart:convert';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/main.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
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
      notifyListeners();
    }
  }

  onSearch(context, value) async {
    setText(text: value);
    if (value.isNotEmpty) {
      ProgressDialog loading =
          ProgressDialog(MyApp.context, message: 'Tìm kiếm sản phẩm...')
            ..show();
      var data = await ProductRepository.instance.loadBySearch(text, filter: AppFilter());
      loading.hide(contextHide: MyApp.context);
      if (Utility.isNullOrEmpty(data)) {
        AppSnackBar.showFlushbar(context, 'Không tìm thấy sản phẩm.');
      } else {
        ListProduct.showBySearch(context, {'title': value, 'products': data});
      }
    }
  }

  setText({String text = ''}) {
    controller = new TextEditingController(text: text);
    if (text.isNotEmpty) {
      if (_history.contains(text) == false) {
        _history.insert(0, text);
      } else {
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

  removeHistoryAll() {
    _history = [];
    notifyListeners();
  }
}
