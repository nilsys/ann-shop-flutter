import 'dart:async';
import 'dart:io';

import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/provider/product/product_repository.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/src/controllers/common/permission_controller.dart';
import 'package:ann_shop_flutter/src/controllers/views/view_controller.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutube/flutube.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';

class ANNDownload {
  static final _instance = ANNDownload._internal();

  static ANNDownload get instance => _instance;

  ANNDownload._internal();

  /// save to gallery
  Future<bool> onDownLoadImagesProduct(
      BuildContext context, int productId) async {
    if (AC.instance.canDownloadProduct == false) {
      AppSnackBar.askLogin(context);
      return false;
    }
    try {
      final images = await ProductRepository.instance
          .loadProductAdvertisementImage(productId);
      if (isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
            duration: const Duration(seconds: 1));
      } else {
        final permission = await PermissionController.instance
            .checkAndRequestStorageMedia(context);
        if (permission) {
          final result =
              await Provider.of<DownloadImageProvider>(context, listen: false)
                  .downloadImages(images);
          if (result == false) {
            AppSnackBar.showFlushbar(
                context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
          }
        }
      }
      return true;
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return false;
    }
  }

  Future<bool> onDownLoadImages(
      BuildContext context, List<String> images) async {
    if (AC.instance.canDownloadProduct == false) {
      AppSnackBar.askLogin(context);
      return false;
    }
    if (isNullOrEmpty(images)) {
      return false;
    }
    final permission = await PermissionController.instance
        .checkAndRequestStorageMedia(context);
    if (permission) {
      final result =
          await Provider.of<DownloadImageProvider>(context, listen: false)
              .downloadImages(images);
      if (result == false) {
        AppSnackBar.showFlushbar(
            context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
      }
    }
    return true;
  }

  Future<bool> onDownLoadVideoProduct(
      BuildContext context, int productId) async {
    if (AC.instance.canDownloadProduct == false) {
      AppSnackBar.askLogin(context);
      return false;
    }
    try {
      final images =
          await ProductRepository.instance.loadProductVideo(productId);
      if (isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
            duration: const Duration(seconds: 1));
      } else {
        final permission = await PermissionController.instance
            .checkAndRequestStorageMedia(context);
        if (permission) {
          final result =
              await Provider.of<DownloadImageProvider>(context, listen: false)
                  .downloadVideos(MyVideo.parseToListString(images));
          if (result == false) {
            AppSnackBar.showFlushbar(
                context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
          }
        }
      }
      return true;
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return false;
    }
  }

  Future<bool> onDownLoadVideoViewMore(
      BuildContext context, int posttId) async {
    if (AC.instance.canDownloadProduct == false) {
      AppSnackBar.askLogin(context);
      return false;
    }
    try {
      final images = await ViewController.instance.getViewMoreVideo(posttId);
      if (isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
            duration: const Duration(seconds: 1));
      } else {
        final permission = await PermissionController.instance
            .checkAndRequestStorageMedia(context);
        if (permission) {
          final result =
              await Provider.of<DownloadImageProvider>(context, listen: false)
                  .downloadVideos(MyVideo.parseToListString(images));
          if (result == false) {
            AppSnackBar.showFlushbar(
                context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
          }
        }
      }
      return true;
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return false;
    }
  }

  Future<bool> onDownLoadVideo(
      BuildContext context, List<String> videos) async {
    if (AC.instance.canDownloadProduct == false) {
      AppSnackBar.askLogin(context);
      return false;
    }
    if (AC.instance.canDownloadProduct == false) {
      AppSnackBar.askLogin(context);
      return false;
    }
    if (isNullOrEmpty(videos)) {
      return false;
    }
    final permissionGroup =
        Platform.isAndroid ? Permission.storage : Permission.photos;
    final permission = await PermissionController.instance
        .checkAndRequestPermission(context, permissionGroup);
    if (permission) {
      final result =
          await Provider.of<DownloadImageProvider>(context, listen: false)
              .downloadVideos(videos);
      if (result == false) {
        AppSnackBar.showFlushbar(
            context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
      }
    }
    return true;
  }
}
