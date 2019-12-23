import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/category_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CategoryRepository {
  static final CategoryRepository instance = CategoryRepository._internal();

  factory CategoryRepository() => instance;

  CategoryRepository._internal() {
    /// init
  }

  /// http://ann-shop-server.com/api/v1/categories
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

  /// http://ann-shop-server.com/api/v1/home/categories
  Future<List<CategoryHome>> loadCategoryHome() async {
    try {
      return null;
      final url = Core.domain + 'api/flutter/' + 'home/categories';
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

  Future<List<CategoryHome>> loadCategoryHomeOffline() async {
    try {
      final url = 'assets/offline/cateogry_home.json';
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
