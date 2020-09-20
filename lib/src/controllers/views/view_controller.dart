import 'dart:convert';
import 'dart:io';
import 'package:ann_shop_flutter/src/controllers/ann_controller.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_download.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_logging.dart';
import 'package:ann_shop_flutter/src/models/views/view_model.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class ViewController extends ANNController {
  static final _instance = ViewController._internal();

  // endregion

  // region Parameters
  ANNLogging _logging;
  ANNDownload _download;

  // endregion

  // region Getter
  static ViewController get instance => _instance;

  // endregion

  ViewController._internal() {
    _logging = ANNLogging.instance;
    _download = ANNDownload.instance;
  }

  factory ViewController() => instance;

  Future<ViewModel> getViewBySlug(String slug) async {
    try {
      final url = 'flutter/$slug';
      final response = await AppHttp.get(url).timeout(Duration(seconds: 10));
      final body = response.body;

      if (response.statusCode == HttpStatus.ok) {
        return new ViewModel.formJson(jsonDecode(body));
      } else {
        _logging.logError('API - Post & Blog', body);

        throw Exception('Đã có lỗi xãy ra.');
      }
    } catch (e) {
      _logging.logError('API - Post & Blog', e);

      throw Exception('Đã có lỗi xãy ra.');
    }
  }

  Future<void> downloadImage(BuildContext context, List<String> images) async {
    _download.downloadImages(context, images);
  }
}
