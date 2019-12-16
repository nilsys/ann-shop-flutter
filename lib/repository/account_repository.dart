import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/model/acount/account.dart';
import 'package:http/http.dart' as http;

class AccountRepository {
  static final AccountRepository instance = AccountRepository._internal();

  factory AccountRepository() => instance;

  AccountRepository._internal() {
    // todo
  }

  requestOTP(Object data) async {
    try {
      final url = '';
      final response = await http.post(url, body: data);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } catch (e) {
      print('Server Exception!!!' + e);
    }
    return false;
  }

  validateOTP(Object data) async {
    try {
      final url = '';
      final response = await http.post(url, body: data);
      if (response.statusCode == HttpStatus.ok) {
        final parsed = json.decode(response.body);
        var status = parsed['status'];
        if (status == 'success') {
          var user = Account.fromJson(parsed['data']);
          return {'status': status, 'data': user};
        } else if (status == 'wrong_otp') {
          return {'status': 'OTP không chính xác', 'data': null};
        } else if (status == 'otp_expired') {
          return {'status': 'OTP đã hết hạn', 'data': null};
        }
      }
    } catch (e) {
      print('validateOTP' + e.toString());
    }
    return {'status': 'Có lỗi xãi ra', 'data': null};
  }

  updateInformation(Object data) async {
    try {
      final url = '';
      final response = await http.post(url, body: data);
      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        if (parsed['status'] == 'success') {
          return true;
        }
      }
    } catch (e) {
      print('updateInformation: ' + e.toString());
    }
    return false;
  }
}
