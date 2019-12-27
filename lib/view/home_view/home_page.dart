import 'package:ann_shop_flutter/provider/category/category_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/provider/product/category_product_provider.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/ui/home_page/home_banner.dart';
import 'package:ann_shop_flutter/ui/home_page/home_category.dart';
import 'package:ann_shop_flutter/ui/home_page/home_product_slide.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/home_page/home_list_banner.dart';
import 'package:ann_shop_flutter/ui/home_page/seen_block.dart';
import 'package:ann_shop_flutter/ui/utility/ann-icon.dart';
import 'package:ann_shop_flutter/view/search/search_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 400.0,
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
          ),
          RefreshIndicator(
            onRefresh: _refreshHomepage,
            child: SafeArea(
              child: Container(
                child: CustomScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
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
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        // banner
                        HomeBanner(),
                        // category
                        HomeCategory(),
                      ]),
                    ),
                    HomeListBanner(
                        data: Provider.of<CoverProvider>(context)
                            .notificationHome
                            .data),
                    HomeListBanner(
                        data:
                            Provider.of<CoverProvider>(context).postsHome.data),
                    SeenBlock(),
                    HomeProductSlide(),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        height: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _refreshHomepage() async {
    Provider.of<CoverProvider>(context).loadNotificationHome();
    Provider.of<CoverProvider>(context).loadPostHome();
    Provider.of<CoverProvider>(context).loadCoverHome();
    Provider.of<CategoryProvider>(context).loadCDataHome();
    Provider.of<CategoryProductProvider>(context).forceRefresh();
    await Provider.of<CategoryProvider>(context).loadCategoryHome();
  }
}
