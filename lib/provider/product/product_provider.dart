import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ping9/ping9.dart';

import 'package:ann_shop_flutter/provider/product/product_repository.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    // instructor
  }

  Map<String, ApiResponse<ProductDetail>> products = new Map();
  Map<String, ApiResponse<List<ProductRelated>>> related = new Map();

  ApiResponse<ProductDetail> getBySlug(String code) {
    if (products[code] == null) {
      products[code] = ApiResponse<ProductDetail>();
      loadProduct(code);
    }
    return products[code];
  }

  ApiResponse<List<ProductRelated>> getRelatedBySlug(String code) {
    if (related[code] == null) {
      related[code] = ApiResponse<List<ProductRelated>>();
      loadRelatedProduct(code);
    }
    return related[code];
  }

  loadProduct(String code) async {
    try {
      products[code].loading = 'Loading';
      var data = await ProductRepository.instance.loadProductDetail(code);
      if (data == null) {
        products[code].error = 'Load fail';
      } else {
        products[code].completed = data;
      }
      notifyListeners();
    } catch (e) {
      products[code].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }

  loadRelatedProduct(String code) async {
    try {
      related[code].loading = 'Loading';
      var data = await ProductRepository.instance.loadRelatedOfProduct(code);
      if (data == null) {
        related[code].error = 'Load fail';
      } else {
        related[code].completed = data;
      }
      notifyListeners();
    } catch (e) {
      related[code].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }
}
