import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    bool isLogin = false;
    return Scaffold(
      backgroundColor: AppStyles.dividerColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cá nhân'),
        actions: <Widget>[
          FavoriteButton(color: Colors.white),
        ],
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Core.isLogin ? _buildAccount() : _buildNoLogin(),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 12),
                _buildItemCommon('Quản lý đơn hàng',
                    icon: Icon(Icons.description), onTap: () {
                  if (Core.isLogin) {
                    Navigator.pushNamed(context, '/order-management');
                  } else {
                    _showLoginBottomSheet();
                  }
                }),
                _buildItemCommon('Sản phẩm đã xem',
                    icon: Icon(Icons.remove_red_eye), onTap: () {
                  Navigator.pushNamed(context, '/seen');
                }),
                _buildItemCommon('Sản phẩm yêu thích',
                    icon: Icon(Icons.favorite), onTap: () {
                  Navigator.pushNamed(context, '/favorite');
                }),
                _buildItemCommon('Thông báo', icon: Icon(Icons.notifications),
                    onTap: () {
                  Navigator.pushNamed(context, '/notification');
                }),
                _buildItemCommon('Liên hệ', icon: Icon(Icons.headset_mic),
                    onTap: () {
                  Navigator.pushNamed(context, '/shop-contact');
                }),
                _buildItemCommon('Cài đặt', icon: Icon(Icons.settings),
                    onTap: () {
                  Navigator.pushNamed(context, '/setting');
                }),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 12),
                _buildItemCommon('Giới thiệu', onTap: () {
                  Navigator.pushNamed(context, '/file-view', arguments: {
                    'url': 'assets/offline/ann_intro.html',
                    'name': 'Xưởng sỉ ANN'
                  });
                }),
                _buildItemCommon('Hướng dẫn mua sỉ', onTap: () {
                  Navigator.pushNamed(context, '/file-view', arguments: {
                    'url': 'assets/offline/ann_wholesale.html',
                    'name': 'Hướng dẫn mua sỉ'
                  });
                }),
                _buildItemCommon('Chính sách vận chuyển', onTap: () {
                  Navigator.pushNamed(context, '/file-view', arguments: {
                    'url': 'assets/offline/ann_policy_delivery.html',
                    'name': 'Chính sách vận chuyển'
                  });
                }),
                _buildItemCommon('Chính sách thanh toán', onTap: () {
                  Navigator.pushNamed(context, '/file-view', arguments: {
                    'url': 'assets/offline/ann_policy_payment.html',
                    'name': 'Chính sách thanh toán'
                  });
                }),
                _buildItemCommon('Chính sách đổi trả', onTap: () {
                  Navigator.pushNamed(context, '/file-view', arguments: {
                    'url': 'assets/offline/ann_policy_refund.html',
                    'name': 'Chính sách đổi trả'
                  });
                }),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCommon(String title, {Icon icon, GestureTapCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: icon,
        title: Text(title),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: AppStyles.dividerColor),
      ),
    );
  }

  Widget _buildAccount() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/add-information');
      },
      child: Container(
        height: 80,
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Chào mừng bạn đến với Xưỡng ANN',
                      style: Theme.of(context).textTheme.caption,
                      maxLines: 1,
                    ),
                    Text(
                      'Ping Ping',
                      style: Theme.of(context).textTheme.body2.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    )
                  ],
                ),
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoLogin() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        height: 80,
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Chào mừng bạn đến với Xưỡng ANN',
                      style: Theme.of(context).textTheme.caption,
                      maxLines: 1,
                    ),
                    Text(
                      'Đăng nhập/Đăng ký',
                      style: Theme.of(context).textTheme.body2.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    )
                  ],
                ),
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  _showLoginBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return AskLogin(
            'Vui lòng đăng nhập hoặc đăng ký để xem đơn hàng của bạn tại XuongAnn');
      },
    );
  }

  _onLaunchURL() {
    if (Platform.isIOS) {
      launch("tel:/1800555555");
    } else {
      launch("tel:1800555555");
    }
  }
}
