import 'dart:math';

import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/ui/inapp/blog_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListPost extends StatefulWidget {
  @override
  _HomeListPostState createState() => _HomeListPostState();
}

class _HomeListPostState extends State<HomeListPost> {
  final int limit = 4;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<CoverProvider>(context).postsHome.data;

    if (isNullOrEmpty(data) == false) {
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
          Navigator.pushNamed(context, 'blog');
        },
      ));
      return SliverList(delegate: SliverChildListDelegate(children));
    } else {
      return SliverToBoxAdapter();
    }
  }
}
