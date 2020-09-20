import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../flutube.dart';

enum StateControl { INIT, ACTIVE, DONE }
enum StateActionPlayer { FAST_FORWARD, FAST_REWIND }
enum StateDoubleTap { LEFT, RIGHT, NONE }

typedef YoutubeQualityChangeCallback(String quality, Duration position);

const double kSizeIcon = 32;
const double kSizePlayIcon = 40;
const IconData kIconDownload = Icons.file_download;
const IconData kIconReplay = Icons.replay;
const IconData kIconPlay = Icons.play_arrow;
const IconData kIconPause = Icons.pause;
const IconData kIconForward5 = Icons.forward_5;
const IconData kIconReplay5 = Icons.replay_5;
const TextStyle textStyleTime = TextStyle(
  color: Colors.white,
  fontSize: 10.0,
);

class ControlsColor {
  final Color timerColor;
  final Color seekBarPlayedColor;
  final Color seekBarUnPlayedColor;
  final Color buttonColor;
  final Color playPauseColor;
  final Color progressBarPlayedColor;
  final Color progressBarBackgroundColor;
  final Color controlsBackgroundColor;

  ControlsColor({
    this.buttonColor = Colors.white,
    this.playPauseColor = Colors.white,
    this.progressBarPlayedColor = Colors.red,
    this.progressBarBackgroundColor = Colors.transparent,
    this.seekBarUnPlayedColor = Colors.grey,
    this.seekBarPlayedColor = Colors.red,
    this.timerColor = Colors.white,
    this.controlsBackgroundColor = Colors.transparent,
  });
}

class Controls extends StatefulWidget {
  final bool showControls;
  final double width;
  final double height;
  final String defaultQuality;
  final bool defaultCall;
  final bool controlsActiveBackgroundOverlay;
  final Duration controlsTimeOut;
  final bool switchFullScreenOnLongPress;
  final bool hideShareButton;
  final bool isErrorVideo;
  final String urlImageThumnail;

  PlayControlDelegate playCtrDelegate;
  bool isFullScreen;

  Controls(
      {this.showControls,
      this.width,
      this.height,
      this.defaultQuality = "720p",
      this.defaultCall,
      this.controlsActiveBackgroundOverlay,
      this.controlsTimeOut,
      this.switchFullScreenOnLongPress,
      this.hideShareButton,
      this.urlImageThumnail,
      this.playCtrDelegate,
      this.isFullScreen,
      this.isErrorVideo = false});

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  //---------------------------------------------------------
  //-----------------------Variable--------------------------
  //---------------------------------------------------------
  bool _showControls;
  StateDoubleTap _stateDoubleTap;
  Timer _timer;
  Timer _timerDoubleTap;
  CallBackVideoController _callbackController;
  VideoPlayerController _videoController;
  EventControl _eventControl;
  StateControl _stateControl;
  double _currentPosition = 0;
  String _currentPositionString = "00:00";
  String _remainingString = "00:00";
  bool _flagAddListener = false;
  bool _isShowSub = true;
  bool _isShowIconFast;
  bool _isError;

  //---------------------------------------------------------
  //-----------------------Function of root------------------
  //---------------------------------------------------------

  @override
  void initState() {
    super.initState();
    print("[control.dart][initState] init");
    _stateControl = StateControl.INIT;
    _eventControl = EventControl();
    _eventControl.play = playVideo;
    _showControls = widget.showControls ?? true;
    _stateDoubleTap = StateDoubleTap.NONE;
    _isShowIconFast = false;
    _isError = widget.isErrorVideo;

    _callbackController = CallBackVideoController();
    _callbackController.callback = (_controller) {
      if (_controller != null && _controller.value.initialized && mounted) {
        setState(() {
          _videoController = _controller;
          if (!_flagAddListener) {
            _stateControl = StateControl.ACTIVE;
            _flagAddListener = true;
            _videoController.addListener(listenerControls);
            onTapAction();
          }
        });
      }
    };
    widget.playCtrDelegate.showControl(_showControls);
    _callbackController.listenStateError = (stateError) {
      setState(() {
        _isError = stateError;
      });
    };
  }

  @override
  void deactivate() {
    print("[control.dart]----------------deactive----------------");
    if (_videoController != null && _videoController.value.initialized) {
      _videoController.removeListener(listenerControls);
      _videoController = null;
    }
    if (StatePlayer.instance.stateScreen == FlutubeStateScreen.SPECIAL) {
      StatePlayer.instance.statePlayer = FlutubeState.OFF;
    }
    super.deactivate();
  }

