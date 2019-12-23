import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class ProductFull extends StatelessWidget {
  ProductFull(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(70),
            offset: Offset(1.0, 4.0),
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product-detail', arguments: product);
        },
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Hero(
                    tag: product.getCover + '0' + product.sku,
                    child: AppImage(
                      Core.domain + product.getCover,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: BadgeTagProductUI(product.badge),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Hero(
                      tag: product.name + product.productID.toString(),
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    'Mã: ' + product.sku,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .merge(TextStyle(color: Colors.grey)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Giá sỉ: ' +
                              Utility.formatPrice(product.regularPrice),
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .merge(TextStyle(color: Colors.red)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Giá lẻ: ' + Utility.formatPrice(product.retailPrice),
                          style: Theme.of(context).textTheme.body2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildButtonControl(context),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildButtonControl(context) {
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(product.productID);
    Color iconColor = Theme.of(context).primaryColor;

    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          favorite
              ? IconButton(
                  color: iconColor,
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context)
                        .removeProduct(product.productID);
                  },
                )
              : IconButton(
                  color: iconColor,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context)
                        .addNewProduct(context, product, count: 1);
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.cloud_download,
              color: iconColor,
            ),
            onPressed: () {
              _onDownLoad(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: iconColor,
            ),
            onPressed: () {
              _onShare(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: iconColor,
            ),
            onPressed: () {
              _onCheckAndCopy(context);
            },
          ),
        ],
      ),
    );
  }

  _onCheckAndCopy(context){
    if(Core.copySetting.showed) {
      _onCopy(context);
      AppSnackBar.showFlushbar(context, 'Copy',
          duration: Duration(seconds: 1));
    }else{
      Navigator.pushNamed(context, '/setting');
    }
  }

  _onCopy(context) {
    var _text = product.getTextCopy(hasContent: true);
    _text += '\n';
    _text += Core.copySetting.getUserInfo();
    Clipboard.setData(new ClipboardData(text: _text));
  }

  _onDownLoad(context) async {
    try {
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + product.getCover)
          .timeout(Duration(seconds: 5));
      await ImageGallerySaver.saveFile(file.path).timeout(Duration(seconds: 3));
      AppSnackBar.showFlushbar(context, 'Tải hình thành công',
          duration: Duration(seconds: 1));
    } catch (e) {
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: Duration(seconds: 1));
    }
  }

  _onShare(context) async {
    try {
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + product.getCover)
          .timeout(Duration(seconds: 5));
      _onCopy(context);
      ShareExtend.share(file.path, "image");
    } catch (e) {
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: Duration(seconds: 1));
      return;
    }
  }
}
