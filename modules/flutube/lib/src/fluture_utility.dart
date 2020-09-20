


import 'package:screen/screen.dart';

const double kRatioVideo = 16 / 9;


String videoThumbURL(String yt) {
  String id = yt.substring(yt.indexOf('v=') + 2);
  if (id.contains('&')) id = id.substring(0, id.indexOf('&'));
  return "http://img.youtube.com/vi/$id/0.jpg";
}


void screenKeepOn(bool isKeepOn) {
  Screen.keepOn(isKeepOn);
}