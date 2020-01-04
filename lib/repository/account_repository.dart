import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:http/http.dart' as http;

class AccountRepository {
  static final AccountRepository instance = AccountRepository._internal();

  factory AccountRepository() => instance;

  AccountRepository._internal() {
    // todo
  }

  Future<AppResponse> requestOTP(String phone, String otp) async {
    try {
      Map data = {"phone": phone, "otp": otp};
      final url = 'http://xuongann.com/api/sms/otp';
      final response = await http.post(url, body: data);
      log(url);
      log(data);
      log(response.statusCode);
      log(response.body);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        return AppResponse(true);
      } else {
        var parsed = jsonDecode(response.body);
        return AppResponse(false, message: parsed['Message']);
      }
    } catch (e) {
      print('Server Exception!!!' + e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> register(String phone, String password) async {
    try {
      Map data = {"phone": phone, "password": password};
      String url = 'http://xuongann.com/api/flutter/user/register';
      final response = await http
          .post(
            url,
            body: data,
          )
          .timeout(Duration(seconds: 10));

      log(url);
      log(data);
      log(response.statusCode);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        var parsed = jsonDecode(response.body);
        return AppResponse(false, message: parsed['Message']);
      }
    } catch (e) {}
    return AppResponse(false);
  }

  Future<AppResponse> login(String phone, String password) async {
    try {
      Map data = {"phone": phone, "password": password};
      String url = 'http://xuongann.com/api/flutter/user/login';
      final response = await http
          .post(
            url,
            body: data,
          )
          .timeout(Duration(seconds: 10));
      log(url);
      log(data.toString());
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        var parsed = jsonDecode(response.body);
        return AppResponse(false, message: parsed['Message']);
      }
    } catch (e) {}
    return AppResponse(false);
  }

  Future<AppResponse> updateInformation(Account account) async {
    try {
      final url = 'http://xuongann.com/api/flutter/user/update-info';
      final response = await http.post(
        url,
        body: account.toJson(),
        headers: AccountController.instance.header,
      );
      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        var parsed = jsonDecode(response.body);
        return AppResponse(false, message: parsed['Message']);
      }
    } catch (e) {
      print(e.toString());
    }
    return AppResponse(false);
  }

  Future<AppResponse> forgotPassword(String phone) async {
    try {
      Map data = {
        "phone": phone,
      };
      String url = 'http://xuongann.com/api/flutter/user/password-new';
      final response =
          await http.patch(url, body: data).timeout(Duration(seconds: 10));

      log(url);
      log(data);
      log(response.statusCode);
      log(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed['password']);
      } else {
        var parsed = jsonDecode(response.body);
        return AppResponse(false, message: parsed['Message']);
      }
    } catch (e) {}
    return AppResponse(false);
  }

  Future<AppResponse> changePassword(String newPassword) async {
    try {
      Map data = {
        "phone": AccountController.instance.account.phone,
        "password": newPassword
      };
      String url = 'http://xuongann.com/api/flutter/user/change-password';
      final response = await http
          .post(
            url,
            body: data,
            headers: AccountController.instance.header,
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        var parsed = jsonDecode(response.body);
        return AppResponse(false, message: parsed['Message']);
      }
    } catch (e) {}
    return AppResponse(false);
  }

  log(object) {
    print('account_repository: ' + object.toString());
  }
}
