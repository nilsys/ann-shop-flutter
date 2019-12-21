import 'package:ann_shop_flutter/view/account/add_information.dart';
import 'package:ann_shop_flutter/view/account/login_view.dart';
import 'package:ann_shop_flutter/view/account/notification_view.dart';
import 'package:ann_shop_flutter/view/account/order_management_view.dart';
import 'package:ann_shop_flutter/view/account/setting_view.dart';
import 'package:ann_shop_flutter/view/account/shop_contact.dart';
import 'package:ann_shop_flutter/view/account/shop_policy.dart';
import 'package:ann_shop_flutter/view/favorite/favorite_view.dart';
import 'package:ann_shop_flutter/view/home_view/search_page.dart';
import 'package:ann_shop_flutter/view/list_product/list_product_by_category.dart';
import 'package:ann_shop_flutter/view/list_product/list_product_by_tag.dart';
import 'package:ann_shop_flutter/view/list_product/seen_view.dart';
import 'package:ann_shop_flutter/view/product/product_detail_view.dart';
import 'package:ann_shop_flutter/view/product/product_filter_view.dart';
import 'package:ann_shop_flutter/view/list_product/list_product_by_search.dart';
import 'package:ann_shop_flutter/view/product/product_image_by_size_and_color.dart';
import 'package:ann_shop_flutter/view/product/product_image_fancy_view.dart';
import 'package:ann_shop_flutter/view/utility/empty_view.dart';
import 'package:ann_shop_flutter/view/home_view/home_view.dart';
import 'package:ann_shop_flutter/view/utility/file_view.dart';
import 'package:ann_shop_flutter/view/utility/web_view.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    /// add settings on MaterialPageRoute for which route you want to tracking
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => HomeView(), settings: settings);
      case '/web-view':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => WebViewRouter(data), settings: settings);
      case '/file-view':
        Map data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => FileViewRouter(data['url'], data['name']),
            settings: settings);
      case '/product-detail':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ProductDetailView(info: data), settings: settings);
      case '/product-fancy-image':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ProductImageFancyView(data), settings: settings);
      case '/product-image-by-size-and-image':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ProductImageBySizeAndColor(data), settings: settings);
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
            builder: (_) => ListProductBySearch(data), settings: settings);
      case '/list-product-by-tag':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ListProductByTag(data), settings: settings);
      case '/shop-contact':
        return MaterialPageRoute(
            builder: (_) => ShopContact(), settings: settings);
      case '/shop-policy':
        return MaterialPageRoute(
            builder: (_) => ShopPolicy(), settings: settings);
      case '/login':
        return MaterialPageRoute(
            builder: (_) => LoginView(), settings: settings);
      case '/add-information':
        return MaterialPageRoute(
            builder: (_) => AddInformation(), settings: settings);
      case '/order-management':
        return MaterialPageRoute(
            builder: (_) => OrderManagementView(), settings: settings);
      case '/notification':
        return MaterialPageRoute(
            builder: (_) => NotificationView(), settings: settings);
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
