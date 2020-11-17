import 'package:ann_shop_flutter/model/utility/my_video.dart';
import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';

class ProductVideo extends StatelessWidget {
  const ProductVideo(this.video, this.index, {Key key}) : super(key: key);
  final int index;
  final MyVideo video;

  @override
  Widget build(BuildContext context) {
    return MyYoutube(
      video.url,
      thumnailUrl: video.thumbnail,
      key: Key("MyChewie-$index-${video.url}"),
      placeholder: DefaultPlaceHolder(),
    );
  }
}
