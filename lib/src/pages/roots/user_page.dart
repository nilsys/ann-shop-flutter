import 'dart:core';
import 'dart:io';

import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/provider/utility/coupon_provider.dart';
import 'package:ann_shop_flutter/src/models/pages/root_pages/root_page_navigation_bar.dart';
import 'package:ann_shop_flutter/src/providers/roots/root_page_provider.dart';
import 'package:ann_shop_flutter/src/route/route.dart';
import 'package:ann_shop_flutter/src/models/ann_page.dart';

import 'package:ann_shop_flutter/src/widgets/alert_dialog/alert_ask_permission.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

  //region Private
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
        trailing:
        Icon(Icons.keyboard_arrow_right, color: AppStyles.dividerColor),
      ),
    );
  }

  void _onClickPermission(BuildContext context) {
    final permission = Platform.isAndroid
        ? Permission.storage : Permission.photos;

    AlertAskPermission()
      ..setMessage(permission)
      ..show(context);
  }

  //region AppBar
  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text('Cá nhân'),
      actions: <Widget>[
        FavoriteButton(color: Colors.white),
      ],
    );
  }
  //endregion

  //region Body
  //region Account
  Widget _buildAccount(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'user/information');
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
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 1,
                    ),
                    Text(
                      AC.instance.account.fullName ??
                          'Cập nhật thông tin ngay!',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
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

  Widget _buildNoLogin(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'user/login');
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
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 1,
                    ),
                    Text(
                      'Đăng nhập/Đăng ký',
                      style: Theme.of(context).textTheme.bodyText1.merge(
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

  Widget _buildAccountBlock(BuildContext context) {
    Widget child;

    if (AC.instance.isLogin)
      child = _buildAccount(context);
    else
      child = _buildNoLogin(context);

    return SliverToBoxAdapter(child: child);
  }
  //endregion

  //region Order Info, Seen Product, Wish List, Notification, Blog
  List<Widget> _buildAppBlock(BuildContext context) {
    var blocks = new List<Widget>();

    if (AC.instance.isLogin) {
      blocks.add(
        _buildItemCommon(
          'Quản lý đơn hàng',
          icon: Icons.description,
          onTap: () => Navigator.pushNamed(context, 'user/order')
        )
      );
      blocks.add(
        _buildItemCommon(
          'Sản phẩm đã xem',
          icon: Icons.remove_red_eye,
          onTap: () => Navigator.pushNamed(context, 'user/seen')
        )
      );
      blocks.add(
        _buildItemCommon(
          'Sản phẩm yêu thích',
          icon: Icons.favorite,
          onTap: () => Navigator.pushNamed(context, 'user/favorite')
        )
      );
      blocks.add(
        _buildItemCommon(
          'Thông báo',
          icon: Icons.notifications,
          onTap: () => Routes.navigateUser(context, ANNPage.notification)
        )
      );
      blocks.add(
        _buildItemCommon(
          'Bài viết',
          icon: AppIcons.blogger,
          onTap: () => Navigator.pushNamed(context, 'blog')
        )
      );
    }
    else {
      blocks.add(
          _buildItemCommon(
              'Sản phẩm đã xem',
              icon: Icons.remove_red_eye,
              onTap: () => Navigator.pushNamed(context, 'user/seen')
          )
      );
    }

    return blocks;
  }
  //endregion

  //region Promotion, Review App, Share App
  List<Widget> _buildStoreBlock(BuildContext context) {
    var blocks = new List<Widget>();

    if (AC.instance.isLogin)
      blocks.add(
        _buildItemCommon(
          'Mã khuyến mãi',
          icon: MaterialCommunityIcons.ticket_percent,
          onTap: () => Navigator.pushNamed(context, 'user/promotion')
        )
      );

    blocks.add(
        _buildItemCommon(
          'Đánh giá ANN trên ${Platform.isIOS ? 'App Store' : 'Google Play'}',
          icon: Icons.star_border,
          onTap: () => launch(Core.urlStoreReview),
        )
    );
    blocks.add(
        _buildItemCommon(
            'Chia sẻ ứng dụng này',
            icon: Icons.share,
            onTap: () => Share.text(Core.dynamicLinkStore, Core.dynamicLinkStore, 'text/plain')
        )
    );

    return blocks;
  }
  //endregion

  //region Contact
  List<Widget> _buildContactBlock(BuildContext context) {
    var blocks = new List<Widget>();

    blocks.add(
        _buildItemCommon(
            'Liên hệ',
            icon: Icons.headset_mic,
            onTap: () => Navigator.pushNamed(context, 'shop/contact')
        )
    );
    blocks.add(
        _buildItemCommon(
            'Chính sách bán hàng',
            icon: Icons.question_answer,
            onTap: () => Navigator.pushNamed(context, 'shop/policy'))
    );

    if (AC.instance.isLogin) {
      blocks.add(
        _buildItemCommon(
          'Cài đặt copy sản phẩm',
          icon: Icons.settings,
          onTap: () => Navigator.pushNamed(context, 'user')
        )
      );
      blocks.add(
        _buildItemCommon(
          'Cấp quyền tải ảnh',
          icon: Icons.settings,
          onTap: () => _onClickPermission(context)
        )
      );
    }

    return blocks;
  }
  //endregion

  Widget _buildBody(BuildContext context, RootPageProvider rootPageProvider) {
    BorderButton btnLogout;

    if (AC.instance.isLogin)
      btnLogout =  BorderButton(
        onPressed: () {
          var couponProvider = Provider.of<CouponProvider>(context, listen: false);

          couponProvider.myCoupons.error = 'logout';
          rootPageProvider.navigate(RootPageNavigationBar.home);
          AC.instance.clearToken();
          Navigator.pushNamedAndRemoveUntil(context, 'user/login', (route) => false);
        },
        child: Text('ĐĂNG XUẤT'));
    else
      btnLogout = BorderButton(
        onPressed: () {
          rootPageProvider.navigate(RootPageNavigationBar.home);
          Navigator.pushNamed(context, 'user/login');
        },
        child: Text('ĐĂNG NHẬP'));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAccountBlock(context),
        SliverList(
          delegate: SliverChildListDelegate([
            const Divider(height: 10, thickness: 10),
            ..._buildAppBlock(context),
            const Divider(height: 10, thickness: 10),
            ..._buildStoreBlock(context),
            const Divider(height: 10, thickness: 10),
            ..._buildContactBlock(context),
            btnLogout
        ]))
      ]
    );
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Consumer<RootPageProvider>(
      builder: (context, navigation, _) => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(context),
        body: _buildBody(context, navigation),
      )
    );
  }
}
