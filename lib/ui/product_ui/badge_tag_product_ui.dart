import 'package:ann_shop_flutter/provider/product/product_utility.dart';

import 'package:flutter/material.dart';

class BadgeTagProductUI extends StatelessWidget {
  BadgeTagProductUI(this.badge);

  final badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: ProductUtility.instance.getBadgeColor(badge),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(5))),
      child: Text(
        ProductUtility.instance.getBadgeName(badge),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
