import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/ui/favorite/add_favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFull extends StatelessWidget {
  ProductFull(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product-detail', arguments: product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: AppImage(Core.domain + product.getCover),
                ),
                //Provider.value(value: product, child: AddFavoriteButton(),)
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.body1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 8, left: defaultPadding, right: defaultPadding),
              child: Text(
                'Mã: ' + product.sku,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .merge(TextStyle(color: Colors.grey)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 8, left: defaultPadding, right: defaultPadding),
              child: Text(
                'Giá sỉ: ' + Utility.formatPrice(product.regularPrice),
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .merge(TextStyle(color: Colors.red)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 8, left: defaultPadding, right: defaultPadding),
              child: Text(
                'Giá lẻ: ' + Utility.formatPrice(product.retailPrice),
                style: Theme.of(context).textTheme.body2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
