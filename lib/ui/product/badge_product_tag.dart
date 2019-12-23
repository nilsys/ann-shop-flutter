import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:flutter/material.dart';

class BadgeProductTag extends StatelessWidget {
  BadgeProductTag(this.badge);

  final badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Product.getBadgeColor(badge),
      ),
      child: Text(
        Product.getBadgeName(badge),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
