import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSpam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CoverProvider provider = Provider.of(context);
    if (Utility.isNullOrEmpty(provider.spam.data) == false) {
      List<Cover> data = provider.spam.data;

      List<Widget> children = [Container(height: 10,color: AppStyles.dividerColor,)];
      children.add(Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        alignment: Alignment.centerLeft,
        child: Text(
          'Thông báo',
          style: Theme.of(context).textTheme.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),);
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
