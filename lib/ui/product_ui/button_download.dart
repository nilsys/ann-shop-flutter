import 'dart:typed_data';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ButtonDownload extends StatefulWidget {
  ButtonDownload({this.imageName, this.cache = false});

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
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        IconButton(
          icon: loading == loadState.loading
              ? Indicator(
                  radius: 12,
                )
              : loading == loadState.success
                  ? Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.file_download,
                      color: Colors.white,
                    ),
          onPressed: (Utility.isNullOrEmpty(this.widget.imageName) == false &&
                  loading == loadState.none)
              ? () {
                  _download();
                }
              : null,
        ),
      ]),
    );
  }

  loadState loading = loadState.none;

  _download() async {
    try {
      setState(() {
        loading = loadState.loading;
      });
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + widget.imageName)
          .timeout(Duration(seconds: 10));
      print(file.path);
      Uint8List bytes = file.readAsBytesSync();
      await ImageGallerySaver.saveImage(bytes).timeout(Duration(seconds: 5));
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
