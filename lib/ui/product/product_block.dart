import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/src/route/route.dart';
import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';

import 'package:flutter/material.dart';

class ProductBlock extends StatelessWidget {
  ProductBlock(this.product, {this.imageHeight = 200});

  final Product product;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routes.showProductDetail(context, product: product);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AppImage(product.getCover),
                Positioned(
                  left: 0,
                  top: 0,
                  child: BadgeTagProductUI(product.badge),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
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
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Sỉ: ${product.regularDisplay}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(product.regularDisplayStyle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Lẻ: ' + Utility.formatPrice(product.retailPrice),
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
