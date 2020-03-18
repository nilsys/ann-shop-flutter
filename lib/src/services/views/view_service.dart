import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/src/models/views/view_model.dart';
import 'package:ann_shop_flutter/src/services/ann_service.dart';
import 'package:ann_shop_flutter/src/services/utils/ann_download.dart';
import 'package:ann_shop_flutter/src/services/utils/ann_logging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ViewService extends ANNService {
  // region Singleton Pattern
  static final _instance = ViewService._internal();

  // endregion

  // region Parameters
  ANNLogging _logging;
  ANNDownload _download;

  // endregion

  // region Getter
  static ViewService get instance => _instance;

  // endregion

  ViewService._internal() {
    _logging = ANNLogging.instance;
    _download = ANNDownload.instance;
  }

  factory ViewService() => instance;

  Future<ViewModel> getViewBySlug(String slug) async {
    try {
      final url = '${Core.domain}api/flutter/$slug';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(Duration(seconds: 10));
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
