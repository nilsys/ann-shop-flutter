import 'dart:convert';
import 'dart:io';
import 'package:flutube/src/models/my_video.dart';
import 'package:ann_shop_flutter/src/controllers/ann_controller.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_download.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_logging.dart';
import 'package:ann_shop_flutter/src/models/views/view_model.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class ViewController extends ANNController {
  static final _instance = ViewController._internal();

  static ViewController get instance => _instance;

  ViewController._internal();

  factory ViewController() => instance;

  Future<ViewModel> getViewBySlug(String slug) async {
    try {
      final url = 'flutter/$slug';
      final response = await AppHttp.get(url).timeout(Duration(minutes: 5));
      final body = response.body;

      if (response.statusCode == HttpStatus.ok) {
        return new ViewModel.formJson(jsonDecode(body));
      } else {
        ANNLogging.instance.logError('API - Post & Blog', body);

        throw Exception('Đã có lỗi xãy ra.');
      }
    } catch (e) {
      ANNLogging.instance.logError('API - Post & Blog', e);

      throw Exception('Đã có lỗi xãy ra.');
    }
  }

  /// http://backend.xuongann.com/api/flutter/product/1/videos
  Future<List<MyVideo>> getViewMoreVideo(int id) async {
    try {
      final url = 'flutter/post/$id/videos';
      final response = await AppHttp.get(
        url,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        final List<MyVideo> _data = [];
        message.forEach((v) {
          _data.add(MyVideo.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
