import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';

class BadgeTagProductUI extends StatelessWidget {
  BadgeTagProductUI(this.badge);

  final badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ProductRepository.instance.getBadgeColor(badge),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(5))
      ),
      child: Text(
        ProductRepository.instance.getBadgeName(badge),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
