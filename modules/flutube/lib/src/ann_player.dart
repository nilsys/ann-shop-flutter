import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutube/src/default_placeholder.dart';
import 'my_youtube.dart';

class ANNPlayer extends StatefulWidget {
  final String videoUrl;
  final Widget child;

  ANNPlayer({@required this.videoUrl, @required this.child});

  @override
  _ANNPlayerState createState() => _ANNPlayerState();
}

class _ANNPlayerState extends State<ANNPlayer> {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MyYoutube(
          widget.videoUrl,
          key: Key("ANNPlayer: ${widget.videoUrl}"),
          placeholder: DefaultPlaceHolder(),
        ),
        widget.child ?? SizedBox(),
      ],
    );
  }

}
