import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class MyVideo {
  String url;
  String thumbnail;
  int width;
  int height;

  static double defaultRatio = 16 / 9;

  double get ratio {
    if (width != null && height != null) {
      return width / height;
    }
    return defaultRatio;
  }

  MyVideo(this.url, this.thumbnail);

  static List<String> parseToListString(List<MyVideo> videos) {
    if (isNullOrEmpty(videos)) {
      return [];
    }
    List<String> urls = [];
    for (final item in videos) {
      urls.add(item?.url);
    }
    return urls;
  }

  MyVideo.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