  @override
  void dispose() {
    print("[control.dart]----------------dispose----------------");
    if (_videoController != null && _videoController.value.initialized) {
      _videoController.removeListener(listenerControls);
      _videoController = null;
    }
    _stateControl = StateControl.DONE;
    super.dispose();
  }

  //---------------------------------------------------------
  //-----------------------Function Callback-----------------
  //---------------------------------------------------------
  playVideo() {
    if (_stateControl == StateControl.ACTIVE) {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    }
  }

  listenerControls() async {
    if (_videoController != null && _videoController.value.initialized) {
      if (_videoController.value.position != null &&
          _videoController.value.duration != null) {
        if (_videoController.value.isPlaying) {
          updateTimePostion();
        }
      } else {
        _stateControl = StateControl.DONE;
      }
    } else {
      _stateControl = StateControl.INIT;
    }
  }

  updateTimePostion() {
    setState(() {
      if ((_videoController.value.duration.inMilliseconds - 600) <=
          _videoController.value.position.inMilliseconds) {
        _videoController.pause();
        _showControls = true;
        _stateControl = StateControl.DONE;
      }

      _currentPosition = (_videoController.value.position.inSeconds ?? 0) /
          _videoController.value.duration.inSeconds;
      _currentPositionString = formatDuration(_videoController.value.position);
      _remainingString = formatDuration(
          _videoController.value.duration - _videoController.value.position);
    });
  }

  //---------------------------------------------------------
  //-----------------------Function Render ------------------
  //---------------------------------------------------------

  //-----------------------Render BUILD----------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        (_stateControl != StateControl.ACTIVE)
            ? _isError
                ? Container(
                    color: Colors.black,
                    width: widget.width,
                    height: widget.height,
                    child: Center(
                      child: Text(
                        "Error loading video!",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ))
                : CachedNetworkImage(
                    imageUrl: widget.urlImageThumnail ?? "",
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.cover,
                  )
            : SizedBox(),
        _renderAreaOfActionDoubleTap(),
        GestureDetector(
          onTap: () {
            tapLayout();
          },
          child: AnimatedOpacity(
            opacity: (_showControls || _stateControl != StateControl.ACTIVE)
                ? 1.0
                : 0.0,
            duration: Duration(milliseconds: 300),
            child: Material(
              color: Color(0x88000000),
              child: Stack(
                children: <Widget>[
                  (_showControls || _stateControl != StateControl.ACTIVE)
                      ? Stack(
                          children: <Widget>[
                            Container(
                              width: widget.width,
                              height: widget.height,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: _fastRewind(),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: _playButton(),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: _fastForward(),
                                      flex: 4,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            _buildBottomControls(),
                            Positioned(
                              child: _buildAppBar(context),
                              top: 0,
                              left: 0,
                              right: 0,
                            )
                          ],
                        )
                      : Container(
                          width: widget.width,
                          height: widget.height,
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      tapLayout();
                                    },
                                    onDoubleTap: () {
                                      actionFastForwardAndRewind(
                                        stateActionPlayer:
                                            StateActionPlayer.FAST_REWIND,
                                        isStateDoubleTap: StateDoubleTap.LEFT,
                                        isShowIconFast: true,
                                      );
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      tapLayout();
                                    },
                                    onDoubleTap: () {
                                      actionFastForwardAndRewind(
                                          stateActionPlayer:
                                              StateActionPlayer.FAST_FORWARD,
                                          isStateDoubleTap:
                                              StateDoubleTap.RIGHT,
                                          isShowIconFast: true);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

//-----------------------Render app bar----------------------
  Widget _buildAppBar(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
          ),
          IconButton(
            onPressed: () {
              if (_stateControl != StateControl.INIT &&
                  widget.playCtrDelegate != null &&
                  mounted) {
                setState(() {
                  _isShowSub = widget.playCtrDelegate.downloadVideo();
                });
              }
            },
            icon: Icon(kIconDownload, color: Colors.white70, size: kSizeIcon),
          )
        ],
      ),
    );
  }

//-----------------------Render fastforward----------------------
  Widget _fastForward() {
    return Stack(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              onTapAction(isShowControl: false);
            },
            onDoubleTap: () {
              actionFastForwardAndRewind(
                  stateActionPlayer: StateActionPlayer.FAST_FORWARD,
                  isStateDoubleTap: StateDoubleTap.RIGHT);
            },
            child: Container(
              color: Colors.transparent,
            )),
        (_stateControl != StateControl.INIT)
            ? Center(
                child: IconButton(
                  onPressed: () {
                    actionFastForwardAndRewind(
                        stateActionPlayer: StateActionPlayer.FAST_FORWARD,
                        isStateDoubleTap: StateDoubleTap.RIGHT);
                  },
                  icon: const Icon(kIconForward5,
                      color: Colors.white70, size: kSizeIcon),
                ),
              )
            : SizedBox(),
      ],
    );
  }

//-----------------------Render fastrewind----------------------
  Widget _fastRewind() {
    return Stack(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              onTapAction(isShowControl: false);
            },
            onDoubleTap: () {
              actionFastForwardAndRewind(
                  stateActionPlayer: StateActionPlayer.FAST_REWIND,
                  isStateDoubleTap: StateDoubleTap.LEFT);
            },
            child: Container(
              color: Colors.transparent,
            )),
        (_stateControl != StateControl.INIT)
            ? Center(
                child: IconButton(
                  onPressed: () {
                    actionFastForwardAndRewind(
                        stateActionPlayer: StateActionPlayer.FAST_REWIND,
                        isStateDoubleTap: StateDoubleTap.LEFT);
                  },
                  icon: const Icon(kIconReplay5,
                      color: Colors.white70, size: kSizeIcon),
                ),
              )
            : SizedBox()
      ],
    );
  }

