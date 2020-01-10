import 'package:ann_shop_flutter/core/custom_fade_roue.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/view/account/update_information.dart';
import 'package:ann_shop_flutter/view/login/change_password_view.dart';
import 'package:ann_shop_flutter/view/login/forgot_password_view.dart';
import 'package:ann_shop_flutter/view/login/login_view.dart';
import 'package:ann_shop_flutter/view/inapp/blog_view.dart';
import 'package:ann_shop_flutter/view/inapp/inapp_view.dart';
import 'package:ann_shop_flutter/view/account/order_management_view.dart';
import 'package:ann_shop_flutter/view/account/setting_view.dart';
import 'package:ann_shop_flutter/view/account/shop_contact.dart';
import 'package:ann_shop_flutter/view/account/shop_policy.dart';
import 'package:ann_shop_flutter/view/favorite/favorite_view.dart';
import 'package:ann_shop_flutter/view/home_view/search_page.dart';
import 'package:ann_shop_flutter/view/list_product/list_product_by_category.dart';
import 'package:ann_shop_flutter/view/list_product/seen_view.dart';
import 'package:ann_shop_flutter/view/login/register_input_otp_view.dart';
import 'package:ann_shop_flutter/view/login/register_input_password_view.dart';
import 'package:ann_shop_flutter/view/login/register_input_phone_view.dart';
import 'package:ann_shop_flutter/view/login/register_success_view.dart';
import 'package:ann_shop_flutter/view/product/image_view.dart';
import 'package:ann_shop_flutter/view/product/product_detail_view.dart';
import 'package:ann_shop_flutter/view/product/product_filter_view.dart';
import 'package:ann_shop_flutter/view/product/product_image_by_size_and_color.dart';
import 'package:ann_shop_flutter/view/product/product_image_fancy_view.dart';
import 'package:ann_shop_flutter/view/product/product_image_share_view.dart';
import 'package:ann_shop_flutter/view/utility/empty_view.dart';
import 'package:ann_shop_flutter/view/home_view/home_view.dart';
import 'package:ann_shop_flutter/view/utility/file_view.dart';
import 'package:ann_shop_flutter/view/utility/init_view.dart';
import 'package:ann_shop_flutter/view/utility/view_more_page.dart';
import 'package:ann_shop_flutter/view/utility/web_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    /// add settings on MaterialPageRoute for which route you want to tracking
    var data = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => InitView(), settings: settings);
      case '/home':
        return CustomFadeRoute(
            builder: (_) => HomeView(), settings: settings);
      case '/web-view':
        return MaterialPageRoute(
            builder: (_) => WebViewRouter(data), settings: settings);
      case '/view_more':
        return MaterialPageRoute(
            builder: (_) => ViewMorePage(data), settings: settings);
      case '/file-view':
        Map map = data as Map;
        return MaterialPageRoute(
            builder: (_) => FileViewRouter(map['url'], map['name']),
            settings: settings);
      case '/product-detail':
        return MaterialPageRoute(
            builder: (_) => ProductDetailView(slug: data), settings: settings);
      case '/product-fancy-image':
        return MaterialPageRoute(
            builder: (_) => ProductImageFancyView(data), settings: settings);
      case '/product-share-image':
        return MaterialPageRoute(
            builder: (_) => ProductImageShareView(data), settings: settings);
      case '/image-view':
        return MaterialPageRoute(
            builder: (_) => ImageView(data), settings: settings);
      case '/product-image-by-size-and-image':
        return MaterialPageRoute(
            builder: (_) => ProductImageBySizeAndColor(data),
            settings: settings);
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
            builder: (_) => ProductFilterView(data), settings: settings);
      case '/list-product-by-category':
        return MaterialPageRoute(
            builder: (_) => ListProductByCategory(data), settings: settings);
      case '/shop-contact':
        return MaterialPageRoute(
            builder: (_) => ShopContact(), settings: settings);
      case '/shop-policy':
        return MaterialPageRoute(
            builder: (_) => ShopPolicy(), settings: settings);
      case '/login':
        return MaterialPageRoute(
            builder: (_) => LoginView(), settings: settings);
      case '/change-password':
        return MaterialPageRoute(
            builder: (_) => ChangePasswordView(), settings: settings);
      case '/forgot_password':
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordView(), settings: settings);
      case '/register_input_otp':
        return MaterialPageRoute(
            builder: (_) => RegisterInputOtpView(), settings: settings);
      case '/register_input_password':
        return MaterialPageRoute(
            builder: (_) => RegisterInputPasswordView(), settings: settings);
      case '/register_input_phone':
        return MaterialPageRoute(
            builder: (_) => RegisterInputPhoneView(), settings: settings);
      case '/register_success':
        return MaterialPageRoute(
            builder: (_) => RegisterSuccessView(), settings: settings);
      case '/update-information':
        return MaterialPageRoute(
            builder: (_) => UpdateInformation(), settings: settings);
      case '/order-management':
        return MaterialPageRoute(
            builder: (_) => OrderManagementView(), settings: settings);
      case '/inapp':
        return MaterialPageRoute(
            builder: (_) => InAppView(), settings: settings);
      case '/blog':
        return MaterialPageRoute(
            builder: (_) => BlogView(), settings: settings);
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

  static showProductDetail(context, {String slug, Product product}) {
    if (product != null) {
      Provider.of<SeenProvider>(context).addNewProduct(product);
      slug = product.slug;
    }
    Navigator.pushNamed(context, '/product-detail', arguments: slug);
  }
}
