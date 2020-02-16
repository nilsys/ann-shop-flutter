import 'dart:io';
import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/provider/utility/coupon_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dividerColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cá nhân'),
        actions: <Widget>[
          FavoriteButton(color: Colors.white),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AccountController.instance.isLogin
                ? _buildAccount()
                : _buildNoLogin(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Divider(
                height: 10,
                thickness: 10,
              ),
              _buildItemCommon('Quản lý đơn hàng',
                  icon: Icons.description, onTap: _viewOrderManagement),
              _buildItemCommon('Sản phẩm đã xem', icon: Icons.remove_red_eye,
                  onTap: () {
                Navigator.pushNamed(context, '/seen');
              }),
              _buildItemCommon('Sản phẩm yêu thích', icon: Icons.favorite,
                  onTap: () {
                Navigator.pushNamed(context, '/favorite');
              }),
              _buildItemCommon('Thông báo', icon: Icons.notifications,
                  onTap: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .switchTo(PageName.notification.index);
              }),
              _buildItemCommon('ANN Blog', icon: AppIcons.blogger, onTap: () {
                Navigator.pushNamed(context, '/blog');
              }),
              const Divider(
                height: 10,
                thickness: 10,
              ),
              _buildItemCommon('Mã khuyến mãi',
                  icon: MaterialCommunityIcons.ticket_percent, onTap: () {
                Navigator.pushNamed(context, '/promotion');
              }),
              _buildItemCommon(
                'Đánh giá ANN trên ${Platform.isIOS ? 'App Store' : 'Google Play'}',
                icon: Icons.star_border,
                onTap: () {
                  launch(Core.urlStoreReview);
                },
              ),
              _buildItemCommon('Chia sẽ ứng dụng này', icon: Icons.share,
                  onTap: () {
                Share.text(
                    Core.dynamicLinkStore, Core.dynamicLinkStore, 'text/plain');
              }),
              const Divider(
                height: 10,
                thickness: 10,
              ),
              _buildItemCommon('Liên hệ', icon: Icons.headset_mic, onTap: () {
                Navigator.pushNamed(context, '/shop-contact');
              }),
              _buildItemCommon('Chính sách bán hàng',
                  icon: Icons.question_answer, onTap: () {
                Navigator.pushNamed(context, '/shop-policy');
              }),
              _buildItemCommon('Cài đặt copy sản phẩm', icon: Icons.settings,
                  onTap: () {
                Navigator.pushNamed(context, '/setting');
              }),
              Container(
                height: 45,
                margin: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1)),
                child: InkWell(
                  onTap: () {
                    AccountController.instance.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                    Provider.of<CouponProvider>(context, listen: false)
                        .myCoupons
                        .error = 'logout';
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'ĐĂNG XUẤT',
                      style: Theme.of(context).textTheme.button.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ),
//                Container(
//                  height: 30,
//                  alignment: Alignment.centerRight,
//                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
//                  child: Text('Version: ${Core.appVersion}'),
//                )
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCommon(String title,
      {IconData icon, GestureTapCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).primaryColor,
              )
            : null,
        title: Text(title),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: Theme.of(context).dividerColor),
      ),
    );
  }

  Widget _buildAccount() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/update-information', arguments: false);
      },
      child: Container(
        height: 80,
        color: Colors.white,
        padding: const EdgeInsets.all(15),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Chào mừng bạn đến với ANN',
                      style: Theme.of(context).textTheme.body1,
                      maxLines: 1,
                    ),
                    Text(
                      AccountController.instance.account.fullName ??
                          'Cập nhật thông tin ngay!',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.display2,
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
        padding: const EdgeInsets.all(15),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Chào mừng bạn đến với ANN',
                      style: Theme.of(context).textTheme.body1,
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

  void _viewOrderManagement() {
    if (AccountController.instance.isLogin) {
      Navigator.pushNamed(context, '/order-management');
    } else {
      AskLogin.show(context,
          message:
              'Vui lòng đăng nhập hoặc đăng ký để xem đơn hàng của bạn tại XuongAnn');
    }
  }
}
