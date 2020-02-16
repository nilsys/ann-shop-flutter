import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:http/http.dart' as http;

class BlogRepository {
  static final BlogRepository instance = BlogRepository._internal();

  factory BlogRepository() => instance;

  BlogRepository._internal() {
    /// init
  }

  /// http://xuongann.com/api/flutter/post-categories
  Future<List<BlogCategory>> loadCategoryBlog() async {
    try {
      var url = '${Core.domain}api/flutter/post-categories';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(Duration(seconds: 10));
      log(url);
      log(response.body);
      final body = response.body;
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(body);
        if (Utility.isNullOrEmpty(message)) {
          return [];
        } else {
          List<BlogCategory> _data = new List();
          message.forEach((v) {
            _data.add(new BlogCategory.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/
  Future<List<Cover>> loadBlog(String category,
      {page = 1, pageSize = 20}) async {
    try {
      var url = Core.domain;

      if (Utility.isNullOrEmpty(category)) {
        url += 'api/flutter/posts?pageNumber=$page&pageSize=$pageSize';
      } else {
        url +=
            'api/flutter/posts?categorySlug=$category&pageNumber=$page&pageSize=$pageSize';
      }
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(Duration(seconds: 10));
      log(url);
      log(response.body);
      final body = response.body;

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(body);
        if (Utility.isNullOrEmpty(message)) {
          return [];
        } else {
          List<Cover> _data = new List();
          message.forEach((v) {
            _data.add(new Cover.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  log(object) {
    print('blog_repository: ' + object.toString());
  }
}
