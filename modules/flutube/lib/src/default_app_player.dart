import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutube/flutube.dart';
import 'package:flutube/src/video_controller_helper.dart';

import 'orientation_control.dart';

class DefaultANNPlayer extends StatefulWidget {
  final String videoUrl;
  final Widget child;

  DefaultANNPlayer({this.videoUrl, this.child});

  @override
  _DefaultANNPlayerState createState() => _DefaultANNPlayerState();
}

class _DefaultANNPlayerState extends State<DefaultANNPlayer>
    with WidgetsBindingObserver {
  // -------------- STREAM --------------
  StreamController<bool> screenStreamController =
      StreamController<bool>.broadcast();

  // -------------- MEMBER --------------
  String dataSourceVideo;
  double widthCurrent;
  double heightCurrent;
  bool readyPlayVideo = false;
  bool isUserForceScreenMode = false;
  int currentVideoPosition = 0;

  VideoControllerHelper videoControllerHelper;
  bool isPortrait = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    );

    videoControllerHelper = VideoControllerHelper.instance
      ..fullscreenPressedCallback = fullscreenPressed;

    super.initState();
  }

  @override
  void dispose() {
    debugPrint('[YoutubePlaying]-------------dispose-------------');
    screenStreamController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onBack() {
    if (Platform.isIOS) {
      try {
        OrientationControl.forcePortraitIOS();
      } on PlatformException {
        debugPrint('[YoutubePlaying] forcePortraitIOS');
      }
    }
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void didChangeMetrics() {
    if (isUserForceScreenMode) {
      isUserForceScreenMode = false;
      super.didChangeMetrics();
      return;
    }
    widthCurrent = WidgetsBinding.instance.window.physicalSize.width;
    heightCurrent = WidgetsBinding.instance.window.physicalSize.height;
    // Switched to LandScape Mode
    if (widthCurrent > heightCurrent) {
      screenStreamController.sink.add(true);
      SystemChrome.setEnabledSystemUIOverlays([]);

      isPortrait = false;
    }
    // Switched to Portrait Mode
    if (widthCurrent < heightCurrent) {
      screenStreamController.sink.add(false);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      isPortrait = true;
      SystemChrome.setPreferredOrientations(
        const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
    }

    super.didChangeMetrics();
  }

  void setStateMounted([Function callback]) {
    if (mounted) {
      setState(() {
        callback();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Container(
          color: const Color(0xFFfefefe),
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              final Size screenSize = MediaQuery.of(context).size;
              isPortrait = orientation == Orientation.portrait;
              return _renderBody(screenSize);
            },
          ),
        ),
      ),
    );
  }

  Widget _renderBody(Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ANNPlayer(
          videoUrl: widget.videoUrl,
          width: screenSize.width,
          height: screenSize.height,
          isPortrait: isPortrait,
          playCallback: (isPlaying) {
            if (isPlaying) {
              readyPlayVideo = true;
            }
          },
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////////
  //--------------------------------- Other of Screen ------------------------------//
  Future<bool> fullscreenPressed(bool isFullscreen) async {
    isUserForceScreenMode = true;
    if (isPortrait) {
      if (Platform.isIOS) {
        try {
          await OrientationControl.forceLanscapeRightIOS();
        } on PlatformException {
          debugPrint('[VideoPlaying] forcePortraitIOS');
        }
      }
      screenStreamController.sink.add(true);
      isPortrait = false;
      await SystemChrome.setEnabledSystemUIOverlays([]);
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
      return true;
    } else {
      if (Platform.isIOS) {
        try {
          await OrientationControl.forcePortraitIOS();
        } on PlatformException {
          debugPrint('[VideoPlaying] forcePortraitIOS');
        }
      }
      screenStreamController.sink.add(false);
      await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      isPortrait = true;
      await SystemChrome.setPreferredOrientations(
        const [DeviceOrientation.portraitUp],
      );
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    if (isPortrait) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      return true;
    }
    await fullscreenPressed(!isPortrait);
    return false;
  }
}
