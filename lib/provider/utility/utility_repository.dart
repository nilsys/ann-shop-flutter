import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:path/path.dart';

class UtilityRepository {
  static final UtilityRepository instance = UtilityRepository._internal();

  factory UtilityRepository() => instance;

  UtilityRepository._internal() {
    /// init
  }

  List<Cover> cachePolicy;

  Future<List<Cover>> loadPolicy() async {
    if (isNullOrEmpty(cachePolicy) == false) {
      return cachePolicy;
    }
    try {
      final url = 'flutter/post/policies';
      final response = await AppHttp.get(url).timeout(Duration(seconds: 5));

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
      print(e);
    }
    return null;
  }

  Map cacheContact;

  Future<Map> loadContact() async {
    if (cacheContact != null) {
      return cacheContact;
    }
    try {
      final url = 'flutter/shop/contact';
      final response = await AppHttp.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        cacheContact = message;
        return message;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<File> downloadFile(String url) async {
    print(url);
    http.Client _client = new http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/${basename(url)}');
    await file.writeAsBytes(bytes);
    print('File size:${await file.length()}');
    print(file.path);
    return file;
  }
}
