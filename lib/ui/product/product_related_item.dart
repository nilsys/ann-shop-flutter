import 'package:ann_shop_flutter/model/product/product_related.dart';

import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';

import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class ProductRelatedItem extends StatelessWidget {
  ProductRelatedItem(this.product);

  final ProductRelated product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: new Border.all(
          color: AppStyles.grey,
          width: 1.5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: AppImage(product.avatar),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Mã: ' + product.sku,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .merge(TextStyle(color: Colors.grey)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  BadgeTagProductUI(product.badge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
