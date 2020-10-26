import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutube/flutube.dart';
import 'package:flutube/src/play_control_delegate.dart';
import 'package:video_player/video_player.dart';

import 'fluture_utility.dart';

class MyChewie extends StatefulWidget {
  /// Youtube video URL(s)
  final String videoUrl;
  final String thumnailUrl;

  /// Initialize the Video on Startup. This will prep the video for playback.
  final bool autoInitialize;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Show mute icon
  final bool allowMuting;

  /// Show fullscreen button.
  final bool allowFullScreen;

  /// The placeholder is displayed underneath the Video before it is initialized
  /// or played.
  final Widget placeholder;

  /// Device orientation when leaving fullscreen.
  final List<DeviceOrientation> deviceOrientationAfterFullscreen;

  /// System overlays when exiting fullscreen.
  final List<SystemUiOverlay> systemOverlaysAfterFullscreen;

  /// Video start
  final VoidCallback onVideoStart;

  /// Video end
  final VoidCallback onVideoEnd;

  final FTCallBack callBackController;

  final PlayControlDelegate playCtrDelegate;

  MyChewie(
    this.videoUrl, {
    Key key,
    this.autoInitialize = true,
    this.autoPlay = true,
    this.allowMuting = true,
    this.allowFullScreen = true,
    this.deviceOrientationAfterFullscreen = const [
      // DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    this.systemOverlaysAfterFullscreen = SystemUiOverlay.values,
    this.onVideoStart,
    this.onVideoEnd,
    this.callBackController,
    this.playCtrDelegate,
    this.thumnailUrl,
    this.placeholder,
  }) : super(key: key);

  @override
  _MyChewieState createState() => _MyChewieState();
}

class _MyChewieState extends State<MyChewie> with WidgetsBindingObserver {
  VideoPlayerController videoController;
  ChewieController chewieController;
  bool isPlaying = false;
  bool isErrorInit = false;
  double widthCurrent;
  double heightCurrent;

  StatePlaying statePlaying;
  StatePlayer player;
  int countReplayWhenError = 0;

  bool get checkIsPlaying =>
      this.videoController != null &&
      this.videoController.value != null &&
      this.videoController.value.isPlaying;

  @override
  void initState() {
    super.initState();
    this.commonInitState();
  }

  @override
  void dispose() {
    debugPrint("[flutube_player.dart]-------------dispose-------------");
    this.commonDispose();
    super.dispose();
  }

  void commonInitState() {
    try {
      if (this.videoController != null || chewieController != null) {
        disposeController();
      }
    } catch (_) {}
    statePlaying = StatePlaying();
    player = StatePlayer();

    _initialize(widget.videoUrl);
  }

  void commonDispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (videoController != null && player.statePlayer == FlutubeState.OFF) {
      this.videoController?.removeListener(_playingListener);
      this.videoController?.removeListener(_errorListener);
      this.videoController?.removeListener(_endListener);
      this.videoController.removeListener(_startListener);
    }
    if (this.chewieController != null) {
      if (this.chewieController?.videoPlayerController?.value?.isPlaying ??
          false) {
        this.chewieController?.videoPlayerController?.pause();
      }
      this.chewieController?.dispose();
    }
  }

  void disposeController() {
    try {
      if (this.videoController != null &&
          statePlaying.hashCodeWidget != null &&
          statePlaying.hashCodeWidget != widget.playCtrDelegate.hashCode) {
        this.videoController.removeListener(_playingListener);
        this.videoController.removeListener(_errorListener);
        this.videoController.removeListener(_endListener);
        this.videoController.removeListener(_startListener);
      }
      if (this.chewieController != null) {
        if (this.chewieController?.videoPlayerController?.value?.isPlaying ??
            false) {
          this.chewieController.videoPlayerController.pause();
        }
        this.chewieController?.dispose();
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _initialize(String _url) {
    debugPrint(
        "[Flutube_player.dart] _initialize--------------------URL VIDEO: $_url");
    statePlaying.hashCodeWidget = widget.playCtrDelegate?.hashCode;

    if (_url == null || _url == "") {
        isErrorInit = true;
        return;
    }

    this.videoController = VideoPlayerController.network(_url)
      ..addListener(_playingListener)
      ..addListener(_errorListener)
      ..addListener(_endListener)
      ..addListener(_startListener);
    chewieController = ChewieController(
      videoPlayerController: this.videoController,
      aspectRatio: kRatioVideo,
      autoInitialize: widget.autoInitialize,
      autoPlay: widget.autoPlay,
      looping: true,
      placeholder: widget.placeholder,
      showControls: true,
      allowFullScreen: widget.allowFullScreen,
      deviceOrientationsAfterFullScreen:
          widget.deviceOrientationAfterFullscreen,
      systemOverlaysAfterFullScreen: widget.systemOverlaysAfterFullscreen,
      allowedScreenSleep: false,
      allowMuting: widget.allowMuting,
    );

    debugPrint(
        "---------------------call back from init to CONTROL------------------");
    onCallBackVideoController();
  }

  void onCallBackVideoController() {
    if (widget.callBackController != null) {
      widget.callBackController(this.videoController);
    }
  }

  void _playingListener() {
    if (this.checkIsPlaying &&
        this.videoController.value.isPlaying != isPlaying &&
        mounted) {
        isPlaying = this.videoController.value.isPlaying;
    }
  }

  void _startListener() {
    if (((player.statePlayer == FlutubeState.OFF) ||
            (statePlaying.hashCodeWidget != null &&
                statePlaying.hashCodeWidget !=
                    widget.playCtrDelegate.hashCode)) &&
        this.videoController != null &&
        this.videoController.value.isPlaying) {
      this.videoController.pause();
    }
    if (this.videoController != null &&
        this.videoController.value.initialized &&
        mounted) {
      VideoHelper.instance.setCurrentController(this.videoController);
      onCallBackVideoController();
    }
  }

  void _endListener() {
    if (this.videoController != null) {
      if (this.videoController.value.initialized &&
          !this.videoController.value.isBuffering) {
        final duration = this.videoController.value.duration.inSeconds;
        if (this.videoController.value.position.inSeconds >= (duration - 1)) {
          if (isPlaying) {
            chewieController.seekTo(const Duration());
            return;
          }
          if (widget.onVideoEnd != null) {
            widget.onVideoEnd();
          }
          onCallBackVideoController();
        }
      }
    }
  }

  bool pending = false;

  void _errorListener() {
    if (!this.videoController.value.hasError || pending == true) {
      return;
    }

    if (countReplayWhenError == 3) {
      isErrorInit = true;
      return;
    }
    if (statePlaying.hashCodeWidget == widget.playCtrDelegate.hashCode &&
        player.statePlayer == FlutubeState.ON) {
      pending = true;
      if (videoController.value.errorDescription.contains("code: 403")) {
        countReplayWhenError++;
        Timer(const Duration(seconds: 2), () {
          _initialize(widget.videoUrl);
          pending = false;
        });
      } else {
        this.videoController?.pause();
        this.videoController = null;
        chewieController = null;
        countReplayWhenError++;
        Timer(const Duration(seconds: 2), () {
          _initialize(widget.videoUrl);
          pending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(key: widget.key, controller: chewieController);
  }
}
