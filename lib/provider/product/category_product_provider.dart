import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';

class CategoryProductProvider extends ChangeNotifier {
  CategoryProductProvider() {
    // instructor
  }

  static Map<String, ResponseProvider<List<Product>>> categories = new Map();

  ResponseProvider<List<Product>> getByCategory(String code){

    if(categories[code] == null){
      categories[code] = ResponseProvider<List<Product>>();
      loadCategory(code);
    }
    return categories[code];
  }

  loadCategory(String code) async {
    try {
      categories[code].loading = 'Loading';
      var list = await ProductRepository.instance.loadByCategory(code);
      if (list == null) {
        categories[code].error = 'Load fail';
      } else {
        categories[code].completed = list;
      }
      notifyListeners();
    } catch (e) {
      categories[code].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }
}
