import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    // instructor
  }

  Map<String, ResponseProvider<ProductDetail>> products = new Map();

  ResponseProvider<ProductDetail> getBySlug(String code){
    if(products[code] == null){
      products[code] = ResponseProvider<ProductDetail>();
      loadProduct(code);
    }
    return products[code];
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
}
