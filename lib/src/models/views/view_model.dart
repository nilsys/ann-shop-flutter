import 'package:flutube/src/models/my_video.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiver/strings.dart';
import 'package:sprintf/sprintf.dart';

class ViewModel {
  int id;
  String title;
  String content;
  DateTime createDate;
  String postContent;
  List<String> images;
  List<MyVideo> videos;

  ViewModel.formJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'] ?? '';
    this.content = json['content'] ?? '';

    if (json['videos'] != null) {
      videos = [];
      json['videos'].forEach((v) {
        videos.add(MyVideo.fromJson(v));
      });
    }

    if (!isEmpty(this.content)) {
      this.images = _imageFilter(this.content);
      this.postContent = _createPostContent(content);
    } else {
      this.postContent = '';
      this.images = [];
    }
  }

  List<String> _imageFilter(String content) {
    var source = sprintf('(<img[^>]*%s[^>]*>)|(<img[^>]*%s[^>]*>)',
        ["src='([^\']*)'", 'src=\"([^\"]*)\"']);
    var regImg = new RegExp(source);
    var matches = regImg.allMatches(content);
    var images = new List<String>();

    matches.forEach((RegExpMatch element) {
      var url = element.group(4);

      if (!isEmpty(url)) images.add(url);
    });

    return images;
  }

  String _createPostContent(String content) {
    var unescape = HtmlUnescape();
    var postContent = content;

    // convert the br tag to newline
    postContent = postContent.replaceAll(new RegExp(r'<br\s*/?>'), '\r\n');
    // convert the p tag to newline
    postContent = postContent.replaceAll('</p>', '\r\n\r\n');
    // remove tag at the bottom
    postContent = postContent.replaceAll(new RegExp(r'\r\n<[^>]*>'), '');
    // remove all tag in html
    postContent = postContent.replaceAll(new RegExp(r'<[^>]*>'), '');
    // decode html
    postContent = unescape.convert(postContent);

    return postContent;
  }
}
