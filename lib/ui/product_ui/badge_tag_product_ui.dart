import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:flutter/material.dart';

class BadgeTagProductUI extends StatelessWidget {
  BadgeTagProductUI(this.badge);

  final badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: getBadgeColor(badge),
      ),
      child: Text(
        getBadgeName(badge),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  String getBadgeName(badge) {
    switch (badge) {
      case 1:
        return 'Có sẳn';
        break;
      case 2:
        return 'Order';
        break;
      case 3:
        return 'Sale';
        break;
      default:
        return 'Hết hàng';
        break;
    }
  }

  Color getBadgeColor(badge) {
    switch (badge) {
      case 1:
        return Colors.orange;
        break;
      case 2:
        return Colors.purple;
        break;
      case 3:
        return Colors.grey;
        break;
      default:
        return Colors.grey[700];
        break;
    }
  }
}
