import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  static final ProductRepository instance = ProductRepository._internal();

  factory ProductRepository() => instance;

  ProductRepository._internal() {
    /// init
    productSorts = [
      ProductSort(id: 4, title: 'Mới nhập kho'),
      ProductSort(id: 2, title: 'Giá giảm dần'),
      ProductSort(id: 1, title: 'Giá tăng dần'),
      ProductSort(id: 3, title: 'Mẫu mới nhất'),
    ];

    productBadge = [
      ProductBadge(id: 1, title: 'Hàng có sẳn'),
      ProductBadge(id: 2, title: 'Hàng order'),
      ProductBadge(id: 3, title: 'Hàng sale'),
    ];

    _productColors = {
      10: Colors.black,
      23: Colors.red[800], //Đỏ đô
      32: Colors.deepOrangeAccent[100], //Hồng cam
      38: Colors.orangeAccent[100], //Hồng phấn
      51: Colors.brown, //Kem đậm
      52: Colors.deepOrangeAccent[100], //Kem nhạt
      88: Colors.yellow,
      96: Colors.blueGrey[100], //Vỏ đậu
      108: Colors.grey, //Xám tiêu
      123: Colors.blueGrey, //Xanh đen
      128: Colors.green, //Xanh lá
      132: Colors.cyan, //Xanh lông công
    };
  }

  List<ProductSort> productSorts;
  List<ProductBadge> productBadge;
  Map<int, Color> _productColors;

  Color getColorByID(id) {
    return _productColors[id] ?? Colors.red;
  }

  final _prefixCategoryKey = 'key_product_by_category_';

  List<Product> listProductByString(String body) {
    try {
      if (Utility.isNullOrEmpty(body)) {
        return [];
      }
      var message = jsonDecode(body);
      List<Product> _data = new List();
      message.forEach((v) {
        _data.add(new Product.fromJson(v));
      });
      return _data;
    } catch (e) {
      return null;
    }
  }

  /// http://xuongann.com/api/v1/category/quan-ao-nam/product?pageNumber=1&pageSize=28&sort=4
  Future<List<Product>> loadByCategory(String name,
      {page = 1, pageSize = 10, AppFilter filter, cache = false}) async {
    try {
      var url = Core.domain + 'api/v1/' +
          'category/$name/product?pageNumber=$page&pageSize=$pageSize';
      if (filter != null) {
        if (filter.sort > 0) {
          url += '&sort=${filter.sort}';
        }
        if (filter.min != null) {
          url += '&priceMin=${filter.min}';
        }
        if (filter.max != null) {
          url += '&priceMax=${filter.max}';
        }
        for (int i = 0; i < filter.badge.length; i++) {
          url += '&badge[$i]=${filter.badge[i]}';
        }
      }
      print(url);
      final response = await http.get(url).timeout(Duration(seconds: 10));
      print(url);
      print(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (cache) {
          StorageManager.setObject(_prefixCategoryKey + name, response.body);
        }
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      log(e.toString());
    }
    if (cache) {
      String body =
          await StorageManager.getObjectByKey(_prefixCategoryKey + name);
      log('Cache: ' + body);
      if (Utility.isNullOrEmpty(body) == false) {
        return listProductByString(body);
      }
    }
    return null;
  }

  Future<List<Product>> loadBySearch(String text,
      {page = 1, pageSize = 30, AppFilter filter}) async {
    try {
      String search = text.replaceAll(' ', '%20');
      var url = Core.domain + 'api/v1/' +
          "search/search-product/$search?pageNumber=$page&pageSize=$pageSize";
      if (filter != null) {
        if (filter.sort > 0) {
          url += '&sort=${filter.sort}';
        }
        if (filter.min != null) {
          url += '&priceMin=${filter.min}';
        }
        if (filter.max != null) {
          url += '&priceMax=${filter.max}';
        }
        for (int i = 0; i < filter.badge.length; i++) {
          url += '&badge[$i]=${filter.badge[i]}';
        }
      }
      final response = await http.get(url).timeout(Duration(seconds: 10));
      print(url);
      print(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<Product>> loadByTag(String text,
      {page = 1, pageSize = 20, AppFilter filter}) async {
    try {
      var url = Core.domain + 'api/v1/' +
          "tag/$text/product?pageNumber=$page&pageSize=$pageSize";
      if (filter != null) {
        if (filter.sort > 0) {
          url += '&sort=${filter.sort}';
        }
        if (filter.min != null) {
          url += '&priceMin=${filter.min}';
        }
        if (filter.max != null) {
          url += '&priceMax=${filter.max}';
        }
        for (int i = 0; i < filter.badge.length; i++) {
          url += '&badge[$i]=${filter.badge[i]}';
        }
      }
      final response = await http.get(url).timeout(Duration(seconds: 10));
      print(url);
      print(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// http://xuongann.com/api/v1/product/ao-thun-nam-ca-sau-adidas
  Future<ProductDetail> loadProductDetail(String slug) async {
    try {
      final url = Core.domain + 'api/v1/' + 'product/' + slug;
      final response = await http.get(url).timeout(Duration(seconds: 10));
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        return ProductDetail.fromJson(message);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// http://xuongann.com/api/v1/product/ao-thun-nam-ca-sau-adidas/related?pageNumber=1&pageSize=30
  Future<List<ProductRelated>> loadRelatedOfProduct(String slug) async {
    try {
      final url =
          Core.domain + 'api/v1/' + 'product/$slug/related?pageNumber=1&pageSize=100';
      final response = await http.get(url).timeout(Duration(seconds: 10));
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<ProductRelated> _data = new List();
        message.forEach((v) {
          _data.add(new ProductRelated.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }


  Future<String> loadProductImageSize(int id, int color, int size) async {
    try {
      final url =
          Core.domain + 'api/v1/' + 'product/$id/image?color=$color&size=$size';
      final response = await http.get(url).timeout(Duration(seconds: 10)).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        return message;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  /// LOG
  log(object) {
    print('product_repository: ' + object.toString());
  }
}
