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
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 10),
            child: RaisedButton(
              onPressed: _showInformBeforeRate,
              child: const Text(
                'Review ANN để nhận ưu đãi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInformBeforeRate() {
    AppPopup.showBottomSheet(context, title: 'Đánh giá ứng dụng', content: [
      const SizedBox(height: 20),
      Text(
        'Nhận ưu đãi khi đánh giá ANN app trên ${Platform.isIOS ? 'App Store' : 'Google Play'}',
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10),
      Text(
        'Vui lòng gửi hình chụp màn hình đánh giá của bạn cho chúng tôi, để bạn có thể nhận được ưu đãi này',
        style: Theme.of(context).textTheme.body1,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10),
      CenterButtonPopup(
        normal: ButtonData('Đánh giá ngay', onPressed: () {
          launch(Core.urlStoreReview);
        }),
        highlight: ButtonData('Đăng hình đánh giá', onPressed: () {
          Navigator.popAndPushNamed(context, '/upload_photo');
        }),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
