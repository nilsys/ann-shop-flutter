import 'dart:convert';

import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_token.dart';

class AccountController {
  static final AccountController instance = AccountController._internal();

  factory AccountController() => instance;

  AccountController._internal() {
    /// init
  }

  Account account;
  AccountToken token;

  bool get isLogin => account != null && token != null;

  Map<String, String> get header => {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + (token == null ? '' : token.accessToken)
      };

  finishLogin(Map response) {
    account = Account.fromJson(response['user']);
    token = AccountToken.fromJson(response['token']);
    saveToLocale();
  }

  logout() {
    account = null;
    token = null;
    saveToLocale();
  }

  final _keyAccount = '_keyAccount';
  final _keyToken = '_keyToken';

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
      if (isLogin) {
        print('Load account form locale');
        print(account.toJson());
        print(token.toJson());
      }
    } catch (e) {
      print('account_controller: ' + e.toString());
    }
  }

  saveToLocale() {
    if (account == null) {
      StorageManager.clearObjectByKey(_keyAccount);
      StorageManager.clearObjectByKey(_keyToken);
    } else {
      StorageManager.setObject(_keyAccount, json.encode(account.toJson()));
      StorageManager.setObject(_keyToken, json.encode(token.toJson()));
    }
  }
}
