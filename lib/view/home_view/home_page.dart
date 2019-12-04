import 'package:ann_shop_flutter/provider/product/product_home_provider.dart';
import 'package:ann_shop_flutter/ui/home_page/home_banner.dart';
import 'package:ann_shop_flutter/ui/home_page/home_buttons.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
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
            height: 200.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purple[200], Colors.purple[600]])),
          ),
          RefreshIndicator(
            onRefresh: _refreshHomepage,
            child: SafeArea(
              child: Container(
                child: CustomScrollView(
                  controller: scrollController,
                  physics: ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          height: 40,
                        ),
                        // banner
                        HomeBanner(),
                        // button
                        Container(
                          color: Colors.white,
                          height: 20,
                        ),
                        HomeButtons(),
                        //
                      ]),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ProductSlide(index: index);
                        },
                        childCount: Provider.of<ProductHomeProvider>(context)
                            .categoryIDs
                            .length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        height: 30,),
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
