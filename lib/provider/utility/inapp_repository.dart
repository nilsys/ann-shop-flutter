import 'dart:convert';
import 'dart:io';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_logging.dart';
import 'package:flutter/material.dart';

class InAppRepository {
  // region Singleton Pattern
  static final InAppRepository instance = InAppRepository._internal();

  // endregion

  // region Parameters
  ANNLogging logging;

  List<String> categories;

  // endregion

  InAppRepository._internal() {
    logging = ANNLogging.instance;

    categories = ['promotion', 'notification', 'news'];
  }

  factory InAppRepository() => instance;

  String getNameInApp(String category) {
    switch (category) {
      case 'all':
        return 'Thông báo';
        break;
      case 'promotion':
        return 'Khuyến mãi';
        break;
      case 'notification':
        return 'Hoạt động';
        break;
      case 'news':
        return 'Tin tức';
        break;
      default:
        return 'Thông báo';
        break;
    }
  }

  IconData getIconInApp(String category) {
    switch (category) {
      case 'all':
        return Icons.home;
        break;
      case 'promotion':
        return Icons.local_atm;
        break;
      case 'notification':
        return Icons.receipt;
        break;
      case 'news':
        return Icons.description;
        break;
      default:
        return Icons.message;
        break;
    }
  }

  Color getColorInApp(String category) {
    switch (category) {
      case 'all':
        return Colors.white;
        break;
      case 'promotion':
        return AppStyles.orange;
        break;
      case 'notification':
        return Colors.blue;
        break;
      case 'news':
        return Colors.redAccent;
        break;
      default:
        return Colors.grey;
        break;
    }
  }

  /// http://xuongann.com/api/flutter/notifications?kind=$kind
  Future<List<InApp>> loadInAppNotification(String kind,
      {page = 1, pageSize = 20}) async {
    try {
      var url;
      if (isNullOrEmpty(kind) || kind == 'all') {
        url = 'flutter/notifications?pageNumber=$page&pageSize=$pageSize';
      } else {
        url =
            'flutter/notifications?kind=$kind&pageNumber=$page&pageSize=$pageSize';
      }
      final response = await AppHttp.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        if (isNullOrEmpty(message)) {
          return [];
        } else {
          List<InApp> _data = new List();
          message.forEach((v) {
            _data.add(new InApp.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      logging.logError('API - Notification', e);
    }
    return null;
  }
}
