import 'package:ann_shop_flutter/provider/utility/gallery_saver_helper.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_download.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/src/controllers/common/permission_controller.dart';

import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:flutter/material.dart';

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
          onPressed: (isNullOrEmpty(widget.imageName) == false &&
                  loading == loadState.none)
              ? _download
              : null,
        ),
      ]),
    );
  }

  loadState loading = loadState.none;

  Future _download() async {
    if (AC.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }
    try {
      final bool permission = await PermissionController.instance
          .checkAndRequestStorageMedia(context);
      if (permission == false) return;

      setState(() {
        loading = loadState.loading;
      });
      await GallerySaverHelper.instance.saveImage(widget.imageName);
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
      print(e);
      AppSnackBar.showHighlightTopMessage(context, 'Lưu hình ảnh thất bại.');
      setState(() {
        loading = loadState.none;
      });
    }
  }
}

enum loadState { none, loading, success }

class ButtonDownLoadVideo extends StatelessWidget {
  ButtonDownLoadVideo(this.videoUrl, {this.productID});

  final String videoUrl;
  final int productID;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 15,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          height: 35,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.file_download,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () =>
              ANNDownload.instance.onDownLoadVideoProduct(context, productID),
        ),
      ]),
    );
  }
}
