import 'dart:convert';
import 'dart:core';

import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  FavoriteProvider() {
    loadShoppingList();
  }

  final String _keyLocaleFavorite = '_keyLocaleFavorite';
  List<ProductFavorite> products;

  Future loadShoppingList() async {
    try {
      /// shopping
      final response =
          await UserDefaults.instance.getObjectByKey(_keyLocaleFavorite);
      if (isNullOrEmpty(response)) {
        products = [];
      } else {
        final message = json.decode(response);
        final list = message as List;
        products = list.map((item) => ProductFavorite.fromJson(item)).toList();
      }
    } catch (e) {
      products = [];
    }
  }

  saveShoppingList() {
    var myJsonString =
        jsonEncode(products.map((value) => value.toJson()).toList());
    UserDefaults.instance.setObject(_keyLocaleFavorite, myJsonString);
  }

  addNewProduct(context, Product item, {int count = 1}) {
    if (AC.instance.isLogin == false) {
      AppSnackBar.askLogin(context);
      return;
    }

    List<ProductFavorite> array =
        products.where((p) => p.product.productId == item.productId).toList();
    if (isNullOrEmpty(array)) {
      products.add(ProductFavorite(product: item, count: count));
    } else {
      array[0].count = count;
    }
    saveShoppingList();
    notifyListeners();
    AppSnackBar.showHighlightTopMessage(
        context, 'Đã lưu vào danh sách yêu thích');
  }

  changeCount(ProductFavorite favorite, int _count) {
    if (_count <= 0) {
      products.remove(favorite);
    } else {
      favorite.count = _count;
    }
    saveShoppingList();
    notifyListeners();
  }

  removeAllProductProvider() {
    products = new List();
    saveShoppingList();
    notifyListeners();
  }

  removeProduct(int productId) {
    products.removeWhere((p) => p.product.productId == productId);
    saveShoppingList();
    notifyListeners();
  }

  bool containsInFavorite(int productId) {
    for (var m in products) {
      if (m.product.productId == productId) return true;
    }
    return false;
  }
}
