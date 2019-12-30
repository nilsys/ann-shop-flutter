import 'package:ann_shop_flutter/core/router.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      case ActionType.linkToViewMore:
        linkToViewMore(context, value, message);
        break;
      default:
        print("Type don't exist: $action");
        break;
    }
  }

  void linkToProductDetail(
      BuildContext context, String value, String message) async {
    print('link to product detail: $value');
    Router.showProductDetail(context, slug: value);
  }

  void linkToCategory(
      BuildContext context, String value, String message) async {
    print('link to product by category: $value');
    ListProduct.showByCategory(context,
        Category(name: message, filter: ProductFilter(categorySlug: value)));
  }

  void linkToTag(BuildContext context, String value, String message) {
    print('link to tag: ' + value);
    ListProduct.showByTag(context, ProductTag(name: message, slug: value));
  }

  void linkToSearch(BuildContext context, String value, String message) {
    print('link to search: ' + value);
    ListProduct.showBySearch(
      context,
      Category(
        name: value,
        filter: ProductFilter(productSearch: value),
      ),
    );
  }

  void linkToWebPage(BuildContext context, String value, String message) {
    print('link to web page: $value');
    launch(value);
  }

  void linkToScreen(BuildContext context, String value, String message) {
    print('link to scrren: ' + value);
    int index = -1;
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
      Provider.of<NavigationProvider>(context).switchTo(index);
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  void linkToViewMore(BuildContext context, String value, String message) {
    print('link to view more: ' + value);
    Navigator.pushNamed(context, '/view_more', arguments: value);
  }
}

class ActionType {
  static const String linkToProduct = "product";
  static const String linkToCategory = "category";
  static const String linkToTag = "product_tag";
  static const String linkToSearch = "product_search";
  static const String linkToWebPage = "show_web";
  static const String linkToScreen = "go_to_screen";
  static const String linkToViewMore = "view_more";
}
