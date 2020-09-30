import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutube/flutube.dart';
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
  ChewieController chewieController;

  @override
  initState() {
    super.initState();
    _initialize(widget.videoUrl);
  }

  @override
  void dispose() {
    VideoHelper.instance.dispose();

    if (this.chewieController != null) {
      this.chewieController?.dispose();
    }
    super.dispose();
  }

  void _initialize(String _url) {
    print(
        "[Flutube_player.dart] _initialize--------------------URL VIDEO: $_url");

    VideoHelper.instance.initialize(VideoPlayerController.network(_url));
    chewieController = ChewieController(
      videoPlayerController: VideoHelper.instance.videoController,
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

  @override
  Widget build(BuildContext context) {
    return Chewie(key: widget.key, controller: chewieController);
  }
}
