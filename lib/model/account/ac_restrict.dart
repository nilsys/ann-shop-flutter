import 'package:ping9/ping9.dart';
import 'dart:convert';
import 'ac.dart';

final _keyNoLoginInfo = '_keyNoLoginInfo';

extension ACRestrict on AC {
  bool get canViewProduct {
    if (isLogin || noLoginConfig.maxViewProduct < 0) {
      return true;
    }
    if (noLoginInfo.viewProduct < noLoginConfig.maxViewProduct) {
      noLoginInfo.viewProduct++;
      StorageManager.instance
          .setObject(_keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }

  bool get canSearchProduct {
    if (isLogin || noLoginConfig.maxSearchProduct < 0) {
      return true;
    }
    if (noLoginInfo.searchProduct < noLoginConfig.maxSearchProduct) {
      noLoginInfo.searchProduct++;
      StorageManager.instance
          .setObject(_keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }

  bool get canViewBlog {
    if (isLogin || noLoginConfig.maxViewBloc < 0) {
      return true;
    }
    if (noLoginInfo.viewBloc < noLoginConfig.maxViewBloc) {
      noLoginInfo.viewBloc++;
      StorageManager.instance
          .setObject(_keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }
}
