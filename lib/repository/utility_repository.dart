import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:http/http.dart' as http;

class UtilityRepository {
  static final UtilityRepository instance = UtilityRepository._internal();

  factory UtilityRepository() => instance;

  UtilityRepository._internal() {
    /// init
  }

  log(object) {
    print('utility_repository: ' + object.toString());
  }

  List<Cover> cachePolicy;

  Future<List<Cover>> loadPolicy() async {
    if (Utility.isNullOrEmpty(cachePolicy) == false) {
      return cachePolicy;
    }
    try {
      final url = '${Core.domain}api/flutter/post/policies';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        List<Cover> _data = new List();
        message.forEach((v) {
          _data.add(new Cover.fromJson(v));
        });
        cachePolicy = _data;
        return _data;
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  Map cacheContact;

  Future<Map> loadContact() async {
    if (cacheContact != null) {
      return cacheContact;
    }
    try {
      final url = '${Core.domain}api/flutter/shop/contact';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(Duration(seconds: 5));
      log(url);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        cacheContact = message;
        return message;
      }
    } catch (e) {
      log(e);
    }
    return null;
  }
}
