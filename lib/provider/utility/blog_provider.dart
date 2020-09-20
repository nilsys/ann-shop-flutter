import 'dart:core';

import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/blog_category.dart';

import 'package:ann_shop_flutter/provider/utility/blog_repository.dart';
import 'package:flutter/material.dart';

class BlogProvider with ChangeNotifier {
  ApiResponse<List<BlogCategory>> category;
  BlogCategory _currentCategory;

  BlogCategory get currentCategory => _currentCategory;

  set currentCategory(BlogCategory currentCategory) {
    _currentCategory = currentCategory;
    notifyListeners();
  }

  BlogProvider() {
    // init
    category = ApiResponse();
    _currentCategory = BlogCategory(name: "Tất cả", filter: BlogCategoryFilter());
    fetchBlog();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkReload() {
    if (category.isLoading == false) {
      if (category.isLoadFinish() == false) {
        fetchBlog();
      }
    }
  }

  Future loading;

  Future fetchBlog() async {
    loading = _fetchBlog();
    await loading;
    loading = null;
  }

  Future _fetchBlog() async {
    try {
      category.loading = 'loading';
      notifyListeners();
      var data = await BlogRepository.instance.loadCategoryBlog();
      if (data == null) {
        category.error = 'load error';
      } else {
        if (isNullOrEmpty(data) == false) {
          _currentCategory = data[0];
        }
        category.completed = data;
      }
    } catch (e) {
      print(e);
      category.error = 'Error exception' + e.toString();
    }
    notifyListeners();
  }
}
