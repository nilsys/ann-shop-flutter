import 'dart:math';

import 'package:ann_shop_flutter/provider/product/product_utility.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/src/route/route.dart';

import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFull extends StatefulWidget {
  ProductFull(this.product);

  final Product product;

  @override
  _ProductFullState createState() => _ProductFullState();
}

class _ProductFullState extends State<ProductFull> {
  bool isDownload = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 12),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(70),
            offset: Offset(1.0, 4.0),
            blurRadius: 8.0,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () {
            Routes.showProductDetail(context, product: widget.product);
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  ImageGrid(widget.product.images),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: BadgeTagProductUI(widget.product.badge),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Mã: ' + widget.product.sku,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .merge(TextStyle(color: Colors.grey)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Giá sỉ: ${widget.product.regularDisplay}',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .merge(widget.product.regularDisplayStyle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Giá lẻ: ' +
                                Utility.formatPrice(widget.product.retailPrice),
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildButtonControl(context),
                    SizedBox(height: 8),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildButtonControl(context) {
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(widget.product.productID);
    Color iconColor = AppStyles.dartIcon;

    return Container(
      height: 40,
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
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeProduct(widget.product.productID);
                  },
                )
              : IconButton(
                  color: iconColor,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .addNewProduct(context, widget.product, count: 1);
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.cloud_download,
              color: isDownload ? Colors.grey : iconColor,
            ),
            onPressed: isDownload
                ? null
                : () {
                    ProductUtility.instance
                        .onDownLoad(context, widget.product.productID);
                    setState(() {
                      isDownload = true;
                    });
                  },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: iconColor,
            ),
            onPressed: () {
              ProductUtility.instance.onCheckAndShare(context, widget.product);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: iconColor,
            ),
            onPressed: () {
              ProductUtility.instance
                  .onCheckAndCopy(context, widget.product.productID);
            },
          ),
        ],
      ),
    );
  }
}
