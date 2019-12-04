import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  static final ProductRepository instance = ProductRepository._internal();

  factory ProductRepository() => instance;

  ProductRepository._internal() {
    /// init
  }

  Future<List<Product>> loadByHomeCategory(String name) async {
    try {
      final url = GlobalConfig.instance.domainAPI + 'home/category/' + name;
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == HttpStatus.ok) {
          var message = jsonDecode(response.body);
          List<Product> _data = new List();
          message.forEach((v) {
            _data.add(new Product.fromJson(v));
          });
          return _data;
      }
    } catch (e) {
      print('loadByHomeCategory: ' + e.toString());
    }
    return null;
  }
}
