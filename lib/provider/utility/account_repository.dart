import 'dart:convert';
import 'dart:io';

import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/provider/utility/app_response.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:ping9/ping9.dart';

class AccountRepository {
  static final AccountRepository instance = AccountRepository._internal();

  factory AccountRepository() => instance;

  AccountRepository._internal() {
    // todo
  }

  Future<AppResponse> checkPhoneNumber(String phone) async {
    try {
      final url = '${AppHttp.domain}flutter/user/check?phone=$phone';
      final response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        Map parsed = jsonDecode(response.body);
        var result = parsed['exists'];
        return AppResponse(true, data: result);
      } else {
        return AppResponse(false);
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> registerStep2RequestOTP(String phone, String otp) async {
    try {
      var url = '${AppHttp.domain}sms/otp';
      var headers = {"Content-type": "application/json"};
      var formatPhone = '84' + phone.substring(1);
      var data = {"phone": formatPhone, "otp": otp};
      final response =
          await http.post(url, headers: headers, body: jsonEncode(data));

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> registerStep3ValidateOTP(String phone, String otp) async {
    try {
      var url = '${AppHttp.domain}flutter/user/confirm-otp';
      var headers = {"Content-type": "application/json"};
      var data = {"phone": phone, "otp": otp};
      final response =
          await http.post(url, headers: headers, body: jsonEncode(data));

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> registerStep4CreatePassword(
      String phone, String otp, String password) async {
    try {
      //#region Get Device Info
      AndroidDeviceInfo androidInfo;
      IosDeviceInfo iosInfo;

      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid)
        androidInfo = await deviceInfo.androidInfo;
      else
        iosInfo = await deviceInfo.iosInfo;
      //#endregion

      var url = '${AppHttp.domain}flutter/user/create-password';
      var headers = {"Content-type": "application/json"};
      var data = {
        "phone": phone,
        "otp": otp,
        "passwordNew": password,
        "device": Platform.isAndroid ? androidInfo.model : iosInfo.model
      };
      final response = await http
          .post(url, headers: headers, body: jsonEncode(data))
          .timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> login(String phone, String password) async {
    try {
      //#region Get Device Info
      AndroidDeviceInfo androidInfo;
      IosDeviceInfo iosInfo;

      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid)
        androidInfo = await deviceInfo.androidInfo;
      else
        iosInfo = await deviceInfo.iosInfo;
      //#endregion

      var url = '${AppHttp.domain}flutter/user/login';
      var headers = {"Content-type": "application/json"};
      var data = {
        "phone": phone,
        "password": password,
        "device": Platform.isAndroid ? androidInfo.model : iosInfo.model
      };
      final response = await http
          .post(url, headers: headers, body: jsonEncode(data))
          .timeout(Duration(minutes: 5));
      printTrack(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> updateInformation(Account account) async {
    try {
      var url = 'flutter/user/update-info';
      var data = {
        "phone": account.phone,
        "fullName": account.fullName,
        "birthday": account.birthDay,
        "gender": account.gender,
        "address": account.address,
        "city": account.city
      };
      final response = await AppHttp.patch(url, body: jsonEncode(data))
          .timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> forgotPasswordByBirthDay(
      String phone, String birthDay) async {
    try {
      var headers = {"Content-type": "application/json"};
      var newPass = birthDay.replaceAll('-', '').substring(0, 6);
      var data = {
        "phone": phone,
        "otp": newPass,
        "birthday": birthDay,
      };
      String url = '${AppHttp.domain}flutter/user/password-new-by-birthday';
      final response = await http
          .patch(url, headers: headers, body: jsonEncode(data))
          .timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed['password']);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> changePassword(String newPassword) async {
    try {
      final response = await AppHttp.patch(
              "flutter/user/change-password?newPassword=$newPassword")
          .timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  /*
   * Lấy số điện thoại Zalo để liên hệ khi quên ngày tháng năm sinh.
   */
  Future<AppResponse> getPhoneSupportForgotPassword(String phone) async {
    try {
      final response = await AppHttp.get(
          "flutter/user/phone-support-forgot-password?phone=$phone")
          .timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);

        if (parsed["success"])
          return AppResponse(true, data: parsed['data']);
        else
          return AppResponse(false, data: parsed['message']);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  String getMessage(body) {
    try {
      Map parsed = jsonDecode(body);
      if (parsed.containsKey('message')) {
        return parsed['message'];
      }
      if (parsed.containsKey('ModelState')) {}
    } catch (e) {
      print(e);
    }
    return null;
  }

  final cityOfVietnam = [
    "TP Hồ Chí Minh",
    "An Giang",
    "Bà Rịa – Vũng Tàu",
    "Bắc Giang",
    "Bắc Kạn,",
    "Bạc Liêu",
    "Bắc Ninh",
    "Bến Tre",
    "Bình Định",
    "Bình Dương",
    "Bình Phước",
    "Bình Thuận",
    "Cà Mau",
    "Cần Thơ",
    "Cao Bằng",
    "Đà Nẵng",
    "Đắk Lắk",
    "Đắk Nông",
    "Điện Biên",
    "Đồng Nai",
    "Đồng Tháp",
    "Gia Lai",
    "Hà Giang",
    "Hà Nam",
    "Hà Nội",
    "Hà Tĩnh",
    "Hải Dương",
    "Hải Phòng",
    "Hậu Giang",
    "Hòa Bình",
    "Hưng Yên",
    "Khánh Hòa",
    "Kiên Giang",
    "Kon Tum",
    "Lai Châu",
    "Lâm Đồng",
    "Lạng Sơn",
    "Lào Cai",
    "Long An",
    "Nam Định",
    "Nghệ An",
    "Ninh Bình",
    "Ninh Thuận",
    "Phú Thọ",
    "Phú Yên",
    "Quảng Bình",
    "Quảng Nam",
    "Quảng Ngãi",
    "Quảng Ninh",
    "Quảng Trị",
    "Sóc Trăng",
    "Sơn La",
    "Tây Ninh",
    "Thái Bình",
    "Thái Nguyên",
    "Thanh Hóa",
    "Thừa Thiên Huế",
    "Tiền Giang",
    "Trà Vinh",
    "Tuyên Quang",
    "Vĩnh Long",
    "Vĩnh Phúc",
    "Yên Bái",
  ];
}
