import 'dart:typed_data';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/repository/permission_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ButtonDownload extends StatefulWidget {
  const ButtonDownload({this.imageName, this.cache = false});

  final String imageName;
  final bool cache;

  @override
  _ButtonDownloadState createState() => _ButtonDownloadState();
}

class _ButtonDownloadState extends State<ButtonDownload> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      bottom: 0,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          height: 35,
          width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        IconButton(
          icon: loading == loadState.loading
              ? Indicator(
                  radius: 10,
                )
              : loading == loadState.success
                  ? Icon(
                      Icons.done,
                      size: 20,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.file_download,
                      size: 20,
                      color: Colors.white,
                    ),
          onPressed: (Utility.isNullOrEmpty(widget.imageName) == false &&
                  loading == loadState.none)
              ? _download
              : null,
        ),
      ]),
    );
  }

  loadState loading = loadState.none;

  Future _download() async {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }
    try {
      final bool permission = await PermissionRepository.instance
          .checkAndRequestPermission(PermissionGroup.mediaLibrary);
      if (permission == false) {
        await AppPopup.showCustomDialog(
          context,
          content: [
            AvatarGlow(
              endRadius: 50,
              duration: const Duration(milliseconds: 1000),
              glowColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.settings,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              'Cần quyền truy cập Hình Ảnh của bạn để sử dụng tín năng này. Bạn có muốn mở thiết lập cài đặt?',
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.center,
            ),
            CenterButtonPopup(
                normal: ButtonData(
                  'Không',
                ),
                highlight: ButtonData(
                  'Mở cài đặt',
                  onPressed: () {
                    PermissionHandler().openAppSettings();
                  },
                ))
          ],
        );
        return;
      }

      setState(() {
        loading = loadState.loading;
      });
      final file = await DefaultCacheManager()
          .getSingleFile(Core.domain + widget.imageName)
          .timeout(const Duration(seconds: 10));
      debugPrint(file.path);
      final Uint8List bytes = file.readAsBytesSync();
      await ImageGallerySaver.saveImage(bytes)
          .timeout(const Duration(seconds: 5));
      if (widget.cache == false) {
        AppSnackBar.showHighlightTopMessage(
            context, 'Lưu hình ảnh thành công.');
      }
      setState(() {
        if (widget.cache == false) {
          loading = loadState.none;
        } else {
          loading = loadState.success;
        }
      });
    } catch (e) {
      debugPrint(e);
      AppSnackBar.showHighlightTopMessage(context, 'Lưu hình ảnh thất bại.');
      setState(() {
        loading = loadState.none;
      });
    }
  }
}

enum loadState { none, loading, success }
