import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_favorite_item.dart';
import 'package:ann_shop_flutter/ui/utility/empty_list_ui.dart';
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
            Utility.isNullOrEmpty(data)
                ? _buildEmpty(context)
                : SliverList(
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
      bottomNavigationBar: Utility.isNullOrEmpty(data)
          ? null
          : BottomAppBar(
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

  _buildEmpty(context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            EmptyListUI(
              image: Icon(Icons.redeem),
              body: 'Bạn chưa có sản phẩm nào',
            ),
            SizedBox(height: 5),
            RaisedButton(
              child: Text(
                'Thêm sản phẩm',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Provider.of<NavigationProvider>(context)
                    .switchTo(PageName.category.index);
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _onShare(context) {
    List<ProductFavorite> data =
        Provider.of<FavoriteProvider>(context).products;
    String _value = '';
    for (int i = 0; i < data.length; i++) {
      _value += data[i].getTextCopy(index: i + 1);
      _value += '\n\n';
    }
    _value += '\n';

    _value += Core.copySetting.getUserInfo();
    ShareExtend.share(_value, "text");
  }
}
