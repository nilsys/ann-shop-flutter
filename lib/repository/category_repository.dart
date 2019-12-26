import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/category_home.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CategoryRepository {
  static final CategoryRepository instance = CategoryRepository._internal();

  factory CategoryRepository() => instance;

  CategoryRepository._internal() {
    /// init
  }

  /// http://ann-shop-server.com/api/flutter/categories
  Future<List<Category>> loadCategories() async {
    try {
      final url = Core.domain + 'api/flutter/' + 'categories';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<Category> _data = new List();
        message.forEach((v) {
          _data.add(new Category.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  /// http://ann-shop-server.com/api/flutter/home/categories
  Future<List<Category>> loadCategoryHome() async {
    try {
      final url = Core.domain + 'api/flutter/' + 'home/categories';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<Category> _data = new List();
        message.forEach((v) {
          _data.add(new Category.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  Future<List<Category>> loadCategoriesOffline() async {
    try {
      final url = 'assets/offline/categories.json';
      final response = await rootBundle.loadString(url);
      var message = jsonDecode(response);
      List<Category> _data = new List();
      message.forEach((v) {
        _data.add(new Category.fromJson(v));
      });
      return _data;
    } catch (e) {
      log(e);
    }
    return null;
  }

  /// http://ann-shop-server.com/api/flutter/home/blocks
  Future<List<CategoryHome>> loadDataHome() async {
    try {
      final url = Core.domain + 'api/flutter/' + 'home/blocks';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<CategoryHome> _data = new List();
        message.forEach((v) {
          _data.add(new CategoryHome.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  Future<List<CategoryHome>> loadDataHomeOffline() async {
    try {
      final url = 'assets/offline/home_blocks.json';
      final response = await rootBundle.loadString(url);
      var message = jsonDecode(response);

      List<CategoryHome> _data = new List();
      message.forEach((v) {
        _data.add(new CategoryHome.fromJson(v));
      });
      return _data;
    } catch (e) {
      log(e);
    }
    return null;
  }

  log(object) {
    print('category_repository: ' + object.toString());
  }
}
