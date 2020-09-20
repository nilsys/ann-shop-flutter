import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

import '../flutube.dart';
import 'callback_control.dart';
import 'control.dart';
import 'fluture_utility.dart';

typedef FTCallBack(VideoPlayerController controller);

class FluTube extends StatefulWidget {
  /// Youtube video URL(s)
  final String videourl;

  /// Initialize the Video on Startup. This will prep the video for playback.
  final bool autoInitialize;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Start video at a certain position
  final Duration startAt;

  /// Whether or not the video should loop
  final bool looping;

  /// Whether or not to show the controls
  final bool showControls;

  /// The Aspect Ratio of the Video. Important to get the correct size of the
  /// video!
  ///
  /// Will fallback to fitting within the space allowed.
  final double aspectRatio;

  /// Allow screen to sleep
  final bool allowScreenSleep;

  /// Show mute icon
  final bool allowMuting;

  /// Show fullscreen button.
  final bool allowFullScreen;

  /// Device orientation when leaving fullscreen.
  final List<DeviceOrientation> deviceOrientationAfterFullscreen;

  /// System overlays when exiting fullscreen.
  final List<SystemUiOverlay> systemOverlaysAfterFullscreen;

  /// The placeholder is displayed underneath the Video before it is initialized
  /// or played.
  final Widget placeholder;

  /// Play video directly in fullscreen
  final bool fullscreenByDefault;

  /// Whether or not to show the video thumbnail when the video did not start playing.
  final bool showThumb;

  /// Video start
  final VoidCallback onVideoStart;

  /// Video end
  final VoidCallback onVideoEnd;

  final Widget customControl;

  final double width;

  final double height;

  final FTCallBack callBackController;

  final PlayControlDelegate playCtrDelegate;

  final bool isFullscreen;

  String urlImageThumnail;

  FluTube(
    this.videourl, {
    Key key,
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.placeholder,
    this.showControls = true,
    this.fullscreenByDefault = false,
    this.showThumb = true,
    this.allowMuting = true,
    this.allowScreenSleep = false,
    this.allowFullScreen = true,
    this.deviceOrientationAfterFullscreen,
    this.systemOverlaysAfterFullscreen,
    this.onVideoStart,
    this.onVideoEnd,
    this.callBackController,
    this.customControl,
    this.width,
    this.height,
    this.playCtrDelegate,
    this.isFullscreen,
    this.urlImageThumnail,
  }) : super(key: key) {
    this.urlImageThumnail =
        this.urlImageThumnail ?? videoThumbURL(this.videourl);
  }

  @override
  FluTubeState createState() => FluTubeState();
}

class FluTubeState extends State<FluTube> with WidgetsBindingObserver {
  VideoPlayerController videoController;
  ChewieController chewieController;
  bool isPlaying = false;
  bool isErrorInit = false;
  bool _needsShowThumb;
  double widthCurrent;
  double heightCurrent;

  Controls controls;

  bool get showControls => widget.showControls ?? true;
  CallBackVideoController callBackVideoController;
  StatePlaying statePlaying;
  StatePlayer player;
  int countReplayWhenError = 0;
  YouTubeExtractor _extractor;

  get checkIsPlaying =>
      this.videoController != null &&
      this.videoController.value != null &&
      this.videoController.value.isPlaying;

  @override
  initState() {
    super.initState();
    try {
      if (this.videoController != null || chewieController != null) {
        disposeController();
      }
    } catch (e) {}
    _extractor = _extractor ?? YouTubeExtractor();
    callBackVideoController = CallBackVideoController();
    statePlaying = StatePlaying();
    player = StatePlayer();
    _needsShowThumb = !widget.autoPlay;

    _initialize(widget.videourl);

    widget.playCtrDelegate.replay = () {
      _playVideoLoop();
    };
  }

  @override
  void dispose() {
    print("[flutube_player.dart]-------------dispose-------------");
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
    super.dispose();
  }

