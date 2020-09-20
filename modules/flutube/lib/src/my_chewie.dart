import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'fluture_utility.dart';

class MyChewie extends StatefulWidget {
  /// Mp4 video URL(s)
  final String videoUrl;

  MyChewie(
    this.videoUrl, {
    Key key,
  }) : super(key: key);

  @override
  MyChewieState createState() => MyChewieState();
}

class MyChewieState extends State<MyChewie> {
  VideoPlayerController videoController;
  ChewieController chewieController;

  @override
  initState() {
    super.initState();
    _initialize(widget.videoUrl);
  }

  @override
  void dispose() {
    if (videoController?.value?.isPlaying ?? false) {
      this.videoController.pause();
    }
    this.videoController?.dispose();
    this.videoController = null;

    if (this.chewieController != null) {
      this.chewieController?.dispose();
    }
    super.dispose();
  }

  void _initialize(String _url) {
    print(
        "[Flutube_player.dart] _initialize--------------------URL VIDEO: $_url");

    this.videoController = VideoPlayerController.network(_url);
    chewieController = ChewieController(
      videoPlayerController: this.videoController,
      aspectRatio: kRatioVideo,
      autoInitialize: false,
      autoPlay: true,
      looping: false,
      showControls: true,
      fullScreenByDefault: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
      allowedScreenSleep: false,
      allowMuting: true,
    );
  }

  _playVideoLoop() {
    print("-------------------Handle current-----------------");
    setState(() {
      chewieController?.dispose();
      this.videoController.pause();
      this.videoController = null;
      _initialize(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(key: widget.key, controller: chewieController);
  }
}
