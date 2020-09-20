import 'dart:async';

abstract class PlayControlDelegate {
  bool playVideo (bool isLive);
  Future<bool> fullscreen (bool isFullscreen);
  Function() downloadVideo;
  Function() replay;
  bool showControl (bool isShow);
}
