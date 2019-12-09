import 'dart:convert';
import 'dart:core';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final String _keyLocaleFavorite = '_keyLocaleFavorite';
  static List<ProductFavorite> _products;
  List<ProductFavorite> get products => _products;

  FavoriteProvider() {
    loadShoppingList();
  }

  loadShoppingList() async {
    try {
      if (_products == null) {
        /// shopping
        String response =
            await StorageManager.getObjectByKey(_keyLocaleFavorite);
        if (response == null || response.isEmpty) {
          _products = new List();
        } else {
          var message = json.decode(response);
          var list = message as List;
          _products =
              list.map((item) => ProductFavorite.fromJson(item)).toList();
        }
      }
    } catch (e) {
      _products = new List();
    }
  }

  saveShoppingList() {
    var myJsonString =
        json.encode(_products.map((value) => value.toJson()).toList());
    StorageManager.setObject(_keyLocaleFavorite, myJsonString);
  }

  addNewProduct(Product item, {int count = 1}) {
    List<ProductFavorite> array =
        _products.where((p) => p.product.productID == item.productID).toList();
    if (Utility.isNullOrEmpty(array)) {
      _products.add(ProductFavorite(product: item, count: count));
    } else {
      array[0].count = count;
    }
    saveShoppingList();
    notifyListeners();
    print('Add $count productID ${item.productID}');
  }

  removeAllProductProvider() {
    _products = new List();
    saveShoppingList();
    notifyListeners();
  }

  removeProduct(int productID) {
    _products.removeWhere((p) => p.product.productID == productID);
    saveShoppingList();
    notifyListeners();
    print('Remove productID $productID');
  }

  bool containsInFavorite(int productID) {

    for(var m in _products){
      if(m.product.productID == productID)
        return true;
    }
    return false;
  }
}
