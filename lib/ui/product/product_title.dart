import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  ProductTitle(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
          Navigator.pushNamed(context, '/product-detail', arguments: product);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: AppImage(Core.domain + product.getCover),
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
                        style: Theme.of(context).textTheme.body2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(
                            'Giá lẻ: ' +
                                Utility.formatPrice(product.retailPrice),
                            style: Theme.of(context).textTheme.body2,
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
