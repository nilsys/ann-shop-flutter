import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/repository/category_repository.dart';
import 'package:ann_shop_flutter/ui/home_page/category_button.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/search_title.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = CategoryRepository.instance.categories;
    print(MediaQuery.of(context).size);
    double width = MediaQuery.of(context).size.width - 30;
    int column = (width / 100).floor();
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: Scaffold(
        body: CustomScrollView(
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
                  FavoriteButton(
                    color: Colors.white,
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return CategoryButton(data[index]);
                    },
                    childCount: data.length,
                  ),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: column,
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Future<void> _refreshPage() async {}
}
