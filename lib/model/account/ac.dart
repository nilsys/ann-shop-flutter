import 'dart:convert';

import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_token.dart';
import 'package:ann_shop_flutter/model/account/no_login_info.dart';
import 'package:ping9/ping9.dart';
export 'ac_restrict.dart';

// constant
final _keyAccount = '_keyAccount';
final _keyToken = '_keyToken';

class AC {
  static final AC instance = AC._internal();

  factory AC() => instance;

  AC._internal();

  Account account;
  AccountToken token;
  NoLoginInfo noLoginInfo;
  NoLoginConfig noLoginConfig = NoLoginConfig();

  bool get isLogin => token != null;

  finishLogin(Map response, String password) {
    account = Account.fromJson(response['user']);
    account.password = password;
    StorageManager.instance
        .setObject(_keyAccount, json.encode(account.toJson()));
    token = AccountToken.fromJson(response['token']);
    StorageManager.instance.setObject(_keyToken, json.encode(token.toJson()));
    AppHttp.setTokenApi(token?.accessToken);

  }

  void clearToken() {
    token = null;
    AppHttp.setTokenApi(token?.accessToken);
    StorageManager.instance.clearObjectByKey(_keyToken);
  }

  updateAccountInfo(Account _account) {
    this.account = _account;
    StorageManager.instance
        .setObject(_keyAccount, json.encode(account.toJson()));
  }

  loadFormLocale() async {
    try {
      var userResponse =
          await StorageManager.instance.getObjectByKey(_keyAccount);
      if (userResponse != null) {
        account = Account.fromJson(jsonDecode(userResponse));
      }
      var tokenResponse =
      await StorageManager.instance.getObjectByKey(_keyToken);
      if (tokenResponse != null) {
        token = AccountToken.fromJson(jsonDecode(tokenResponse));
      }
    } catch (e) {
      print(e);
    }
    if(account == null || token?.accessToken == null){
      clearToken();
    }else{
      AppHttp.setTokenApi(token?.accessToken);
    }
  }
}
