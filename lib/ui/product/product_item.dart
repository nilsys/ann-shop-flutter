import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/ui/favorite/add_favorite_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  ProductItem(this.product, {this.width = 150, this.height = 200});

  final Product product;
  final width;
  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 15,
      padding: EdgeInsets.only(left: 15),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product-detail', arguments: product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ExtendedImage.network(
                      domain + product.getCover,
                      fit: BoxFit.cover,
                      cache: true,
                    ),
                  ),
                  //Provider.value(value: product, child: AddFavoriteButton(),)
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.body1,
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
              padding: EdgeInsets.only(top: 8),
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
