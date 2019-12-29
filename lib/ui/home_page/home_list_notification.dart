import 'dart:math';

import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/inapp/blog_item.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/block_shadow.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_view_more.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListNotification extends StatefulWidget {
  @override
  _HomeListNotificationState createState() => _HomeListNotificationState();
}

class _HomeListNotificationState extends State<HomeListNotification> {
  final int limit = 3;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<CoverProvider>(context).notificationHome.data;

    if (Utility.isNullOrEmpty(data) == false) {
      int length =
          (limit == null || limit <= 0) ? data.length : min(limit, data.length);
      List<Widget> children = [
        Container(
          height: 10,
          color: AppStyles.dividerColor,
        ),
      ];

      for (int i = 0; i < length; i++) {
        children.add(BlogItem(data[i]));
        children.add(Container(height: 1,color: AppStyles.dividerColor,));
      }
      children.add(BottomViewMore(
        onPressed: () {
          Provider.of<NavigationProvider>(context)
              .switchTo(PageName.notification.index);
        },
      ));
      return SliverList(delegate: SliverChildListDelegate(children));
    } else {
      return SliverToBoxAdapter();
    }
  }
}
