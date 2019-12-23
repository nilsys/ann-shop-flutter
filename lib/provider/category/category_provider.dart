import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/category_home.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/category_repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    categories = ResponseProvider();
    categoryHome = ResponseProvider();
    loadCategoryHome();
    loadCategories();
  }

  ResponseProvider<List<Category>> categories;
  ResponseProvider<List<CategoryHome>> categoryHome;

  List<Category> allCategory;
  List<Category> allCategoryHome;

  Category getCategory(code) {
    try {
      var item = categories.data.firstWhere((m) {
        return m.slug == code;
      });
      return item;
    } catch (e) {
      return null;
    }
  }

  List<Category> getCategoryRelated(code) {
    try {
      if (categories.isCompleted) {
        for (var item in categories.data) {
          print(item.name);
          print(item.children.length);
          if (item.slug == code) {
            return item.children;
          }
        }
      }
    } catch (e) {}
    return null;
  }

  loadCategories() async {
    try {
      categories.loading = 'try load categories';
      notifyListeners();
      List<Category> data = await CategoryRepository.instance.loadCategories();
      if (data != null) {
        categories.completed = data;
      } else {
        data = await CategoryRepository.instance.loadCategoriesOffline();
        categories.completed = data;
      }
      refreshCategoriesByList();
    } catch (e) {
      log(e);
      categories.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadCategoryHome() async {
    try {
      categoryHome.loading = 'try load categories';
      notifyListeners();
      List<CategoryHome> data =
          await CategoryRepository.instance.loadCategoryHome();
      if (data != null) {
        categoryHome.completed = data;
      } else {
        data = await CategoryRepository.instance.loadCategoryHomeOffline();
        categoryHome.completed = data;
      }
      refreshCategoryHomeByList();
    } catch (e) {
      log(e);
      categoryHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  refreshCategoriesByList() {
    allCategory = new List();
    if (categories.isCompleted) {
      for (var item in categories.data) {
        if (Utility.isNullOrEmpty(item.slug) == false) {
          allCategory.add(item);
        }
        if (Utility.isNullOrEmpty(item.children) == false) {
          for (var child in item.children) {
            allCategory.add(child);
          }
        }
      }
    }
  }
  refreshCategoryHomeByList() {
    allCategoryHome = new List();
    if (categoryHome.isCompleted) {
      for (var item in categoryHome.data) {
        if (Utility.isNullOrEmpty(item.category.slug) == false) {
          allCategoryHome.add(item.category);
        }
        if (Utility.isNullOrEmpty(item.category.children) == false) {
          for (var child in item.category.children) {
            allCategoryHome.add(child);
          }
        }
      }
    }
  }

  log(object) {
    print('category_provider: ' + object.toString());
  }
}
