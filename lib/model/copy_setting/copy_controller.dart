import 'dart:convert';
import 'package:ann_shop_flutter/model/copy_setting/copy_setting.dart';
import 'package:ping9/ping9.dart';

class CopyController {
  static final CopyController instance = CopyController._internal();

  factory CopyController() => instance;

  CopyController._internal() {
    /// init
    copySetting = CopySetting();
  }

  CopySetting copySetting;
  final _keyCopySetting = '_keyCopySetting';

  updateCopySetting(_value) {
    copySetting = _value;
    saveCopySetting();
  }

  loadCopySetting() async {
    try {
      var response =
          await UserDefaults.instance.getObjectByKey(_keyCopySetting);
      if (response == null) {
        copySetting = CopySetting();
      } else {
        var json = jsonDecode(response);
        copySetting = CopySetting.fromJson(json);
      }
    } catch (e) {
      print(e);
      copySetting = CopySetting();
    }
    saveCopySetting();
  }

  saveCopySetting() {
    var myJsonString = jsonEncode(copySetting.toJson());
    UserDefaults.instance.setObject(_keyCopySetting, myJsonString);
  }
}
