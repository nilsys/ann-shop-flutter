import 'package:video_player/video_player.dart';

class VideoHelper {
  static final _instance = VideoHelper._internal();

  static VideoHelper get instance => _instance;

  VideoHelper._internal();

  VideoPlayerController _currentController;

  VideoPlayerController get currentController => _currentController;

  void setCurrentController(VideoPlayerController _controller) {
    if (this._currentController != null &&
        (this._currentController?.value?.isPlaying ?? false) &&
        this._currentController != _controller) {
      this._currentController?.pause();
      print("pause");
    }
    _currentController = _controller;
  }
}

class StatePlaying {
  static StatePlaying instance;

  String idPlaying;
  int hashCodeWidget;

  factory StatePlaying() {
    return instance ??= StatePlaying._internal();
  }

  StatePlaying._internal();
}

enum FlutubeState { ON, OFF }
enum FlutubeStateScreen { NEW, OLD, SPECIAL }

class StatePlayer {
  static StatePlayer instance;

  FlutubeState statePlayer;
  FlutubeStateScreen stateScreen;

  factory StatePlayer() {
    return instance ??= StatePlayer._internal();
  }

  StatePlayer._internal();
}
