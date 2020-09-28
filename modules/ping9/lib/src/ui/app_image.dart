import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

// ignore: must_be_immutable
class AppImage extends StatelessWidget {
  String url;
  BoxFit fit;
  bool showLoading;
  static String imageDomain = "http://backend.xuongann.com";

  AppImage(this.url, {fit = BoxFit.cover, showLoading = true}) {
    this.url = AppImage.getUrl(this.url);
    this.fit = fit;
    this.showLoading = showLoading;
  }

  @override
  Widget build(BuildContext context) {
    return _buildCachedImage();
  }

  static String getUrl(String url) {
    var reg =
        new RegExp(r"^(?<domain>(http|https):\/\/([\w]+.)?[\w]+\.[\w]+)?\/.+$");

    // Trường hợp url không đúng định dạng
    if (!reg.hasMatch(url)) {
      return url;
    } else {
      var match = reg.firstMatch(url);
      var domain = match.namedGroup("domain");

      if (domain != null)
        return url;
      else
        return AppImage.imageDomain + url;
    }
  }

  _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: showLoading
          ? (context, url) {
              return Center(
                child: Indicator(),
              );
            }
          : null,
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
