import 'dart:async';
import 'dart:io';

import 'package:ann_shop_flutter/src/services/common/permission_services.dart';
import 'package:ann_shop_flutter/src/services/utils/ann_logging.dart';
import 'package:ann_shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ANNDownload {
  // region Singleton Pattern
  static final _instance = ANNDownload._internal();

  // endregion

  // region Parameters
  ANNLogging _logging;
  PermissionService _permission;

  // endregion

  // region Getter
  static ANNDownload get instance => _instance;

  // endregion

  ANNDownload._internal() {
    _logging = ANNLogging.instance;
    _permission = PermissionService.instance;
  }

  factory ANNDownload() => instance;

  Future<void> downloadImages(BuildContext context, List<String> images) async {
    // check the storage permission
    final permissionGroup =
        Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos;
    final checkPermission =
        await _permission.checkAndRequestPermission(context, permissionGroup);

    if (!checkPermission) return;

    // endregion

    var loadingDialog = new LoadingDialog(context, message: 'Đang tải...');
    var cache = DefaultCacheManager();
    var downloaded = 0;
    var count = images.length;

    loadingDialog.show();
    for (var index = 0; index < count; index++) {
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        var file = await cache.getSingleFile(images[index]);

        if (file != null) {
          var bytes = file.readAsBytesSync();

          await ImageGallerySaver.saveImage(bytes).catchError(
              (e) => _logging.logError('Save the image into the gallery', e));

          downloaded++;
          loadingDialog.message = 'Đã tải $downloaded/$count hình';
        }
      } catch (e) {
        _logging.logError('Cache Manger', e);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (downloaded == 0)
      loadingDialog.message = 'Đã xảy ra lỗi trong quá trình tải hình.';
    else
      loadingDialog.message = 'Đã xong';

    await Future.delayed(const Duration(milliseconds: 500));
    loadingDialog.close();
  }
}
