import 'package:ann_shop_flutter/model/utility/my_video.dart';
import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';
import 'package:ping9/ping9.dart';

class ProductVideo extends StatelessWidget {
  const ProductVideo(this.video, this.index, {Key key, this.showFullButton = true}) : super(key: key);
  final int index;
  final MyVideo video;
  final bool showFullButton;

  @override
  Widget build(BuildContext context) {
    final isFull = isFullScreen(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isFull ? 32 : 0),
      child: Center(
        child: MyYoutube(
          video.url,
            showFullButton: showFullButton,
          key: Key("MyChewie-$index-${video.url}"),
        ),
      ),
    );
  }
}
