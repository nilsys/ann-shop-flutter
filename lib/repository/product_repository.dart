import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
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
      ProductBadge(id: 3, title: 'Hàng order'),
      ProductBadge(id: 4, title: 'Hàng sale'),
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

  String getBadgeName(badge) {
    switch (badge) {
      case 1:
        return 'Có sẳn';
        break;
      case 3:
        return 'Order';
        break;
      case 4:
        return 'Sale';
        break;
      default:
        return 'Hết hàng';
        break;
    }
  }

  Color getBadgeColor(badge) {
    switch (badge) {
      case 1:
        return Colors.orange;
        break;
      case 3:
        return Colors.purple;
        break;
      case 4:
        return Colors.grey;
        break;
      default:
        return Colors.grey[700];
        break;
    }
  }

  Color getColorByID(id) {
    return _productColors[id] ?? Colors.red;
  }

  /// http://xuongann.com/api/flutter/product/ao-thun-nam-ca-sau-adidas
  Future<ProductDetail> loadProductDetail(String slug) async {
    try {
      final url = Core.domain + 'api/flutter/product/$slug';
      final response = await http.get(url).timeout(Duration(seconds: 10));
      log(url);
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

  /// http://xuongann.com/api/flutter/product/ao-thun-nam-ca-sau-adidas/related
  Future<List<ProductRelated>> loadRelatedOfProduct(String slug) async {
    try {
      final url = Core.domain + 'api/flutter/product/$slug/related';
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

  /// http://xuongann.com/api/flutter/product/1/image?color=10&size=178
  Future<String> loadProductImageSize(int id, int color, int size) async {
    try {
      final url =
          Core.domain + 'api/flutter/product/$id/image?color=$color&size=$size';
      final response = await http.get(url).timeout(Duration(seconds: 5));
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

  /// http://xuongann.com/api/flutter/product/1/advertisement-image
  Future<List<String>> loadProductAdvertisementImage(int id) async {
    try {
      final url = Core.domain + 'api/flutter/product/$id/advertisement-image';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        return message.cast<String>();
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/product/1/advertisement-content
  Future<String> loadProductAdvertisementContent(int id) async {
    try {
      final url = Core.domain + 'api/flutter/product/$id/advertisement-content';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return response.body;
      }
    } catch (e) {
      log(e.toString());
    }
    return '';
  }

  /// http://xuongann.com/api/flutter/product-sort
  getProductSort() async {
    try {
      final url = Core.domain + 'api/flutter/product-sort';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
    } catch (e) {}
  }

  /// LOG
  log(object) {
    print('product_repository: ' + object.toString());
  }
}
