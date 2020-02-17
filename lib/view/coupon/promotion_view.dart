import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/view/coupon/all_promotion_tap.dart';
import 'package:ann_shop_flutter/view/coupon/my_coupon_tap.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionView extends StatefulWidget {
  @override
  _PromotionViewState createState() => _PromotionViewState();
}

class _PromotionViewState extends State<PromotionView> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Khuyến mãi'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const <Widget>[
                  Tab(text: 'Các chương trình'),
                  Tab(text: 'Khuyến mãi của tôi'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [AllPromotionTap(), MyCouponTap()],
              ),
            ),
          ],
        )
      ),
    );
  }
}
