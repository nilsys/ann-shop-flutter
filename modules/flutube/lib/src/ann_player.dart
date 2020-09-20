import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutube/flutube.dart';
import 'package:flutube/src/video_controller_helper.dart';
import 'package:video_player/video_player.dart';

import 'fluture_utility.dart';

class ANNPlayer extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final bool isPortrait;

  /// null will use default ut thumnail
  final String urlImageThumnail;
  final Function(bool) playCallback;
  final StatePlayer statePlayer;

  ANNPlayer({
    this.videoUrl,
    this.width,
    this.height,
    this.isPortrait = false,
    this.playCallback,
    this.urlImageThumnail,
    this.statePlayer,
  });

  @override
  _ANNPlayerState createState() => _ANNPlayerState();
}

class _ANNPlayerState extends State<ANNPlayer>
    with WidgetsBindingObserver
    implements PlayControlDelegate {
  EventControl eventControl;
  VideoPlayerController videoController;

  StatePlayer player;

  @override
  void initState() {
    super.initState();
    player = StatePlayer();

    if (player.statePlayer == FlutubeState.ON) {
      debugPrint('[Player.dart | FUCN: initState | Mess: Player is ON]');
    } else {
      debugPrint('[Player.dart | FUCN: initState | Mess: Player is OFF]');
      player.statePlayer = FlutubeState.ON;
    }

    eventControl = EventControl();
    VideoControllerHelper.instance
      ..pause = () {
        videoController.pause();
      }
      ..play = () {
        videoController.play();
      };

    screenKeepOn(true);
  }

  @override
  void dispose() {
    debugPrint('[player.dart]-------------dispose-------------');

    screenKeepOn(false);
    if (player.stateScreen == null ||
        player.stateScreen == FlutubeStateScreen.NEW) {
      player.statePlayer = FlutubeState.OFF;
      debugPrint('[Player.dart | FUCN: dispose | Mess: Player is OFF]');
    }
    player.stateScreen = FlutubeStateScreen.NEW;
    videoController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.isPortrait ? widget.width / kRatioVideo : widget.height,
      alignment: Alignment.topCenter,
      child: FluTube(
        widget.videoUrl,
        isFullscreen: !widget.isPortrait,
        autoInitialize: false,
        aspectRatio: kRatioVideo,
        allowMuting: false,
        looping: false,
        autoPlay: true,
        width: widget.width,
        height: widget.isPortrait ? widget.width / kRatioVideo : widget.height,
        deviceOrientationAfterFullscreen: const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        showControls: true,
        systemOverlaysAfterFullscreen: SystemUiOverlay.values,
        callBackController: (controllerCallback) {
          videoController = controllerCallback;
        },
        playCtrDelegate: this,
        urlImageThumnail: widget.urlImageThumnail,
      ),
    );
  }

  @override
  Future<bool> fullscreen(bool isFullscreen) {
    return VideoControllerHelper.instance
        .fullscreenPressedCallback(!isFullscreen);
  }

  @override
  bool playVideo(bool isPlaying) {
    eventControl.play();
    return !isPlaying;
  }

  @override
  Function() replay;

  @override
  bool showControl(bool isShow) {
    if (VideoControllerHelper.instance.showControlCallback != null) {
      return VideoControllerHelper.instance.showControlCallback(isShow);
    }
    return true;
  }

  @override
  Function() downloadVideo;
}
