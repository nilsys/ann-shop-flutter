import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

class ImageView extends StatelessWidget {
  ImageView(data) {
    url = data['url'];
    tag = data['tag'];
  }

  var url;
  var tag;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: GestureZoomBox(
                child: Hero(
                  tag: url + tag,
                  child: AppImage(
                    Core.domain + url,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 15,
              child: UIManager.btnClose(onPressed: () {
                Navigator.pop(context);
              }),
            ),
            ButtonDownload(
              imageName: url,
              cache: true,
            ),
          ],
        ),
      ),
    );
  }
}
