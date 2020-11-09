import 'dart:io';
import 'dart:typed_data';
import 'package:ping9/ping9.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class GallerySaverHelper {
  factory GallerySaverHelper() => instance;

  GallerySaverHelper._internal();

  static final GallerySaverHelper instance = GallerySaverHelper._internal();

  Future<File> downLoadFile(String url) async {
    var file = await DefaultCacheManager()
        .getSingleFile(checkLink(url))
        .timeout(Duration(minutes: 5));
    return file;
    // Uint8List bytes = file.readAsBytesSync();
  }

  Future saveImage(String url) async {
    final File file = await downLoadFile(url);
    Uint8List bytes = file.readAsBytesSync();
    await ImageGallerySaver.saveImage(bytes).timeout(Duration(seconds: 5));
  }
  Future saveImageByByte(Uint8List bytes) async {
    await ImageGallerySaver.saveImage(bytes).timeout(Duration(seconds: 5));
  }


    Future saveVideo(String url) async {
    final File file = await downLoadFile(url);
    // await GallerySaver.saveVideo(file.path, albumName: "ANN").timeout(Duration(seconds: 30));
    await ImageGallerySaver.saveFile(file.path).timeout(Duration(seconds: 5));
  }

  String checkLink(String name) {
    if (name.contains("http")) {
      return name;
    }
    return "${AppImage.imageDomain}$name";
  }
}
