import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/main.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'gallery_saver_helper.dart';

class DownloadImageProvider extends ChangeNotifier {
  List<String> _images;

  List<String> get images => _images;

  Future<bool> downloadImages(List<String> images) async {
    if (_images == null) {
      _images = images;
      if (isNullOrEmpty(images) == false) {
        countFail = 0;
        _saveImage(0);
      }
      return true;
    }
    return false;
  }

  Future<bool> downloadVideos(List<String> urls) async {
    if (_images == null) {
      _images = urls;
      countFail = 0;
      _saveVideo(0);
      return true;
    }
    return false;
  }

  int index = 0;
  int countFail;

  String get currentMessage =>
      images != null ? 'Đang tải $index/${images.length}' : null;

  _saveImage(_index) async {
    index = _index;
    if (_index >= images.length) {
      AppSnackBar.showHighlightTopMessage(MyApp.context,
          'Tải thành công ${images.length - countFail}/${images.length} hình');
      _images = null;
      notifyListeners();
      return;
    }
    try {
      notifyListeners();
      await GallerySaverHelper.instance.saveImage(_images[index]);

    } catch (e) {
      countFail++;
      print(e);
    }
    _saveImage(_index + 1);
  }

  // todo: update download video
  _saveVideo(_index) async {
    index = _index;
    if (_index >= images.length) {
      AppSnackBar.showHighlightTopMessage(MyApp.context,
          'Tải thành công ${images.length - countFail}/${images.length} video');
      _images = null;
      notifyListeners();
      return;
    }
    try {
      notifyListeners();
      await GallerySaverHelper.instance.saveVideo(_images[index]);
    } catch (e) {
      countFail++;
      print(e);
    }
    _saveVideo(_index + 1);
  }

  String checkLink(String name) {
    if (name.contains("http")) {
      return name;
    }
    return "${AppImage.imageDomain}$name";
  }
}


