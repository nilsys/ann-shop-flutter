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

  Map get header => {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + (token ==null?'':token.accessToken)
  };

  finishLogin(Map response){
    account = Account.fromJson(response['user']);
    token = AccountToken.fromJson(response['token']);
  }

  logout(){
    account = null;
    token = null;
  }

  updateAccountInfo(){

  }
}
