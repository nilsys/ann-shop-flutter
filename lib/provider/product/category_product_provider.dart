import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';

import 'package:ann_shop_flutter/provider/utility/list_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class CategoryProductProvider extends ChangeNotifier {
  CategoryProductProvider();

  Map<dynamic, ApiResponse<List<Product>>> categories = new Map();

  forceRefresh() {
    categories = new Map();
    notifyListeners();
  }

  ApiResponse<List<Product>> getByCategory(Category category) {
    String code = category.getKey;
    if (categories[code] == null) {
      categories[code] = ApiResponse<List<Product>>();
      loadCategory(category);
    }
    return categories[code];
  }

  loadCategory(Category category, {refresh = false}) async {
    String code = category.getKey;
    try {
      categories[code].loading = 'Loading';
      if (refresh) notifyListeners();

      var list =
          await ListProductRepository.instance.loadByCategoryFilter(category);
      if (list == null) {
        list = await ListProductRepository.instance.loadByCache(code);
      } else {
        ListProductRepository.instance.cacheProduct(code, list);
      }
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
