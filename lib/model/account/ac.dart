import 'dart:convert';

import 'package:ann_shop_flutter/service/app_onesignal.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_token.dart';
import 'package:ann_shop_flutter/model/account/no_login_info.dart';
import 'package:ping9/ping9.dart';
export 'ac_restrict.dart';

// constant
final _keyAccount = '_keyAccount';
final _keyToken = '_keyToken';
final _keyNoLoginInfo = '_keyNoLoginInfo';

class AC {
  static final AC instance = AC._internal();

  factory AC() => instance;

  AC._internal() {
    initRestrict();
  }

  Account account;
  AccountToken token;
  NoLoginInfo noLoginInfo;
  NoLoginConfig noLoginConfig;

  bool get isLogin => token != null;

  finishLogin(Map response, String password) {
    account = Account.fromJson(response['user']);
    account.password = password;
    UserDefaults.instance
        .setObject(_keyAccount, jsonEncode(account.toJson()));
    token = AccountToken.fromJson(response['token']);
    UserDefaults.instance.setObject(_keyToken, jsonEncode(token.toJson()));
    AppHttp.setTokenApi(token?.type, token?.accessToken);
    AppOneSignal.instance.sendTagsUserInfo();
  }

  void clearToken() {
    token = null;
    AppHttp.setTokenApi(token?.type, token?.accessToken);
    UserDefaults.instance.clearObjectByKey(_keyToken);
    AppOneSignal.instance.sendTagsUserInfo();
  }

  updateAccountInfo(Account _account) {
    this.account = _account;
    UserDefaults.instance
        .setObject(_keyAccount, jsonEncode(account.toJson()));
    AppOneSignal.instance.sendTagsUserInfo();
  }

  loadFormLocale() async {
    try {
      var userResponse =
          await UserDefaults.instance.getObjectByKey(_keyAccount);
      if (userResponse != null) {
        account = Account.fromJson(jsonDecode(userResponse));
      }
      var tokenResponse =
          await UserDefaults.instance.getObjectByKey(_keyToken);
      if (tokenResponse != null) {
        token = AccountToken.fromJson(jsonDecode(tokenResponse));
      }
    } catch (e) {
      print(e);
    }
    if (account == null || token?.accessToken == null) {
      clearToken();
    } else {
      AppHttp.setTokenApi(token?.type, token?.accessToken);
    }
  }

  Future initRestrict() async {
    noLoginConfig = NoLoginConfig();
    final objectJson =
        await UserDefaults.instance.getObjectByKey(_keyNoLoginInfo);
    try {
      if (objectJson != null) {
        noLoginInfo = NoLoginInfo.fromJson(jsonDecode(objectJson));
      }
    } catch (e) {
      printTrack(e);
    }
    if (noLoginInfo == null) {
      noLoginInfo = NoLoginInfo();
    }
    saveRestrict();
  }

  void saveRestrict() {
    UserDefaults.instance
        .setObject(_keyNoLoginInfo, jsonEncode(noLoginInfo.toJson()));
  }
}
