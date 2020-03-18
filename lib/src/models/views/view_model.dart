import 'package:quiver/strings.dart';
import 'package:sprintf/sprintf.dart';

class ViewModel {
  String title;
  String content;
  DateTime createDate;
  String postContent;
  List<String> images;

  ViewModel.formJson(Map<String, dynamic> json) {
    this.title = json['title'] ?? '';
    this.content = json['content'] ?? '';
    this.createDate = DateTime.parse(json['createdDate']) ?? DateTime.now();

    if (!isEmpty(this.content)) {
      this.images = _imageFilter(this.content);
      this.postContent = content.replaceAll(new RegExp(r'<[^>]*>'), '');
    } else {
      this.postContent = '';
      this.images = [];
    }
  }

  List<String> _imageFilter(String content) {
    var source = sprintf(
        '<img[^>]*(%s)|(%s)[^>]*>', ["src='([^\']*)'", 'src=\"([^\"]*)\"']);
    var regImg = new RegExp(source);
    var matches = regImg.allMatches(content);
    var images = new List<String>();

    matches.forEach((RegExpMatch element) {
      var url = element.group(4);

      if (!isEmpty(url)) images.add(url);
    });

    return images;
  }
}
