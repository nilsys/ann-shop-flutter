import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class AppImage extends StatelessWidget {
  AppImage(this.url, {this.fit = BoxFit.cover, this.showLoading = true});

  final String url;
  final BoxFit fit;
  final bool showLoading;
  final String imageDomain = "http://xuongann.com/";

  @override
  Widget build(BuildContext context) {
    return _buildCachedImage();
  }

  _buildCachedImage() {
    var fullUrl = url.contains('http') ? url : ("$imageDomain$url");
    return CachedNetworkImage(
      imageUrl: fullUrl,
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
