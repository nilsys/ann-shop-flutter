import 'dart:math';

import 'package:ann_shop_flutter/provider/product/product_utility.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/src/route/route.dart';

import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[300]),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildCode(),
              _buildPrice(),
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
              _buildButtonControl(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        widget.product.name,
        style: Theme.of(context).textTheme.headline6,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        'Mã: ' + widget.product.sku,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .merge(TextStyle(color: Colors.grey)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 15),
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
            'Giá lẻ: ' + Utility.formatPrice(widget.product.retailPrice),
            style: Theme.of(context).textTheme.bodyText1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonControl(context) {
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(widget.product.productId);
    Color iconColor = AppStyles.dartIcon;

    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
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
                        .removeProduct(widget.product.productId);
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
              MaterialCommunityIcons.image_multiple,
              color: isDownload ? Colors.grey : iconColor,
            ),
            onPressed: isDownload
                ? null
                : () {
                    ProductUtility.instance
                        .onDownLoad(context, widget.product.productId);
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
                  .onCheckAndCopy(context, widget.product.productId);
            },
          ),
        ],
      ),
    );
  }
}
