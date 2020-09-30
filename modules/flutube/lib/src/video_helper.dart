import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';


class VideoHelper{

  static final _instance = VideoHelper._internal();

  static VideoHelper get instance => _instance;

  VideoHelper._internal();

  VideoPlayerController videoController;


  void initialize(VideoPlayerController controller){
    dispose();
    videoController = controller;
    Wakelock.enable();
  }

  void dispose(){
    if (videoController?.value?.isPlaying ?? false) {
      this.videoController.pause();
    }
    this.videoController?.dispose();
    this.videoController = null;
    Wakelock.disable();
  }
}