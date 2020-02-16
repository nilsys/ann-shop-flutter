import 'dart:convert';
import 'dart:io';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/utility/coupon.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class CouponRepository {

  factory CouponRepository() => instance;
  CouponRepository._internal();
  static final CouponRepository instance = CouponRepository._internal();

  Future<bool> uploadRetailerDetail(
      {String base64Image, File picture, String compare}) async {
    final mapData = {};

    final stream =
        http.ByteStream(DelegatingStream.typed(picture.openRead()));
    final length = await picture.length();
    final uri = Uri.parse('${Core.domain}api/flutter/upload-rate');
    // create multipart request
    final request = http.MultipartRequest("POST", uri);
    // multipart that takes file
    final multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(picture.path));
    // add file to multipart
    request.fields.addAll(mapData);
    request.files.add(multipartFile);
    // send
    final response = await request.send();
    //if (response.statusCode != 200) return false;

    return response.statusCode == 200;
  }

  /// http://xuongann.com/api/flutter/
  Future<List<Coupon>> loadMyCoupon() async {
    try {
      final url = '${Core.domain}api/flutter/my-coupon';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(const Duration(seconds: 10));
      log(url);
      log(response.body);
      final body = response.body;
      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(body);
        if (Utility.isNullOrEmpty(message)) {
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
      log(e);
    }
    return null;
  }

  log(object) {
    debugPrint('coupon_repository: $object');
  }
}
