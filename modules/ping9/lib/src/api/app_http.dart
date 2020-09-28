import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stack_trace/stack_trace.dart';

class AppHttp {
  static String tokenType;
  static String tokenApi;
  static Map<String, String> get _headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "$tokenType $tokenApi"
      };

  static void setTokenApi(String tokenType, String tokenApi) {
    AppHttp.tokenType = tokenType;
    AppHttp.tokenApi = tokenApi;
  }

  static const domain = 'http://backend.xuongann.com/api/';

  static Future<http.Response> get(String url) async {
    try {
      final response = await http
          .get(domain + url, headers: _headers)
          .timeout(const Duration(minutes: 5));
      // log(_headers.toString());
      log('> GET RESPONSE [${response.statusCode}]<  $domain$url');
      // log(response.body);
      return response;
    } catch (e) {
      log('> API CATCH < $e');
      rethrow;
    }
  }

  //jsonEncode body first
  static Future<http.Response> post(String url, {String body}) async {
    try {
      final response = await http
          .post(domain + url, body: body, headers: _headers)
          .timeout(const Duration(minutes: 5));
      log('> POST RESPONSE [${response.statusCode}]< $domain$url');
      // log(body);
      // log(response.body);
      return response;
    } catch (e) {
      log('> API CATCH < $e');
      rethrow;
    }
  }

  static Future<http.Response> patch(String url, {String body}) async {
    try {
      final response = await http
          .patch(domain + url, body: body, headers: _headers)
          .timeout(const Duration(minutes: 5));
      log('> PATCH RESPONSE [${response.statusCode}]< $domain$url');
      // log(body);
      // log(response.body);
      return response;
    } catch (e) {
      log('> API CATCH < $e');
      rethrow;
    }
  }

  static void log(Object object) {
    final output = "${Trace.current().frames[2].location} | $object";
    final pattern = RegExp('.{1,1000}');
    pattern.allMatches(output).forEach((match) => debugPrint(match.group(0)));
  }
}
