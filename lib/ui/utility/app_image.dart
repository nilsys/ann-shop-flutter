import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  AppImage(this.url, {this.fit = BoxFit.cover, this.showLoading = true});

  final String url;
  final BoxFit fit;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return _buildCachedImage();
  }

  _buildExtendedImage() {
//    return ExtendedImage.network(
//      url,
//      enableMemoryCache: true,
//      fit: fit,
//      loadStateChanged: (ExtendedImageState state) {
//        switch (state.extendedImageLoadState) {
//          case LoadState.loading:
//            if (this.showLoading) {
//              return Container(
//                alignment: Alignment.center,
//                child: Indicator(),
//              );
//            } else {
//              return Container();
//            }
//            break;
//          case LoadState.failed:
//            return IconButton(
//              icon: Icon(Icons.error_outline),
//              onPressed: () {
//                state.reLoadImage();
//              },
//            );
//            break;
//          default:
//            return null;
//            break;
//        }
//      },
//    );
  }

  _buildCachedImage() {
    var fullUrl = url.contains('http') ? url : (Core.domain + url);
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
