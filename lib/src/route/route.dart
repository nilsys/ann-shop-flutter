import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/provider/utility/search_provider.dart';
import 'package:ann_shop_flutter/src/controllers/common/permission_controller.dart';
import 'package:ann_shop_flutter/src/models/ann_page.dart';
import 'package:ann_shop_flutter/src/models/pages/root_pages/root_page_navigation_bar.dart';
import 'package:ann_shop_flutter/src/providers/roots/root_page_provider.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';


class  Routes {

  // region navigate page
  static RootPageProvider _getProvider(BuildContext context) {
    return Provider.of<RootPageProvider>(context, listen: false);
  }

  static void navigateHome(BuildContext context, ANNPage newPage,
      {String notificationType = ''}) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.category:
        provider.navigate(RootPageNavigationBar.category);
        break;
      case ANNPage.search:
        final searchProvider =
        Provider.of<SearchProvider>(context, listen: false);

        searchProvider.setOpenKeyBoard(true);
        provider.navigate(RootPageNavigationBar.search);
        break;
      case ANNPage.notification:
        if (!isEmpty(notificationType)) {
          final notificationProvider =
          Provider.of<InAppProvider>(context, listen: false);

          notificationProvider.currentCategory = notificationType;
        }

        provider.navigate(RootPageNavigationBar.notification);
        break;
      case ANNPage.scan:
        if (AC.instance.isLogin) {
          final permission = PermissionController.instance;

          permission
              .checkAndRequestPermission(context, Permission.camera)
              .then((bool result) {
            if (result) Navigator.pushNamed(context, "search/scan");
          });
        } else {
          AskLogin.show(context);
        }
        break;
      default:
        break;
    }
  }

  static void navigateProduct(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.home:
        provider.navigate(RootPageNavigationBar.home);
        Navigator.popUntil(context, ModalRoute.withName('home'));
        break;
      case ANNPage.category:
        provider.navigate(RootPageNavigationBar.category);
        Navigator.popUntil(context, ModalRoute.withName('home'));
        break;
      case ANNPage.user:
        provider.navigate(RootPageNavigationBar.user);
        Navigator.popUntil(context, ModalRoute.withName('home'));
        break;
      case ANNPage.favorite:
        Navigator.pushNamed(context, 'user/favorite');
        break;
      default:
        break;
    }
  }

  static void navigateSearch(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    switch (newPage) {
      case ANNPage.home:
        searchProvider.setOpenKeyBoard(false);
        provider.navigate(RootPageNavigationBar.home);
        break;
      case ANNPage.scan:
        final permission = PermissionController.instance;

        searchProvider.setOpenKeyBoard(false);
        permission
            .checkAndRequestPermission(context, Permission.camera)
            .then((bool result) {
          if (result) Navigator.pushNamed(context, "search/scan");
        });
        break;
      default:
        break;
    }
  }

  static void navigateUser(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.notification:
        provider.navigate(RootPageNavigationBar.notification);
        break;
      default:
        break;
    }
  }

  static void navigateFavorite(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.home:
        provider.navigate(RootPageNavigationBar.category);
        Navigator.popUntil(context, ModalRoute.withName('home'));
        break;
      default:
        break;
    }
  }

  static void navigateLogin(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.home:
        provider.navigate(RootPageNavigationBar.home);
        Navigator.pushNamedAndRemoveUntil(
            context, 'home', (Route<dynamic> route) => false);
        break;
      default:
        break;
    }
  }

  static void navigateRegister(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.home:
        provider.navigate(RootPageNavigationBar.home);
        Navigator.pushNamedAndRemoveUntil(
            context, 'home', (Route<dynamic> route) => false);
        break;
      default:
        break;
    }
  }

  static void navigateForgetPassword(BuildContext context, ANNPage newPage) {
    final provider = _getProvider(context);

    switch (newPage) {
      case ANNPage.home:
        provider.navigate(RootPageNavigationBar.home);
        Navigator.pushNamedAndRemoveUntil(
            context, 'home', (Route<dynamic> route) => false);
        break;
      default:
        break;
    }
  }

  // endregion

  static String getNameExtractor(RouteSettings settings) {
    /// User for override route's name
    switch (settings.name) {
      case '/':
        return null;
      default:
        return settings.name;
    }
  }

  static showProductDetail(context,
      {String slug, Product product, ProductDetail detail}) async {
    if (AC.instance.canViewProduct == false) {
      AppSnackBar.askLogin(context, message: K.needLoginToViewProduct);
      return;
    }

    if (detail != null) {
      Provider.of<SeenProvider>(context, listen: false).addNewProduct(detail);
      slug = detail.slug;
      Provider.of<ProductProvider>(context, listen: false)
          .getBySlug(detail.slug)
          .completed = detail;
    } else {
      if (product != null) {
        Provider.of<SeenProvider>(context, listen: false)
            .addNewProduct(product);
        slug = product.slug;
      }
      await Navigator.pushNamed(context, 'product/detail', arguments: slug);
    }
  }
}