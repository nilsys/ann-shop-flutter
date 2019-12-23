import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/ui/product/badge_product_tag.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/material.dart';

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
              child: Hero(
                tag: product.getCover + '0' + product.sku,
                child: Stack(
                  children: [
                    AppImage(
                      Core.domain + product.getCover,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: BadgeProductTag(product.badge),
                    ),
                  ],
                ),
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
}
