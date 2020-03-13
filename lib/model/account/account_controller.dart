import 'dart:convert';

import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_token.dart';
import 'package:ann_shop_flutter/model/account/no_login_info.dart';

class AccountController {
  static final AccountController instance = AccountController._internal();

  factory AccountController() => instance;

  AccountController._internal() {
    /// init
  }

  Account account;
  AccountToken token;
  NoLoginInfo noLoginInfo;

  bool get isLogin => account != null && token != null;

  bool get canViewProduct {
    if (isLogin) {
      return true;
    }
    if (noLoginInfo.canViewProduct) {
      noLoginInfo.viewProduct++;
      StorageManager.setObject(
          _keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }

  bool get canSearchProduct {
    if (isLogin) {
      return true;
    }
    if (noLoginInfo.canSearchProduct) {
      noLoginInfo.searchProduct++;
      StorageManager.setObject(
          _keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }

  Map<String, String> get header => {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + (token == null ? '' : token.accessToken)
      };

  finishLogin(Map response) {
    account = Account.fromJson(response['user']);
    token = AccountToken.fromJson(response['token']);
    saveToLocale();
  }

  void logout() {
    account = null;
    token = null;
    saveToLocale();
  }

  final _keyAccount = '_keyAccount';
  final _keyToken = '_keyToken';
  final _keyNoLoginInfo = '_keyNoLoginInfo';

  loginLater() async {
    var response = await StorageManager.getObjectByKey(_keyNoLoginInfo);

    try {
      noLoginInfo = NoLoginInfo.fromJson(jsonDecode(response));
    } catch (e) {}
    if (noLoginInfo == null) {
      noLoginInfo = NoLoginInfo();
    }
    logout();
  }

  updateAccountInfo(Account _account) {
    this.account = _account;
    saveToLocale();
  }

  loadFormLocale() async {
    try {
      var response = await StorageManager.getObjectByKey(_keyAccount);
      if (response != null) {
        account = Account.fromJson(jsonDecode(response));
      }
      response = await StorageManager.getObjectByKey(_keyToken);
      if (response != null) {
        token = AccountToken.fromJson(jsonDecode(response));
      }
    } catch (e) {
      print(e);
    }
  }

  saveToLocale() {
    if (account == null) {
      StorageManager.clearObjectByKey(_keyAccount);
      StorageManager.clearObjectByKey(_keyToken);
    } else {
      StorageManager.setObject(_keyAccount, json.encode(account.toJson()));
      StorageManager.setObject(_keyToken, json.encode(token.toJson()));
      StorageManager.clearObjectByKey(_keyNoLoginInfo);
      noLoginInfo = null;
    }
  }
}
