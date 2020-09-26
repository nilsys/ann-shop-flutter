import 'package:ann_shop_flutter/src/widgets/common/gesture_zoom_box.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ping9/ping9.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  ImageView(this.data);

  final data;

  @override
  _ImageViewState createState() => _ImageViewState(data['url'], data['tag']);
}

class _ImageViewState extends State<ImageView> {
  _ImageViewState(this.url, this.tag);

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
                  tag: tag,
                  child: AppImage(url,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 15,
              child: ButtonClose(onPressed: () {
                Navigator.pop(context);
              }),
            ),
            ButtonDownload(
              imageName:  url,
              cache: true,
            ),
          ],
        ),
      ),
    );
  }
}
