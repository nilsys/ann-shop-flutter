import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CoverRepository {
  static final CoverRepository instance = CoverRepository._internal();

  factory CoverRepository() => instance;

  CoverRepository._internal() {
    /// init
  }

  /// http://xuongann.com/api/flutter/home/banners
  Future<List<Cover>> loadCover(String slug) async {
    try {
      final url = 'flutter/$slug';
      final response = await AppHttp.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        if (isNullOrEmpty(message)) {
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
      print(e);
    }
    return null;
  }

  Future<List<Cover>> loadCoverHomeOffline() async {
    try {
      final url = 'assets/offline/home_banner.json';
      final response = await rootBundle.loadString(url);
      var message = jsonDecode(response);
      List<Cover> _data = new List();
      message.forEach((v) {
        _data.add(new Cover.fromJson(v));
      });
      return _data;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
