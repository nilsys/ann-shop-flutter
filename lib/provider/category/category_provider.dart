import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/category_home.dart';
import 'package:ping9/ping9.dart';

import 'package:ann_shop_flutter/provider/utility/category_repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    categories = ApiResponse();
    dataHome = ApiResponse();
    categoryHome = ApiResponse();
    loadCategoryHome();
    loadCategories();
    loadCDataHome();
  }

  ApiResponse<List<Category>> categories;
  ApiResponse<List<CategoryHome>> dataHome;
  ApiResponse<List<Category>> categoryHome;

  loadCategories() async {
    try {
      categories.loading = 'try load categories';
      notifyListeners();
      List<Category> data =
          await CategoryRepository.instance.loadCategories('categories');
      if (data != null) {
        categories.completed = data;
      } else {
        data = await CategoryRepository.instance
            .loadCategoriesOffline('assets/offline/categories.json');
        categories.completed = data;
      }
    } catch (e) {
      print(e);
      categories.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadCategoryHome() async {
    try {
      categoryHome.loading = 'try load categories';
      notifyListeners();
      List<Category> data =
          await CategoryRepository.instance.loadCategories('home/categories');
      if (data != null) {
        categoryHome.completed = data;
      } else {
        data = await CategoryRepository.instance
            .loadCategoriesOffline('assets/offline/home_categories.json');
        categoryHome.completed = data;
      }
    } catch (e) {
      print(e);
      categoryHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadCDataHome() async {
    try {
      dataHome.loading = 'try load categories';
      notifyListeners();
      List<CategoryHome> data =
          await CategoryRepository.instance.loadDataHome();
      if (data != null) {
        dataHome.completed = data;
      } else {
        data = await CategoryRepository.instance.loadDataHomeOffline();
        dataHome.completed = data;
      }
    } catch (e) {
      print(e);
      dataHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }
}
