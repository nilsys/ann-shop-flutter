import 'dart:convert';
import 'dart:core';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final String _keyLocaleFavorite = '_keyLocaleFavorite';
  List<ProductFavorite> products;

  FavoriteProvider() {
    loadShoppingList();
  }

  loadShoppingList() async {
    try {
      if (products == null) {
        /// shopping
        String response =
            await StorageManager.getObjectByKey(_keyLocaleFavorite);
        if (response == null || response.isEmpty) {
          products = new List();
        } else {
          var message = json.decode(response);
          var list = message as List;
          products =
              list.map((item) => ProductFavorite.fromJson(item)).toList();
        }
      }
    } catch (e) {
      products = new List();
    }
  }

  saveShoppingList() {
    var myJsonString =
        json.encode(products.map((value) => value.toJson()).toList());
    StorageManager.setObject(_keyLocaleFavorite, myJsonString);
  }

  addNewProduct(Product item, {int count = 1}) {
    List<ProductFavorite> array =
        products.where((p) => p.product.productID == item.productID).toList();
    if (Utility.isNullOrEmpty(array)) {
      products.add(ProductFavorite(product: item, count: count));
    } else {
      array[0].count = count;
    }
    saveShoppingList();
    notifyListeners();
    print('Add $count productID ${item.productID}');
  }

  changeCount(ProductFavorite favorite, int _count) {
    if(_count<=0){
      products.remove(favorite);
    }else {
      favorite.count = _count;
    }
    notifyListeners();
  }

  removeAllProductProvider() {
    products = new List();
    saveShoppingList();
    notifyListeners();
  }

  removeProduct(int productID) {
    products.removeWhere((p) => p.product.productID == productID);
    saveShoppingList();
    notifyListeners();
    print('Remove productID $productID');
  }

  bool containsInFavorite(int productID) {
    for (var m in products) {
      if (m.product.productID == productID) return true;
    }
    return false;
  }
}
