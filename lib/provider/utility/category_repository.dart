import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/category_home.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ping9/ping9.dart';

class CategoryRepository {
  static final CategoryRepository instance = CategoryRepository._internal();

  factory CategoryRepository() => instance;

  CategoryRepository._internal() {
    /// init
  }

  /// http://backend.xuongann.com/api/flutter/categories
  Future<List<Category>> loadCategories(String slug) async {
    try {
      final url = 'flutter/$slug';
      final response = await AppHttp.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<Category> _data = new List();
        message.forEach((v) {
          _data.add(new Category.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Category>> loadCategoriesOffline(String path) async {
    try {
      final response = await rootBundle.loadString(path);
      var message = jsonDecode(response);
      List<Category> _data = new List();
      message.forEach((v) {
        _data.add(new Category.fromJson(v));
      });
      return _data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/home/blocks
  Future<List<CategoryHome>> loadDataHome() async {
    try {
      final url = 'flutter/home/blocks';
      final response = await AppHttp.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<CategoryHome> _data = new List();
        message.forEach((v) {
          _data.add(new CategoryHome.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      print(e);
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
      print(e);
    }
    return null;
  }
}
