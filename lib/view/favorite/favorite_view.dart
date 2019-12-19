import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class FavoriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ProductFavorite> data =
        Provider.of<FavoriteProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
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
                    ProductFavoriteItem(data[index]),
                    Container(
                      height: 2,
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
          child: RaisedButton(
            child: Text(
              'Chia sẻ',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .merge(TextStyle(color: Colors.white)),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _onShare(context);
            },
          ),
        ),
      ),
    );
  }

  _onShare(context) {
    ShareExtend.share('abc', "text");
  }
}