//-----------------------Render button middle----------------------
  Widget _playButton() {
    return (_stateControl != StateControl.INIT)
        ? Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                if (_stateControl != StateControl.INIT) {
                  if (widget.playCtrDelegate != null) {
                    if (_stateControl == StateControl.ACTIVE) {
                      bool oldStateLive = _videoController.value.isPlaying;
                      bool newStateLive = widget.playCtrDelegate
                          .playVideo(_videoController.value.isPlaying);
                      if (oldStateLive == newStateLive) {
                        playVideo();
                      }
                    } else {
                      widget.playCtrDelegate.replay();
                      _stateControl = StateControl.INIT;
                      _flagAddListener = false;
                    }
                  }
                }
                onTapAction();
              },
              child: (_stateControl == StateControl.DONE)
                  ? const Icon(
                      kIconReplay,
                      size: kSizePlayIcon,
                      color: Colors.white,
                    )
                  : ((_videoController != null &&
                          _videoController.value.initialized &&
                          _videoController.value.isPlaying)
                      ? const Icon(
                          kIconPause,
                          size: kSizePlayIcon,
                          color: Colors.white,
                        )
                      : const Icon(
                          kIconPlay,
                          size: kSizePlayIcon,
                          color: Colors.white,
                        )),
            ),
          )
        : _isError
            ? SizedBox()
            : AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
                ),
              );
  }

