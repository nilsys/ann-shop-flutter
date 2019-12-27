import 'dart:convert';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class InAppRepository {
  static final InAppRepository instance = InAppRepository._internal();

  factory InAppRepository() => instance;

  InAppRepository._internal() {
    /// init
  }

  IconData getIconInApp(String category) {
    switch (category) {
      case 'all':
        return Icons.home;
        break;
      case 'promotion':
        return Icons.style;
        break;
      case 'notification':
        return Icons.message;
        break;
      case 'news':
        return Icons.restore;
        break;
      default:
        return Icons.ac_unit;
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

  /// http://xuongann.com/api/flutter/home/banners
  Future<List<InApp>> loadInAppNotification() async {
    try {
//      final url = Core.domain + 'api/flutter/home/banners';
//      final response = await http.get(url).timeout(Duration(seconds: 5));
//      log(url);
//      log(response.body);

//    final body = response.body;
      await Future.delayed(Duration(seconds: 2));
      final body = await rootBundle.loadString('assets/offline/inapp.json');

//      if (response.statusCode == HttpStatus.ok) {
      var message = jsonDecode(body);
      List<InApp> _data = new List();
      message.forEach((v) {
        _data.add(new InApp.fromJson(v));
      });
      return _data;
//      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  log(object) {
    print('inapp_repository: ' + object.toString());
  }
}
