import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppAction {
  static final AppAction instance = AppAction._internal();

  factory AppAction() => instance;

  AppAction._internal() {
    alreadySpam = false;
  }

  bool alreadySpam;

  void onHandleActionInit(
      BuildContext context, String action, String value, String message) {
    if (alreadySpam == false) {
      alreadySpam = true;
      onHandleAction(context, action, value, message);
    }
  }

  void onHandleAction(
      BuildContext context, String action, String value, String message) {
    action = action.trim().toLowerCase();
    value = value.trim();
    switch (action) {
      case ActionType.linkToCategory:
        linkToCategory(context, value, message);
        break;
      case ActionType.linkToProduct:
        linkToProductDetail(context, value, message);
        break;
      case ActionType.linkToScreen:
        linkToScreen(context, value, message);
        break;
      case ActionType.linkToWebPage:
        linkToWebPage(context, value, message);
        break;
      case ActionType.linkToWebView:
        linkToWebView(context, value, message);
        break;
      case ActionType.openPopup:
        linkToPopup(context, value, message);
        break;
      default:
        print("Type don't exist");
        break;
    }
  }

  void linkToProductDetail(
      BuildContext context, String value, String message) async {
    print('link to product detail: $value');
    Navigator.pushNamed(context, '/product-detail', arguments: value);
  }

  void linkToCategory(
      BuildContext context, String value, String message) async {
    print('link to product by category: $value');
    ListProduct.showByCategory(context, Category(name: message, slug: value));
  }

  void linkToWebPage(BuildContext context, String value, String message) {
    print('link to web page: $value');
    launch(value);
  }

  void linkToPopup(BuildContext context, String value, String message) {
    print('link to popup');
    AppPopup.showCustomDialog(context,
        title: value, btnNormal: ButtonData(title: 'Close'));
  }

  void linkToWebView(BuildContext context, String value, String message) async {
    print('link to web view' + value);
    Navigator.pushNamed(context, '/web-view');
  }

  void linkToScreen(BuildContext context, String value, String message) {
    print('link to scrren' + value);
    Navigator.pushNamed(context, '/$value');
  }
}

class ActionType {
  static const String linkToProduct = "product";
  static const String linkToCategory = "category";
  static const String linkToWebPage = "webpage";
  static const String linkToWebView = "webview";
  static const String openPopup = "openpopup";
  static const String linkToScreen = "screen";
}
