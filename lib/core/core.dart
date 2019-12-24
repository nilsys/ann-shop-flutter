import 'dart:convert';

import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/utility/copy_setting.dart';

final double defaultPadding = 15;
final int itemPerPage = 30;

class Core {
  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    /// init
  }

  static const appVersion = '1.0.0';

  static const domain = 'http://xuongann.com/';

  static bool get isLogin => false;


  static CopySetting copySetting = CopySetting();
  static const _keyCopySetting = '_keyCopySetting';

  static updateCopySetting(_value) {
    copySetting = _value;
    saveCopySetting();
  }

  static loadCopySetting() async {
    try {
      print('loadCopySetting');
      var response = await StorageManager.getObjectByKey(_keyCopySetting);
      if (response == null) {
        copySetting = CopySetting();
      } else {
        print('loadCopySetting: ' + response);
        var json = jsonDecode(response);
        copySetting = CopySetting.fromJson(json);
      }
    } catch (e) {
      print('loadCopySetting Exception: ' + e.toString());
      copySetting = CopySetting();
    }
    saveCopySetting();
  }

  static saveCopySetting() {
    var myJsonString = json.encode(copySetting.toJson());
    StorageManager.setObject(_keyCopySetting, myJsonString);
  }
}
