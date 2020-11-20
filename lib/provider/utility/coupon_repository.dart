import 'dart:convert';
import 'dart:io';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/coupon.dart';
import 'package:ann_shop_flutter/model/utility/promotion.dart';

class CouponRepository {
  factory CouponRepository() => instance;

  CouponRepository._internal();

  static final CouponRepository instance = CouponRepository._internal();

  /// http://backend.xuongann.com/api/flutter/
  Future<List<Coupon>> loadMyCoupon() async {
    try {
      final url = 'flutter/coupon/customer';
      final response =
          await AppHttp.get(url).timeout(const Duration(minutes: 5));

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

  /// http://backend.xuongann.com/api/flutter/coupon/promotions
  Future<List<Promotion>> loadListPromotion() async {
    try {
      final url = 'flutter/coupon/promotions';
      final response =
          await AppHttp.get(url).timeout(const Duration(minutes: 5));

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

  /// http://backend.xuongann.com/api/flutter/coupon/${code}
  Future<String> receiveCoupon(String code) async {
    try {
      final url = 'flutter/coupon/$code';
      final response =
          await AppHttp.get(url).timeout(const Duration(minutes: 5));

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
