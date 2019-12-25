import 'package:ann_shop_flutter/model/product/product.dart';
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
      ),
      child: Text(
        ProductRepository.instance.getBadgeName(badge),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