//-----------------------Render bottom control----------------------
  Widget _buildBottomControls() {
    return Positioned(
      bottom: 5.0,
      left: 0.0,
      child: Center(
        child: Container(
          margin:
              EdgeInsets.only(left: 20, right: widget.isFullScreen ? 50 : 20),
          width: widget.width - 20,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      _currentPositionString,
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ),
                Expanded(
                  flex: widget.isFullScreen ? 15 : 6,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    height: 20,
                    child: Slider(
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                      value: _currentPosition,
                      onChanged: (position) {
                        if (_videoController != null &&
                            _stateControl != StateControl.INIT) {
                          if ((_videoController.value.duration.inMilliseconds -
                                  700) <=
                              (position *
                                          _videoController
                                              .value.duration.inSeconds)
                                      .floor() *
                                  1000) {
                            _handleDone();
                          } else {
                            onTapAction();
                            _videoController.seekTo(Duration(
                                seconds: (position *
                                        _videoController
                                            .value.duration.inSeconds)
                                    .floor()));

                            if (!_videoController.value.isPlaying) {
                              _videoController.play();
                            }

                            if (mounted) {
                              setState(() {
                                _stateControl = StateControl.ACTIVE;
                                _currentPosition = position;
                              });
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      _remainingString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      if (widget.playCtrDelegate != null) {
                        if (mounted) {
                          setState(() async {
                            widget.isFullScreen = await widget.playCtrDelegate
                                .fullscreen(widget.isFullScreen);
                          });
                        }
                      }
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(right: widget.isFullScreen ? 20 : 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          widget.isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//-----------------------Render area fastforward and fastrewind-------------------------
  Widget _renderAreaOfActionDoubleTap() {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AnimatedOpacity(
                opacity: (_stateDoubleTap == StateDoubleTap.LEFT) ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.elliptical(40, 120),
                      bottomRight: Radius.elliptical(40, 100),
                    ),
                    color: Colors.white30,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(Icons.fast_rewind,
                              color: _isShowIconFast
                                  ? Colors.white60
                                  : Colors.transparent,
                              size: 40.0),
                        ),
                        Text(
                          "5 seconds",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
              ),
              flex: 2,
            ),
            Expanded(
              child: AnimatedOpacity(
                opacity: (_stateDoubleTap == StateDoubleTap.RIGHT) ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(40, 120),
                      bottomLeft: Radius.elliptical(40, 100),
                    ),
                    color: Colors.white30,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(Icons.fast_forward,
                              color: _isShowIconFast
                                  ? Colors.white60
                                  : Colors.transparent,
                              size: 40.0),
                        ),
                        Text(
                          "5 seconds",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              flex: 4,
            )
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------
  //-----------------------Function Handle------------------
  //---------------------------------------------------------

  onTapAction({bool isShowControl = true}) {
    if (_stateControl == StateControl.ACTIVE) {
      if (_timer != null) _timer.cancel();
      _showControls = isShowControl;
      refeshWidget();
      widget.playCtrDelegate.showControl(_showControls);
      if (_showControls) {
        _timer = Timer(widget.controlsTimeOut, () {
          _showControls = false;
          widget.playCtrDelegate.showControl(_showControls);
          refeshWidget();
        });
      }
    }
  }

  tapLayout() {
    onTapAction();
    if (_stateControl == StateControl.ACTIVE &&
        !_videoController.value.isPlaying) {
      _videoController.play();
    }
  }

  actionFastForwardAndRewind(
      {StateActionPlayer stateActionPlayer,
      StateDoubleTap isStateDoubleTap,
      isShowIconFast = false}) async {
    _isShowIconFast = isShowIconFast;
    onDoubleTap(isStateDoubleTap);

    if (mounted) {
      if (_videoController != null && _stateControl != StateControl.INIT) {
        int handle =
            (stateActionPlayer == StateActionPlayer.FAST_FORWARD) ? 5 : (-5);
        int _seconds = _videoController.value.position.inSeconds + handle;

        if ((_videoController.value.duration.inMilliseconds - 700) <=
            (_seconds * 1000)) {
          _handleDone();
        } else {
          _stateControl = StateControl.ACTIVE;
          await _videoController.seekTo(Duration(seconds: _seconds));
          if (!_videoController.value.isPlaying) {
            _videoController.play();
          }
          updateTimePostion();
          refeshWidget();
        }
      }
    }
  }

  _handleDone() {
    _videoController.pause();
    setState(() {
      StatePlayer.instance.stateScreen = FlutubeStateScreen.SPECIAL;
      _stateControl = StateControl.DONE;
      _remainingString = "00:00";
      _currentPositionString = formatDuration(_videoController.value.duration);
      _videoController.seekTo(Duration(
          milliseconds: _videoController.value.duration.inMilliseconds - 400));
      _currentPosition = 1;
    });
  }

  onDoubleTap(StateDoubleTap isStateDoubleTap) {
    if (_stateControl != StateControl.INIT) {
      if (_timerDoubleTap != null) _timerDoubleTap.cancel();
      _stateDoubleTap = isStateDoubleTap;
      refeshWidget();

      if (_stateDoubleTap != StateDoubleTap.NONE) {
        _timerDoubleTap = Timer(Duration(milliseconds: 1500), () {
          _stateDoubleTap = StateDoubleTap.NONE;
          _isShowIconFast = false;
          refeshWidget();
        });
      }
    }
  }

  refeshWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;
    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    var minutes = seconds ~/ 60;
    seconds = seconds % 60;
    final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';
    final minutesString =
        minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';
    final secondsString =
        seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';
    final formattedTime =
        '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';
    return formattedTime;
  }
}
