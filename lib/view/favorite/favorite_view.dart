import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_favorite_item.dart';
import 'package:ann_shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class FavoriteView extends StatefulWidget {
  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: _onRemoveAll,
          ),
          Utility.isNullOrEmpty(data)
              ? null
              : IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: _onShare,
                ),
        ],
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
                            height: 1,
                            color: AppStyles.dividerColor,
                          )
                        ],
                      );
                    }, childCount: data.length),
                  )
          ],
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
                  ModalRoute.withName('/home'),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _onShare() {
    List<ProductFavorite> data =
        Provider.of<FavoriteProvider>(context).products;
    String _value = '';
    for (int i = 0; i < data.length; i++) {
      _value += data[i].getTextCopy(index: i + 1);
      _value += '\n\n';
    }
    _value += '\n';

    _value += CopyController.instance.copySetting.getUserInfo();
    ShareExtend.share(_value, "text");
  }

  _onRemoveAll() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          padding: EdgeInsets.fromLTRB(15, 25, 15, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  'Xoá tất cả các sản phẩm trong danh sách yêu thích',
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Xác nhận',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .merge(TextStyle(color: Colors.white)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<FavoriteProvider>(context)
                        .removeAllProductProvider();
                  }),
            ],
          ),
        );
      },
    );
  }
}
