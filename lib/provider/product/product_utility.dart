import 'dart:io';

import 'package:flutube/src/models/my_video.dart';
import 'package:ann_shop_flutter/provider/product/product_repository.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/src/controllers/common/permission_controller.dart';

import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProductUtility {
  factory ProductUtility() => instance;
  static final ProductUtility instance = ProductUtility._internal();

  ProductUtility._internal() {
    /// init
    productSorts = [
      ProductSort(id: 4, title: 'Mới nhập kho'),
      ProductSort(id: 2, title: 'Giá giảm dần'),
      ProductSort(id: 1, title: 'Giá tăng dần'),
      ProductSort(id: 3, title: 'Mẫu mới nhất'),
    ];

    productBadge = [
      ProductBadge(id: 1, title: 'Hàng có sẵn'),
      ProductBadge(id: 2, title: 'Hết hàng'),
      ProductBadge(id: 3, title: 'Hàng order'),
      ProductBadge(id: 4, title: 'Hàng sale'),
      ProductBadge(id: 5, title: 'Đang nhập kho'),
    ];
  }

  List<ProductSort> productSorts;
  List<ProductBadge> productBadge;

  String getBadgeName(badge) {
    switch (badge) {
      case 1:
        return 'Có sẵn';
        break;
      case 2:
        return 'Hết hàng';
        break;
      case 3:
        return 'Order';
        break;
      case 4:
        return 'Sale';
        break;
      case 5:
        return 'Đang nhập kho';
        break;
      default:
        return '';
        break;
    }
  }

  Color getBadgeColor(badge) {
    switch (badge) {
      case 1:
        return AppStyles.orange;
        break;
      case 2:
        return Colors.grey[700];
        break;
      case 3:
        return Colors.purple;
        break;
      case 4:
        return Colors.grey;
        break;
      case 5:
        return const Color(0xfffdc80f);
        break;
      default:
        return null;
        break;
    }
  }

  Future onCheckAndCopy(BuildContext context, int productId) async {
    if (AC.instance.canCopyBloc == false) {
      AppSnackBar.askLogin(context);
      return;
    }
    if (CopyController.instance.copySetting.showed) {
      await _onCopy(context, productId);
      AppSnackBar.showFlushbar(
        context,
        'Đã copy, hãy dán vào nơi đăng sản phẩm',
        duration: const Duration(seconds: 1),
      );
    } else {
      await Navigator.pushNamed(context, 'user');
    }
  }

  Future<String> _onCopy(BuildContext context, int productId) async {
    final result = await ProductRepository.instance
        .loadProductAdvertisementContent(productId);
    await Clipboard.setData(new ClipboardData(text: result));
    return result;
  }

  Future onCheckAndShare(BuildContext context, Product product) async {
    if (AC.instance.canPostProduct == false) {
      AppSnackBar.askLogin(context);
      return;
    }
    _onShare(context, product);
  }

  Future _onShare(BuildContext context, Product product) async {
    try {
      final message = await _onCopy(context, product.productId);
      showLoading(context, message: 'Đang tải...');
      final images = await ProductRepository.instance
          .loadProductAdvertisementImage(product.productId);
      List<MyVideo> videos =
          await ProductRepository.instance.loadProductVideo(product.productId);

      hideLoading(context);
      if (isNullOrEmpty(images) == false) {
        await Navigator.pushNamed(context, 'product/detail/share-social',
            arguments: {
              'images': images,
              'videos': videos,
              'title': product.name,
              'message': message
            });
      } else {
        throw ArgumentError('API fail');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return;
    }
  }
}
