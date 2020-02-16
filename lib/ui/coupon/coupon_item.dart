import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/coupon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CouponItem extends StatelessWidget {
  const CouponItem(this.item);

  final Coupon item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(bottom: 5),
          alignment: Alignment.centerLeft,
          child: Text(item.code, style: Theme.of(context).textTheme.title),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.timer,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(Utility.fixFormatDate(item.endDate))
          ],
        ),
        leading: Container(
            width: 30,
            alignment: Alignment.center,
            child: Icon(MaterialCommunityIcons.ticket_percent)),
      ),
    );
  }
}
