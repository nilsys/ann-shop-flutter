import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/utility/coupon.dart';
import 'package:ann_shop_flutter/model/utility/promotion.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';

class CouponRepository {
  factory CouponRepository() => instance;

  CouponRepository._internal();

  static final CouponRepository instance = CouponRepository._internal();

  Future<bool> uploadRetailerDetail(
      {String base64Image, File picture, String compare}) async {
    try {
      final myHeader = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppHttp.tokenApi}"
      };

      final Map<String, String> mapData = {};
      final stream =
          http.ByteStream(DelegatingStream.typed(picture.openRead()));
      final length = await picture.length();
      final url = '${AppHttp.domain}flutter/upload/app-review-evidence';
      final uri = Uri.parse(url);
      // create multipart request
      final MultipartRequest request = http.MultipartRequest(
        "POST",
        uri,
      );
      // multipart that takes file
      final MultipartFile multipartFile = http.MultipartFile(
          'image', stream, length,
          filename: basename(picture.path));
      // add file to multipart
      request.fields.addAll(mapData);
      request.headers.addAll(myHeader);
      request.files.add(multipartFile);
      // send
//      final response = await request.send();
      final response = await AppHttp.post(url,
          body: json.encode({'imageBase64': base64Image}));

      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      print(e);
    }
    return false;
  }

  /// http://xuongann.com/api/flutter/
  Future<List<Coupon>> loadMyCoupon() async {
    try {
      final url = 'flutter/coupon/customer';
      final response =
          await AppHttp.get(url).timeout(const Duration(seconds: 10));

      final body = response.body;
      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(body);
        if (isNullOrEmpty(message) || message == 'null') {
          return [];
        } else {
          List<Coupon> _data = [];
          message.forEach((v) {
            _data.add(Coupon.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/coupon/promotions
  Future<List<Promotion>> loadListPromotion() async {
    try {
      final url = 'flutter/coupon/promotions';
      final response =
          await AppHttp.get(url).timeout(const Duration(seconds: 10));

      final body = response.body;
      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(body);
        if (isNullOrEmpty(message)) {
          return [];
        } else {
          List<Promotion> _data = [];
          message.forEach((v) {
            _data.add(Promotion.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/coupon/${code}
  Future<String> receiveCoupon(String code) async {
    try {
      final url = 'flutter/coupon/$code';
      final response =
          await AppHttp.get(url).timeout(const Duration(seconds: 10));

      final body = response.body;
      if (response.statusCode == HttpStatus.ok) {
        return null;
      } else {
        final message = jsonDecode(body);
        return message['Message'] ?? 'Có lỗi xãi ra, vui lòng thử lại sau';
      }
    } catch (e) {
      print(e);
    }
    return 'Có lỗi xãi ra, vui lòng thử lại sau';
  }
}
