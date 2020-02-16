import 'package:ann_shop_flutter/core/router.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppAction {

  factory AppAction() => instance;
  AppAction._internal() {
    alreadySpam = false;
  }
  static final AppAction instance = AppAction._internal();

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
    final _action = action.trim().toLowerCase();
    final _value = value.trim();
    switch (action) {
      case ActionType.linkToCategory:
        linkToCategory(context, _value, message);
        break;
      case ActionType.linkToTag:
        linkToTag(context, _value, message);
        break;
      case ActionType.linkToProduct:
        linkToProductDetail(context, _value);
        break;
      case ActionType.linkToScreen:
        linkToScreen(context, _value, message);
        break;
      case ActionType.linkToWebView:
        linkToWebView(context, _value, message);
        break;
      case ActionType.linkToBrowser:
        linkToWebPage(context, _value);
        break;
      case ActionType.linkToViewMore:
        linkToViewMore(context, _value);
        break;
      default:
        debugPrint("Action don't exist: $_action");
        break;
    }
  }

  void linkToProductDetail(BuildContext context, String value) {
    debugPrint('link to product detail: $value');
    Router.showProductDetail(context, slug: value);
  }

  void linkToCategory(BuildContext context, String value, String message) {
    debugPrint('link to product by category: $value');
    ListProduct.showByCategory(context,
        Category(name: message, filter: ProductFilter(categorySlug: value)));
  }

  void linkToTag(BuildContext context, String value, String message) {
    debugPrint('link to tag: $value');
    ListProduct.showByCategory(context,
        Category(name: message, filter: ProductFilter(tagSlug: value)));
  }

  void linkToSearch(BuildContext context, String value, String message) {
    debugPrint('link to search: $value');
    ListProduct.showBySearch(
      context,
      Category(
        name: value,
        filter: ProductFilter(productSearch: value),
      ),
    );
  }

  void linkToWebPage(BuildContext context, String value) {
    debugPrint('link to web page: $value');
    launch(value);
  }

  void linkToWebView(BuildContext context, String value, String message) {
    debugPrint('link to web page: $value');
    Navigator.pushNamed(context, '/web-view',
        arguments: {'url': value, 'title': message});
  }

  void linkToScreen(BuildContext context, String value, String message) {
    debugPrint('link to scrren: $value');
    var index = -1;
    switch (value) {
      case 'home':
        index = PageName.home.index;
        break;
      case 'category':
        index = PageName.category.index;
        break;
      case 'search':
        index = PageName.search.index;
        break;
      case 'inapp':
        index = PageName.notification.index;
        break;
      case 'account':
        index = PageName.account.index;
        break;
      default:
        Navigator.pushNamed(context, '/$value', arguments: message);
        return;
        break;
    }
    if (index >= 0) {
      Provider.of<NavigationProvider>(context, listen: false).switchTo(index);
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    }
  }

  void linkToViewMore(BuildContext context, String value) {
    debugPrint('link to view more: $value');
    Navigator.pushNamed(context, '/view_more', arguments: value);
  }
}

class ActionType {
  static const String linkToProduct = "product";
  static const String linkToCategory = "category";
  static const String linkToTag = "product_tag";
  static const String linkToSearch = "product_search";
  static const String linkToBrowser = "open_browser";
  static const String linkToWebView = "show_web";
  static const String linkToScreen = "go_to_screen";
  static const String linkToViewMore = "view_more";
}
