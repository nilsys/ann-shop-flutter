import 'dart:async';

import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/provider/category/category_provider.dart';
import 'package:ann_shop_flutter/provider/product/category_product_provider.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/shared/models/common/contanct_type.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/home_page/home_banner.dart';
import 'package:ann_shop_flutter/ui/home_page/home_category.dart';
import 'package:ann_shop_flutter/ui/home_page/home_list_notification.dart';
import 'package:ann_shop_flutter/ui/home_page/home_list_post.dart';
import 'package:ann_shop_flutter/ui/home_page/home_navigation.dart';
import 'package:ann_shop_flutter/ui/home_page/home_product_slide.dart';
import 'package:ann_shop_flutter/ui/home_page/seen_block.dart';
import 'package:ann_shop_flutter/ui/utility/ann-icon.dart';
import 'package:ann_shop_flutter/ui/utility/title_view_more.dart';
import 'package:ann_shop_flutter/view/search/search_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  // region Parameters
  StreamSubscription reTapBottom;

  // endregion

  // region Controller
  ScrollController scrollController;

  // endregion

  // region Getter
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // endregion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      reTapBottom = Provider.of<NavigationProvider>(context, listen: false)
          .reTap
          .stream
          .listen(onReTapBottom);
      Provider.of<CoverProvider>(context, listen: false)
          .checkLoadCoverHomePage();
    });
  }

  @override
  dispose() {
    super.dispose();

    if (reTapBottom != null) {
      reTapBottom.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (scrollController.position.pixels != 0) {
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 250),
                curve: ElasticOutCurve(0.25));
            return false;
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshHomepage,
          child: CustomScrollView(
            controller: scrollController,
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              _buildAppBar(),
              SliverList(
                delegate: SliverChildListDelegate([
                  // banner
                  HomeBanner(),
                  // category
                  HomeCategory(),
                  HomeNavigation(),
                ]),
              ),
              HomeListNotification(),
              SeenBlock(),
              HomeProductSlide(),
              _buildContact(),
              HomeListPost(),
              _buildAdress(),
              SliverToBoxAdapter(
                child: Container(
                  height: 20,
                ),
              )
            ],
          ),
        ));
  }

  // region build the page
  // Create App Bar
  SliverAppBar _buildAppBar() {
    return new SliverAppBar(
      pinned: true,
      backgroundColor: Colors.orange,
      title: Padding(
          padding: EdgeInsets.only(left: defaultPadding),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                padding: EdgeInsets.only(right: 15),
                child: AnnIcon(),
              ),
              Expanded(
                flex: 1,
                child: SearchTitle('Bạn tìm gì hôm nay?'),
              )
            ],
          )),
      titleSpacing: 0,
      actions: <Widget>[
        FavoriteButton(
          color: Colors.white,
        ),
      ],
    );
  }

  // Create the contact
  Widget _buildContact() {
    return new SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 10,
          color: Theme.of(context).dividerColor,
        ),
        TitleViewMore(title: 'Kênh đặt hàng'),
        _buildCardContact(
            type: ContactType.facebookMessenger,
            text: 'Facebook: Kho Hàng Sỉ ANN',
            contact: 'bosiquanao.net',
            backgroundColor: const Color(0xff3b5998)),
        _buildCardContact(
            type: ContactType.zalo,
            text: 'Thời trang 1: 0918567409',
            contact: '0918567409',
            backgroundColor: const Color(0xff3189eb)),
        _buildCardContact(
            type: ContactType.zalo,
            text: 'Thời trang 2: 0913268406',
            contact: '0913268406',
            backgroundColor: const Color(0xffea2f2f)),
        _buildCardContact(
            type: ContactType.zalo,
            text: 'Thời trang 3: 0936786404',
            contact: '0936786404',
            backgroundColor: const Color(0xffeabf2e)),
        _buildCardContact(
            type: ContactType.zalo,
            text: 'Thời trang 4: 0918569400',
            contact: '0918569400',
            backgroundColor: const Color(0xffe92697)),
        _buildCardContact(
            type: ContactType.zalo,
            text: 'Mỹ phẩm 1: 0914500502',
            contact: '0914500502',
            backgroundColor: const Color(0xff02ae31)),
        _buildCardContact(
            type: ContactType.zalo,
            text: 'Mỹ phẩm 2: 0941500503',
            contact: '0941500503',
            backgroundColor: const Color(0xff9201b1)),
      ]),
    );
  }

  // Create each the contact
  Widget _buildCardContact(
      {@required ContactType type,
      @required String text,
      @required String contact,
      @required Color backgroundColor}) {
    Widget icon;
    String url;
    Text title;
    ListTile listTile;

    if (type == ContactType.facebookMessenger) {
      icon = FaIcon(
        FontAwesomeIcons.facebookMessenger,
        color: Colors.white,
      );
      url = 'http://m.me/$contact';
    } else if (type == ContactType.zalo) {
      icon = Image.asset('assets/images/ui/zalo-logo.png');
      url = 'http://zalo.me/$contact';
    } else {
      icon = null;
      url = '';
    }

    title = new Text(text,
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center);

    if (icon == null) {
      listTile = new ListTile(
        title: title,
        onTap: () => launch(url),
      );
    } else {
      listTile = new ListTile(
        leading: Container(
          height: 30,
          width: 30,
          child: Center(child: icon),
        ),
        title: title,
        onTap: () => launch(url),
      );
    }

    return new Container(
      height: 60.0,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Card(
        color: backgroundColor,
        child: listTile,
      ),
    );
  }

  Widget _buildAdress() {
    return new SliverList(
        delegate: SliverChildListDelegate([
      Container(
        height: 10,
        color: Theme.of(context).dividerColor,
      ),
      TitleViewMore(title: 'Địa chỉ'),
      Container(
        child: Center(
          child: Card(
            color: null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: FaIcon(FontAwesomeIcons.mapMarkedAlt,
                      color: Colors.orange),
                  title: const Text(
                      '68 Đường C12, Phường 13, Quận Tân Bình, TP.HCM'),
                  subtitle: const Text('8h30 - 20h30 (Chủ Nhật 8h30 - 18h30)'),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Xem trên bản đồ'),
                      onPressed: () => launch(
                          'https://www.google.com/maps?cid=5068651584244638837&hl=vi'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ]));
  }

  // endregion

  // region handle the page
  onReTapBottom(index) {
    if (index == 0) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 250), curve: ElasticOutCurve(0.25));
    }
  }

  Future<void> _refreshHomepage() async {
    Provider.of<CoverProvider>(context, listen: false).loadNotificationHome();
    Provider.of<CoverProvider>(context, listen: false).loadPostHome();
    Provider.of<CoverProvider>(context, listen: false).loadCoverHome();
    Provider.of<CategoryProvider>(context, listen: false).loadCDataHome();
    Provider.of<CategoryProductProvider>(context, listen: false).forceRefresh();
    await Provider.of<CategoryProvider>(context, listen: false)
        .loadCategoryHome();
  }
// endregion
}
