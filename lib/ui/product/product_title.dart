import 'package:ann_shop_flutter/core/core.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/src/route/route.dart';

import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';

import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  ProductTitle(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppStyles.dividerColor,
          ),
        ),
      ),
      padding: EdgeInsets.all(defaultPadding),
      child: InkWell(
        onTap: () {
          Routes.showProductDetail(context, product: product);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 90,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: AppImage(
                  product.getCover,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 1,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product.name,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mã: ' + product.sku,
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .merge(TextStyle(color: Colors.grey)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Sỉ: ${product.regularDisplay}',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .merge(product.regularDisplayStyle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Lẻ: ' + Utility.formatPrice(product.retailPrice),
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(),
                        ],
                      ),
                    ),
                    BadgeTagProductUI(product.badge),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
