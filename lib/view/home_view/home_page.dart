import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/repository/category_repository.dart';
import 'package:ann_shop_flutter/ui/home_page/home_banner.dart';
import 'package:ann_shop_flutter/ui/home_page/home_category.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/search_title.dart';
import 'package:flutter/material.dart';

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
                          child: SearchTitle('Bạn tìm gì hôm nay?')),
                      titleSpacing: 0,
                      actions: <Widget>[
                        FavoriteButton(color: Colors.white,),
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
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ProductSlide(CategoryRepository
                              .instance.categoryGroups[index]);
                        },
                        childCount:
                            CategoryRepository.instance.categoryGroups.length,
                      ),
                    ),
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

  Future<void> _refreshHomepage() async {}
}
