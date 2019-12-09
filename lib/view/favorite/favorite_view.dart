import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_full.dart';
import 'package:ann_shop_flutter/ui/product/product_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ProductFavorite> data =
        Provider.of<FavoriteProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
        ),
        title: Text('Danh sách yêu thích'),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: <Widget>[
                    ProductTitle(data[index].product),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 12,
                      color: AppStyles.dividerColor,
                    )
                  ],
                );
              }, childCount: data.length),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50,
        ),
      ),
    );
  }
}
