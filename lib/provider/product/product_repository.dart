import 'dart:convert';
import 'dart:io';

import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:ann_shop_flutter/model/copy_setting/copy_setting.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';

class ProductRepository {
  factory ProductRepository() => instance;
  static final ProductRepository instance = ProductRepository._internal();

  ProductRepository._internal();

  /// http://backend.xuongann.com/api/flutter/product/ao-thun-nam-ca-sau-adidas
  Future<ProductDetail> loadProductDetail(String slug) async {
    try {
      final url = 'flutter/product/$slug';
      final response = await AppHttp.get(
        url,
      ).timeout(const Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(response.body);
        printTrack(message);
        return ProductDetail.fromJson(message);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/product/ao-thun-nam-ca-sau-adidas/related
  Future<List<ProductRelated>> loadRelatedOfProduct(String slug,
      {int page = 1, int pageSize = itemPerPage}) async {
    try {
      final url =
          'flutter/product/$slug/related?pageNumber=$page&pageSize=$pageSize';
      final response = await AppHttp.get(
        url,
      ).timeout(const Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        final List<ProductRelated> _data = [];
        message.forEach((v) {
          _data.add(ProductRelated.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/product/1/image?color=10&size=178
  Future<String> loadProductImageSize(int id, int color, int size) async {
    try {
      final url = 'flutter/product/$id/image?color=$color&size=$size';
      final response = await AppHttp.get(
        url,
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(response.body);
        return message;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/product/1/advertisement-image
  Future<List<String>> loadProductAdvertisementImage(int id) async {
    try {
      final url = 'flutter/product/$id/advertisement-image';
      final response = await AppHttp.get(
        url,
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(response.body);
        return message.cast<String>();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/product/1/advertisement-content
  Future<String> loadProductAdvertisementContent(int id) async {
    try {
      final CopySetting copySetting = CopyController.instance.copySetting;
      final Map data = {
        "shopPhone": copySetting.phoneNumber,
        "shopAddress": copySetting.address,
        "showSKU": copySetting.productCode,
        "showProductName": copySetting.productName,
        "increntPrice": copySetting.bonusPrice
      };
      final url = 'flutter/product/$id/advertisement-content';
      final response = await AppHttp.post(url, body: jsonEncode(data))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        Map successResponseModel = jsonDecode(response.body);
        return successResponseModel["data"];
      }
    } catch (e) {
      print(e);
    }
    return '';
  }
}
