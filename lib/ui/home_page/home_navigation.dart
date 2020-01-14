import 'dart:ui';

import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/router.dart';
import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(width: 2, color: AppStyles.dividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RoundedButton(
            title: 'Kiểm tra giá',
            onItemTapped: () {
              Router.scanBarCode(context);
            },
            icon: AppIcons.qrcode,
            color: Colors.blue,
          ),
          RoundedButton(
            title: 'Đơn hàng',
            onItemTapped: () {
              Navigator.pushNamed(context, '/order-management');
            },
            icon: Icons.description,
            color: Colors.blueAccent,
          ),
          RoundedButton(
            title: 'Khuyến mãi',
            onItemTapped: () {
              Provider.of<InAppProvider>(context).currentCategory = 'promotion';
              Provider.of<NavigationProvider>(context)
                  .switchTo(PageName.notification.index);
            },
            icon: Icons.local_atm,
            color: Colors.red,
          ),
          RoundedButton(
            title: 'Chính sách',
            onItemTapped: () {
              Navigator.pushNamed(context, '/shop-policy');
            },
            icon: Icons.question_answer,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final GestureTapCallback onItemTapped;

  RoundedButton(
      {this.color = Colors.white,
      @required this.icon,
      @required this.title,
      @required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onItemTapped,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  color.withAlpha(200),
                  color,
                  color.withAlpha(180)
                ]),
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: new Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    offset: Offset(1.0, 2.0),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            this.title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
