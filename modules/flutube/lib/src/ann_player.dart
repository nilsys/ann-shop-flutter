import 'dart:async';
import 'package:flutter/material.dart';
import 'my_chewie.dart';

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MyChewie(widget.videoUrl),
          widget.child ?? SizedBox(),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}
