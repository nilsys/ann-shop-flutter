import 'dart:typed_data';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/main.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DownloadImageProvider extends ChangeNotifier {
  List<String> _images;

  List<String> get images => _images;

  bool downloadImages(List<String> images) {
    if(_images!=null){
      return false;
    }else {
      _images = images;
      if (Utility.isNullOrEmpty(images) == false) {
        countFail = 0;
        _saveImage(0);
      }
      return true;
    }
  }

  int index = 0;
  int countFail;

  String get currentMessage =>
      images != null ? 'Đang tải $index/${images.length}' : null;

  _saveImage(_index) async {
    index=_index;
    if (_index >= images.length) {
      AppSnackBar.showHighlightTopMessage(MyApp.context,
          'Tải thành công ${images.length - countFail}/${images.length} hình');
      _images = null;
      notifyListeners();
      return;
    }
    try {
      notifyListeners();
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + images[_index])
          .timeout(Duration(seconds: 10));
      print(file.path);
      Uint8List bytes = file.readAsBytesSync();
      await ImageGallerySaver.saveImage(bytes).timeout(Duration(seconds: 5));
      print('Save ${_index + 1}/${images.length}');
    } catch (e) {
      countFail++;
      print('Load fail: ' + e.toString());
    }
    _saveImage(_index + 1);
  }
}