import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  AppImage(this.url, {this.fit = BoxFit.cover, this.showLoading = false});

  final String url;
  final BoxFit fit;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      enableMemoryCache: true,
      fit: fit,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            if (this.showLoading) {
              return Container(
                alignment: Alignment.center,
                child: UIManager.defaultIndicator(),
              );
            } else {
              return Container();
            }
            break;
          case LoadState.failed:
            return IconButton(
              icon: Icon(Icons.error_outline),
              onPressed: () {
                state.reLoadImage();
              },
            );
            break;
          default:
            return null;
            break;
        }
      },
    );
  }
}
