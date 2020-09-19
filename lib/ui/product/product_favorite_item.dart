import 'package:ann_shop_flutter/core/core.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/product_favorite.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/src/configs/route.dart';

import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFavoriteItem extends StatelessWidget {
  ProductFavoriteItem(this.data);

  final ProductFavorite data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      child: InkWell(
        onTap: () {
          Routes.showProductDetail(context, product: data.product);
        },
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: AppImage(
                      AppImage.imageDomain + data.product.getCover,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 30),
                          child: Text(
                            data.product.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.body2,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Mã: ' + data.product.sku,
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .merge(TextStyle(color: Colors.grey)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Sỉ: ' +
                                    Utility.formatPrice(
                                        data.product.regularPrice),
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .merge(TextStyle(color: Colors.red)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Lẻ: ' +
                                    Utility.formatPrice(
                                        data.product.retailPrice),
                                style: Theme.of(context).textTheme.body2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(),
                            ],
                          ),
                        ),
                        BadgeTagProductUI(data.product.badge),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppStyles.dartIcon,
                ),
                onPressed: () {
                  Provider.of<FavoriteProvider>(context, listen: false)
                      .removeProduct(data.product.productID);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
