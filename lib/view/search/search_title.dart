import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/src/configs/route.dart';
import 'package:ann_shop_flutter/src/models/ann_page.dart';

import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class SearchTitle extends StatelessWidget {
  SearchTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routes.navigateHome(context, ANNPage.search);
      },
      child: Container(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppStyles.searchColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              AppIcons.search,
              size: 20,
              color: AppStyles.iconSearchColor,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 1,
              child: Text(
                text ?? 'Bạn tìm gì hôm nay?',
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
