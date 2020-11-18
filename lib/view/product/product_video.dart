import 'package:flutube/src/models/my_video.dart';
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
    return Center(
      child: MyYoutube(
        video.url,
          showFullButton: showFullButton,
        key: Key("MyChewie-$index-${video.url}"),
      ),
    );
  }
}
