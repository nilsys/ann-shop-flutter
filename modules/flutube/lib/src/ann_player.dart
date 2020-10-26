import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutube/src/default_placeholder.dart';
import 'package:flutube/src/play_control_delegate.dart';
import 'my_chewie.dart';
import 'package:video_player/video_player.dart';

class ANNPlayer extends StatefulWidget {
  final String videoUrl;
  final Widget child;

  ANNPlayer({@required this.videoUrl, @required this.child});

  @override
  _ANNPlayerState createState() => _ANNPlayerState();
}

class _ANNPlayerState extends State<ANNPlayer> implements PlayControlDelegate {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MyChewie(
            widget.videoUrl,
            callBackController: (c) {
              videoController = c;
            },
            key: Key("ANNPlayer: ${widget.videoUrl}"),
            placeholder: DefaultPlaceHolder(),
          ),
          widget.child ?? SizedBox(),
        ],
      ),
    );
  }

  VideoPlayerController videoController;

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Future<bool> fullscreen(bool isFullscreen) {
    print("fullscreen");
    return null;
  }
}
