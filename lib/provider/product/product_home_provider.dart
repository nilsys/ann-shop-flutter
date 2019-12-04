import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductHomeProvider extends ChangeNotifier {
  ProductHomeProvider() {
    // instructor
    categories = new List();
    for (int i = 0; i < categoryIDs.length; i++) {
      categories.add(ResponseProvider<List<Product>>());
    }
    loadCategories();
  }

  var categoryIDs = ['bao-li-xi-tet','vay-dam','do-bo-nu'];

  List<ResponseProvider<List<Product>>> categories;

  loadCategories({force = false}) {
    for (int i = 0; i < categoryIDs.length; i++) {
      if (categories[i].isLoading == false) {
        if (force || categories[i].isLoadFinish() == false) {
          loadCategory(i, force: force);
        }
      }
    }
    if (force) notifyListeners();
  }

  loadCategory(int index,{force = false}) async {
    try {
      categories[index].loading = 'Loading';
      if (force) notifyListeners();
      var list = await ProductRepository.instance
          .loadByHomeCategory(categoryIDs[index]);
      if (list == null) {
        categories[index].error = 'Load fail';
      } else {
        categories[index].completed = list;
      }
      notifyListeners();
    } catch (e) {
      categories[index].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }
}
