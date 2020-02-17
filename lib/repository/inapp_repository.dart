import 'dart:convert';
import 'dart:io';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InAppRepository {
  static final InAppRepository instance = InAppRepository._internal();

  factory InAppRepository() => instance;

  InAppRepository._internal() {
    /// init
  }

  List<String> categories = ['promotion', 'notification', 'news'];

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
        return Colors.orange;
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
      var url = Core.domain;
      if (Utility.isNullOrEmpty(kind) || kind == 'all') {
        url += 'api/flutter/notifications?pageNumber=$page&pageSize=$pageSize';
      } else {
        url +=
            'api/flutter/notifications?kind=$kind&pageNumber=$page&pageSize=$pageSize';
      }
      final response = await http.get(url,
          headers: AccountController.instance.header).timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        if(Utility.isNullOrEmpty(message)){
          return [];
        }else {
          List<InApp> _data = new List();
          message.forEach((v) {
            _data.add(new InApp.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  Future<Map> loadContentViewMore(String slug) async {
    try {
      final url = '${Core.domain}api/flutter/$slug';
      final response = await http.get(url,
          headers: AccountController.instance.header).timeout(Duration(seconds: 10));
      log(url);
      log(response.body);
      final body = response.body;
      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(body);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  log(object) {
    print('inapp_repository: ' + object.toString());
  }
}
