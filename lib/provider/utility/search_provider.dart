import 'dart:convert';

import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';

import 'package:ann_shop_flutter/provider/utility/category_repository.dart';
import 'package:ann_shop_flutter/provider/utility/list_product_repository.dart';
import 'package:ann_shop_flutter/src/route/route.dart';

import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  // region Parameter
  static final ApiResponse<List<Category>> _hotKeys = ApiResponse();
  final _keyHistory = '_historyKey';

  bool openKeyboard;
  List<String> _history;

  // endregion

  // region Widget
  TextEditingController controller;
  FocusNode focusNode;

  // endregion

  // region Getter
  ApiResponse<List<Category>> get hotKeys => _hotKeys;

  List<String> get history => _history;

  String get text => controller.text;

  // endregion

  SearchProvider() {
    loadHistory();
    checkLoadHotKey();

    openKeyboard = false;
    _history = [];

    controller = TextEditingController();
    focusNode = FocusNode();
  }

  void checkLoadHotKey() {
    if (_hotKeys.isLoading == false && _hotKeys.isCompleted == false) {
      loadHotKey();
    }
  }

  Future loadHotKey() async {
    try {
      _hotKeys.loading = 'try load hotkeys';
      notifyListeners();
      final List<Category> data =
          await CategoryRepository.instance.loadCategories('search/hotkey');
      if (data != null) {
        _hotKeys.completed = data;
      } else {
        _hotKeys.completed = [];
      }
    } catch (e) {
      _hotKeys.error = 'exception: $e';
    }
    notifyListeners();
  }

  Future loadHistory() async {
    String response = await StorageManager.instance.getObjectByKey(_keyHistory);
    if (response != null) {
      var json = jsonDecode(response);
      _history = json.cast<String>();
      notifyListeners();
    }
  }

  final bool checkFirst = false;

  Future onSearch(context, value) async {
    setOpenKeyBoard(false);

    value = value.trim();
    if (value.isNotEmpty) {
      if (AC.instance.canSearchProduct == false) {
        AppSnackBar.showFlushbar(
            context, 'Bạn cần đăng nhập để tiếp tục tìm kiếm sản phẩm');
        return;
      }

      setText(text: value);
      if (checkFirst == false) {
        ListProduct.showBySearch(context,
            Category(name: value, filter: ProductFilter(productSearch: value)));
      } else {
        final loadingDialog =
            new LoadingDialog(context, message: 'Tìm kiếm sản phẩm...');

        loadingDialog.show();
        final data = await ListProductRepository.instance
            .loadBySearch(text, filter: AppFilter());
        loadingDialog.close();

        if (isNullOrEmpty(data)) {
          AppSnackBar.showFlushbar(context, 'Không tìm thấy sản phẩm.');
        } else {
          if (data.length == 1) {
            Routes.showProductDetail(context, product: data[0]);
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

  void setText({String text = ''}) {
    controller = TextEditingController(text: text);
    if (text.isNotEmpty) {
      if (_history.contains(text) == false) {
        _history.insert(0, text);
      } else {
        _history.remove(text);
        _history.insert(0, text);
      }
      StorageManager.instance.setObject(_keyHistory, jsonEncode(history));
    }
    notifyListeners();
  }

  void addHistory(String text) {
    if (text.isNotEmpty) {
      if (_history.contains(text) == false) {
        _history.insert(0, text);
      } else {
        _history.remove(text);
        _history.insert(0, text);
      }
      StorageManager.instance.setObject(_keyHistory, jsonEncode(history));
    }
  }

  void removeHistoryUnit(String title) {
    history.removeWhere((m) => m == title);
    StorageManager.instance.setObject(_keyHistory, jsonEncode(history));
    notifyListeners();
  }

  void removeHistoryAll() {
    _history = [];
    StorageManager.instance.clearObjectByKey(_keyHistory);
    notifyListeners();
  }

  void setOpenKeyBoard(bool open) {
    openKeyboard = open;
    notifyListeners();
  }
}
