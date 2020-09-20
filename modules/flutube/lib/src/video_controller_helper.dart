class VideoControllerHelper {
  Function() pause;
  Function() play;
  Future<bool> Function(bool) fullscreenPressedCallback;
  Function(bool) showControlCallback;

  static final VideoControllerHelper instance =
      VideoControllerHelper._internal();

  factory VideoControllerHelper() => instance;

  VideoControllerHelper._internal();
}
