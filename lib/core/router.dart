import 'package:ann_shop_flutter/view/product/product_detail_view.dart';
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
            builder: (_) => ProductDetailView(product: data,), settings: settings);
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
