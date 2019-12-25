import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeListBanner extends StatelessWidget {
  HomeListBanner({this.title, this.data});

  final List<Cover> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (Utility.isNullOrEmpty(data) == false) {
      List<Widget> children = [
        Container(
          height: 10,
          color: AppStyles.dividerColor,
        )
      ];
      children.add(
        Container(
          height: 60,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: Theme.of(context).textTheme.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      children.addAll(data
          .map((banner) => Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: AppImage(
                    banner.image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ))
          .toList());

      return SliverList(
        delegate: SliverChildListDelegate(
          children,
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }
}
