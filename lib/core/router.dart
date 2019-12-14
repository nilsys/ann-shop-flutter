import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/view/account/setting_view.dart';
import 'package:ann_shop_flutter/view/favorite/favorite_view.dart';
import 'package:ann_shop_flutter/view/home_view/search_page.dart';
import 'package:ann_shop_flutter/view/list_product/list_product_by_category.dart';
import 'package:ann_shop_flutter/view/list_product/seen_view.dart';
import 'package:ann_shop_flutter/view/product/product_detail_view.dart';
import 'package:ann_shop_flutter/view/product/product_filter_view.dart';
import 'package:ann_shop_flutter/view/search/seach_result_view.dart';
import 'package:ann_shop_flutter/view/utility/empty_view.dart';
import 'package:ann_shop_flutter/view/home_view/home_view.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    /// add settings on MaterialPageRoute for which route you want to tracking
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => HomeView(), settings: settings);
      case '/product-detail':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ProductDetailView(info: data,), settings: settings);
      case '/search':
        return MaterialPageRoute(
            builder: (_) => SearchPage(), settings: settings);
      case '/favorite':
        return MaterialPageRoute(
            builder: (_) => FavoriteView(), settings: settings);
      case '/seen':
        return MaterialPageRoute(
            builder: (_) => SeenView(), settings: settings);
      case '/setting':
        return MaterialPageRoute(
            builder: (_) => SettingView(), settings: settings);
      case '/filter-product':
        return MaterialPageRoute(
            builder: (_) => ProductFilterView(), settings: settings);
      case '/list-product-by-category':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ListProductByCategory(data), settings: settings);
      case '/list-product-by-search':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SearchResultView(data), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (_) => EmptyView(title: settings.name));
    }
  }

  static String getNameExtractor(RouteSettings settings) {
    /// User for override route's name
    switch (settings.name) {
      case '/':
        return null;
      default:
        return settings.name;
    }
  }
}
