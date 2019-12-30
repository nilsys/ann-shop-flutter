import 'dart:convert';
import 'package:ann_shop_flutter/core/router.dart';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/main.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/category_repository.dart';
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
  static ResponseProvider<List<Category>> _hotKeys = ResponseProvider();
  ResponseProvider<List<Category>> get hotKeys => _hotKeys;

  SearchProvider() {
    controller = new TextEditingController();
    loadHistory();
    loadHotKey();
  }

  String get text => controller.text;

  loadHotKey() async{
    try {
      _hotKeys.loading = 'try load hotkeys';
      notifyListeners();
      List<Category> data =
          await CategoryRepository.instance.loadHotKeySearch();
      if (data != null) {
        _hotKeys.completed = data;
      } else {
        _hotKeys.completed = [];
      }
    } catch (e) {
      _hotKeys.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadHistory() async {
    String response = await StorageManager.getObjectByKey(_keyHistory);
    if (response != null) {
      var json = jsonDecode(response);
      _history = json.cast<String>();
      notifyListeners();
    }
  }

  final checkFirst = false;

  onSearch(context, value) async {
    value = value.trim();
    if (value.isNotEmpty) {
      setText(text: value);
      if (checkFirst == false) {
        ListProduct.showBySearch(context,
            Category(name: value, filter: ProductFilter(productSearch: value)));
      } else {
        ProgressDialog loading =
            ProgressDialog(MyApp.context, message: 'Tìm kiếm sản phẩm...')
              ..show();
        var data = await ProductRepository.instance
            .loadBySearch(text, filter: AppFilter());
        loading.hide(contextHide: MyApp.context);
        if (Utility.isNullOrEmpty(data)) {
          AppSnackBar.showFlushbar(context, 'Không tìm thấy sản phẩm.');
        } else {
          if (data.length == 1) {
            Router.showProductDetail(context, product: data[0]);
          } else {
            ListProduct.showBySearch(
                context,
                Category(
                    name: value, filter: ProductFilter(productSearch: value)),
                initData: data);
          }
        }
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
