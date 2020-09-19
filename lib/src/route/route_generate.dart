import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/custom_fade_roue.dart';
import 'package:ann_shop_flutter/src/pages/blogs/blog_page.dart';
import 'package:ann_shop_flutter/src/pages/roots/notification_page.dart';
import 'package:ann_shop_flutter/src/pages/roots/root_page.dart';
import 'package:ann_shop_flutter/src/pages/roots/search_page.dart';
import 'package:ann_shop_flutter/src/pages/share/share_page.dart';
import 'package:ann_shop_flutter/src/widgets/view_page/view_more_page.dart';
import 'package:ann_shop_flutter/view/account/order_management_view.dart';
import 'package:ann_shop_flutter/view/account/setting_view.dart';
import 'package:ann_shop_flutter/view/account/shop_contact.dart';
import 'package:ann_shop_flutter/view/account/shop_policy.dart';
import 'package:ann_shop_flutter/view/account/update_information.dart';
import 'package:ann_shop_flutter/view/coupon/promotion_view.dart';
import 'package:ann_shop_flutter/view/favorite/favorite_view.dart';
import 'package:ann_shop_flutter/view/list_product/list_product_by_category.dart';
import 'package:ann_shop_flutter/view/list_product/seen_view.dart';
import 'package:ann_shop_flutter/view/login/forgot_password_view.dart';
import 'package:ann_shop_flutter/view/login/login_password_view.dart';
import 'package:ann_shop_flutter/view/login/login_view.dart';
import 'package:ann_shop_flutter/view/login/register_input_otp_view.dart';
import 'package:ann_shop_flutter/view/login/register_input_password_view.dart';
import 'package:ann_shop_flutter/view/product/image_view.dart';
import 'package:ann_shop_flutter/view/product/product_detail_view.dart';
import 'package:ann_shop_flutter/view/product/product_filter_view.dart';
import 'package:ann_shop_flutter/view/product/product_image_by_size_and_color.dart';
import 'package:ann_shop_flutter/view/product/product_image_fancy_view.dart';
import 'package:ann_shop_flutter/view/scan_barcode/scan_view.dart';
import 'package:ann_shop_flutter/view/utility/init_view.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';
import 'package:quiver/strings.dart';

class RouteGenerate {
  // main route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (isEmpty(settings.name) || settings.name == '/')
      return MaterialPageRoute(builder: (_) => InitView(), settings: settings);

    var route = settings.name.split('/').first;

    switch (route) {
      case 'home':
        return CustomFadeRoute(builder: (_) => RootPage(), settings: settings);
      case 'product':
        return _routeProduct(settings);
      case 'search':
        return _routeSearch(settings);
      case 'notification':
        return MaterialPageRoute(
            builder: (_) => NotificationPage(), settings: settings);
      case 'user':
        return _routeUser(settings);
      case 'shop':
        return _routeShop(settings);
      case 'blog':
        return CustomFadeRoute(builder: (_) => BlogPage(), settings: settings);
      case 'page':
        return _routePage(settings);
      default:
        return _routeNotFound();
    }
  }

  // region route product
  static Route<dynamic> _routeProduct(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^product/?'), '');
    var route = url.split('/').first;
    var data = settings.arguments;

    switch (route) {
      case '':
        return CustomFadeRoute(
            builder: (_) => ListProductByCategory(data), settings: settings);
      case 'filter':
        return MaterialPageRoute(
            builder: (_) => ProductFilterView(data), settings: settings);
      case 'detail':
        return _routeProductDetail(settings);
      default:
        return _routeNotFound();
    }
  }

  // route product detail
  static Route<dynamic> _routeProductDetail(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^product/detail/?'), '');
    var route = url.split('/').first;
    var data = settings.arguments;

    switch (route) {
      case '':
        return CustomFadeRoute(
            builder: (_) => ProductDetailView(slug: data), settings: settings);
      case 'image':
        return CustomFadeRoute(
            builder: (_) => ImageView(data), settings: settings);
      case 'fancy-image':
        return CustomFadeRoute(
            builder: (_) => ProductImageFancyView(data), settings: settings);
      case 'select-size-color':
        return CustomFadeRoute(
            builder: (_) => ProductImageBySizeAndColor(data),
            settings: settings);
      case 'share-social':
        return CustomFadeRoute(
            builder: (_) => SharePage(data), settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // Route Search
  static Route<dynamic> _routeSearch(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^search/?'), '');
    var route = url.split('/').first;

    switch (route) {
      case '':
        return MaterialPageRoute(
            builder: (_) => SearchPage(), settings: settings);
      case 'scan':
        return CustomFadeRoute(builder: (_) => ScanView(), settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // region route user
  static Route<dynamic> _routeUser(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^user/?'), '');
    var route = url.split('/').first;
    var data = settings.arguments;

    switch (route) {
      case '':
        return CustomFadeRoute(
            builder: (_) => SettingView(), settings: settings);
      case 'information':
        return MaterialPageRoute(
            builder: (_) => UpdateInformation(
                  isRegister: false,
                ),
            settings: settings);
      case 'register':
        return _routeRegisterUser(settings);
      case 'login':
        return _routeLogin(settings);
      case 'forgot_password':
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordView(data), settings: settings);
      case 'otp':
        return MaterialPageRoute(
            builder: (_) => RegisterInputOtpView(), settings: settings);
      case 'order':
        return CustomFadeRoute(
            builder: (_) => OrderManagementView(), settings: settings);
      case 'seen':
        return CustomFadeRoute(builder: (_) => SeenView(), settings: settings);
      case 'favorite':
        return CustomFadeRoute(
            builder: (_) => FavoriteView(), settings: settings);
      case 'promotion':
        return CustomFadeRoute(
            builder: (_) => PromotionView(), settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // route register user
  static Route<dynamic> _routeRegisterUser(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^user/register/?'), '');
    var route = url.split('/').first;

    switch (route) {
      case 'password':
        return MaterialPageRoute(
            builder: (_) => RegisterInputPasswordView(), settings: settings);
      case 'information':
        return MaterialPageRoute(
            builder: (_) => UpdateInformation(
                  isRegister: true,
                ),
            settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // route login
  static Route<dynamic> _routeLogin(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^user/login/?'), '');
    var route = url.split('/').first;
    var data = settings.arguments;

    switch (route) {
      case '':
        return MaterialPageRoute(
            builder: (_) => LoginView(), settings: settings);
      case 'password':
        return MaterialPageRoute(
            builder: (_) => LoginPasswordView(data), settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // route shop
  static Route<dynamic> _routeShop(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^shop/?'), '');
    var route = url.split('/').first;

    switch (route) {
      case 'contact':
        return CustomFadeRoute(
            builder: (_) => ShopContact(), settings: settings);
      case 'policy':
        return CustomFadeRoute(
            builder: (_) => ShopPolicy(), settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // route page
  static Route<dynamic> _routePage(RouteSettings settings) {
    var url = settings.name.replaceFirst(RegExp('^page/?'), '');
    var route = url.split('/').first;
    var data = settings.arguments;

    switch (route) {
      case 'browser':
        final queryParameters = WebViewQueryParameterModel.fromJson(data);
        return CustomFadeRoute(
            builder: (_) => WebViewRouter(queryParameters: queryParameters),
            settings: settings);
      case 'html':
        return CustomFadeRoute(
            builder: (_) => ViewMorePage(data), settings: settings);
      default:
        return _routeNotFound();
    }
  }

  // route not found
  static Route<dynamic> _routeNotFound() {
    return MaterialPageRoute(
        builder: (_) => NotFoundPage(title: Core.appFullName));
  }
}
