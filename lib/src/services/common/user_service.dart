import 'dart:convert';

import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/src/services/ann_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiver/strings.dart';

class UserService extends ANNService {
  // region Singleton Pattern
  static final _instance = UserService._internal();

  // endregion

  // region Parameters
  AccountController _accController;

  // endregion

  // region Getter
  static UserService get instance => _instance;

  // endregion

  UserService._internal() {
    _accController = AccountController.instance;
  }

  factory UserService() => instance;

  Future<dynamic> refreshToken(BuildContext context) async {
    final _keyAccount = '_keyAccount';
    Account account;

    var userResponse = await StorageManager.getObjectByKey(_keyAccount);
    if (userResponse == null)
      return Navigator.pushNamedAndRemoveUntil(
          context, 'user/login', (Route<dynamic> route) => false);

    account = Account.fromJson(jsonDecode(userResponse));

    if (isEmpty(account.phone) || isEmpty(account.password))
      return Navigator.pushNamedAndRemoveUntil(
          context, 'user/login', (Route<dynamic> route) => false);

    var loginResponse =
        await AccountRepository.instance.login(account.phone, account.password);

    if (loginResponse.status)
      _accController.finishLogin(loginResponse.data, account.password);
    else
      return Navigator.pushNamedAndRemoveUntil(
          context, 'user/login', (Route<dynamic> route) => false);
  }
}