  disposeController() {
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
        if (this.chewieController.videoPlayerController.value.isPlaying) {
          this.chewieController.videoPlayerController.pause();
        }
        this.chewieController.dispose();
      }
    } catch (e) {}
  }

  void _initialize(String _url) {
    print(
        "[Flutube_player.dart] _initialize--------------------URL VIDEO: $_url");
    statePlaying.hashCodeWidget = widget.playCtrDelegate.hashCode;

    if (_url == null || _url == "") {
      setState(() {
        isErrorInit = true;
        callBackVideoController?.listenStateError(true);
        return;
      });
    }

    _fetchVideoURL(_url).then((url) {
      if (url == null) {
        setState(() {
          isErrorInit = true;
          callBackVideoController?.listenStateError(true);
        });
        return;
      }

      this.videoController = VideoPlayerController.network(url)
        ..addListener(_playingListener)
        ..addListener(_errorListener)
        ..addListener(_endListener)
        ..addListener(_startListener);
      chewieController = ChewieController(
        videoPlayerController: this.videoController,
        aspectRatio: widget.aspectRatio,
        autoInitialize: widget.autoInitialize,
        autoPlay: widget.autoPlay,
        startAt: widget.startAt,
        looping: false,
        placeholder: widget.placeholder,
        showControls: false,
        fullScreenByDefault: widget.fullscreenByDefault,
        allowFullScreen: widget.allowFullScreen,
        deviceOrientationsAfterFullScreen:
            widget.deviceOrientationAfterFullscreen,
        systemOverlaysAfterFullScreen: widget.systemOverlaysAfterFullscreen,
        allowedScreenSleep: widget.allowScreenSleep,
        allowMuting: widget.allowMuting,
      );

      if (this.videoController != null &&
          this.videoController.value.initialized) {
        print(
            "---------------------call back from init to CONTROL------------------");
        callBackVideoController?.callback(this.videoController);
        widget.callBackController(this.videoController);
      }
    }).catchError((onError) {
      setState(() {
        isErrorInit = true;
        callBackVideoController?.listenStateError(true);
      });
      return;
    });
  }

  _playingListener() {
    if (this.checkIsPlaying &&
        this.videoController.value.isPlaying != isPlaying &&
        mounted) {
      setState(() {
        isPlaying = this.videoController.value.isPlaying;
      });
    }
  }

  _startListener() {
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
      callBackVideoController?.callback(this.videoController);
      widget.callBackController(this.videoController);
    }
  }

  _endListener() {
    if (this.videoController != null) {
      if (this.videoController.value.initialized &&
          !this.videoController.value.isBuffering) {
        if (this.videoController.value.position >=
            this.videoController.value.duration) {
          if (isPlaying) {
            chewieController.pause();
            chewieController.seekTo(Duration());
          }
          if (widget.onVideoEnd != null) widget.onVideoEnd();
          if (widget.showThumb && mounted) {
            setState(() {
              _needsShowThumb = true;
            });
          }

          if (widget.looping) {
            _playVideoLoop();
          }

          widget.callBackController(this.videoController);
          callBackVideoController?.callback(this.videoController);
        }
      }
    }
  }

  bool pending = false;

  _errorListener() {
    if (!this.videoController.value.hasError || pending == true) return;

    if (countReplayWhenError == 3) {
      isErrorInit = true;
      callBackVideoController?.listenStateError(true);
      return;
    }
    if (statePlaying.hashCodeWidget == widget.playCtrDelegate.hashCode &&
        player.statePlayer == FlutubeState.ON) {
      pending = true;
      if (videoController.value.errorDescription.contains("code: 403")) {
        countReplayWhenError++;
        Timer(Duration(seconds: 2), () {
          _initialize(widget.videourl);
          pending = false;
        });
      } else {
        this.videoController?.pause();
        this.videoController = null;
        chewieController = null;
        countReplayWhenError++;
        Timer(Duration(seconds: 2), () {
          _initialize(widget.videourl);
          pending = false;
        });
      }
    }
  }

  _playVideoLoop() {
    print("-------------------Handle current-----------------");
    setState(() {
      chewieController?.dispose();
      this.videoController.pause();
      this.videoController = null;
      _initialize(widget.videourl);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _controls = showControls == false
        ? SizedBox()
        : widget.customControl ??
            Controls(
              urlImageThumnail: widget.urlImageThumnail,
              playCtrDelegate: widget.playCtrDelegate,
              width: widget.width,
              height: widget.height,
              showControls: true,
              isFullScreen: widget.isFullscreen,
              controlsActiveBackgroundOverlay: false,
              controlsTimeOut: const Duration(seconds: 2),
              switchFullScreenOnLongPress: false,
            );
    if (widget.showThumb && !isPlaying && _needsShowThumb || isErrorInit) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                isErrorInit
                    ? _controls
                    : CachedNetworkImage(
                        imageUrl: widget.urlImageThumnail ??
                            videoThumbURL(widget.videourl),
                        width: widget.width,
                        height: widget.height,
                        fit: BoxFit.cover,
                      )
              ],
            ),
          ),
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          chewieController != null
              ? Chewie(key: widget.key, controller: chewieController)
              : Container(),
          _controls
        ],
      );
    }
  }

  Future<String> _fetchVideoURL(String yt) async {
    print(
        "------>>>> _extractor Start: [${DateTime.now().toString()}] <<<<------");
    try {
      var result = await _extractor.getMediaStreamsAsync(yt);

      print(
          "------>>>> _extractor End: [${DateTime.now().toString()}] <<<<------");
      return result != null &&
              result.muxed != null &&
              result.muxed.first != null &&
              result.muxed.first.url != null
          ? result.muxed.first.url
          : "";
    } catch (e) {
      print("-------------try catch-----------------");
      print("---- cache fe");
      isErrorInit = true;
      callBackVideoController?.listenStateError(true);
      return null;
    }
  }
}
