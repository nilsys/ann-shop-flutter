import 'package:ann_shop_flutter/core/config.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  final height = 120.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: height / 2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ExtendedImage.network(
                'https://khohangsiann.com/wp-content/uploads/si-bao-li-xi-2020.png',
                enableMemoryCache: true,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
