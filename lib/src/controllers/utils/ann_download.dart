import 'dart:async';
import 'dart:io';

import 'package:ann_shop_flutter/src/controllers/common/permission_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping9/ping9.dart';

import 'ann_logging.dart';

class ANNDownload {
  static final _instance = ANNDownload._internal();
  ANNLogging _logging;
  PermissionController _permission;
  int _timeout;

  // endregion

  // region Getter
  static ANNDownload get instance => _instance;

  // endregion

  ANNDownload._internal() {
    _logging = ANNLogging.instance;
    _permission = PermissionController.instance;
    _timeout = 5;
  }

  factory ANNDownload() => instance;

  Future<void> downloadImages(BuildContext context, List<String> images) async {
    // check the storage permission
    final permissionGroup =
        Platform.isAndroid ? Permission.storage : Permission.photos;
    final checkPermission =
        await _permission.checkAndRequestPermission(context, permissionGroup);

    if (!checkPermission) return;

    // endregion

    showLoading(context, message: 'Đang tải...');
    var cache = DefaultCacheManager();
    var downloaded = 0;
    var count = images.length;
    for (var index = 0; index < count; index++) {
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        var file = await cache
            .getSingleFile(images[index])
            .timeout(Duration(seconds: _timeout));

        if (file != null) {
          var bytes = file.readAsBytesSync();

          await ImageGallerySaver.saveImage(bytes).catchError(
              (e) => _logging.logError('Save the image into the gallery', e));

          downloaded++;
          updateLoading('Đã tải $downloaded/$count hình');
        }
      } catch (e) {
        _logging.logError('Cache Manger', e);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (downloaded == 0)
      updateLoading('Đã xảy ra lỗi trong quá trình tải hình.');
    else
      updateLoading('Đã tải xong');

    await Future.delayed(const Duration(milliseconds: 500));
    hideLoading(context);
  }
}
