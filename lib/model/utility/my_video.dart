import 'package:ping9/ping9.dart';

class MyVideo {
  String url;
  String thumbnail;

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
