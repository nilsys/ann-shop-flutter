import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CoverRepository {
  static final CoverRepository instance = CoverRepository._internal();

  factory CoverRepository() => instance;

  CoverRepository._internal() {
    /// init
  }

  /// http://xuongann.com/api/flutter/home/banners
  Future<List<Cover>> loadCoverHome() async {
    return null;
    try {
      final url = Core.domain + 'api/flutter/home/banners';
      final response = await http.get(url).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<Cover> _data = new List();
        message.forEach((v) {
          _data.add(new Cover.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      log(e);
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
      log(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/home/notification
  Future<List<Cover>> loadHomeNotification() async {
    try {
//      final url = Core.domain + 'api/flutter/home/posts';
//      final response = await http.get(url).timeout(Duration(seconds: 5));
//      log(url);
//      log(response.body);
//    final body = response.body;
      final body =
          await rootBundle.loadString('assets/offline/home_notification.json');

//      if (response.statusCode == HttpStatus.ok) {
      var message = jsonDecode(body);
      List<Cover> _data = new List();
      message.forEach((v) {
        _data.add(new Cover.fromJson(v));
      });
      return _data;
//      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/home/posts
  Future<List<Cover>> loadHomePost() async {
    try {
//      final url = Core.domain + 'api/flutter/home/posts';
//      final response = await http.get(url).timeout(Duration(seconds: 5));
//      log(url);
//      log(response.body);
      //    final body = response.body;
      final body =
      await rootBundle.loadString('assets/offline/home_post.json');
//      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(body);
        List<Cover> _data = new List();
        message.forEach((v) {
          _data.add(new Cover.fromJson(v));
        });
        return _data;
//      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  log(object) {
    print('cover_repository: ' + object.toString());
  }
}
