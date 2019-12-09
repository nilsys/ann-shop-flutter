import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product product = Provider.of(context);
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(product.productID);

    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          if (favorite) {
            Provider.of<FavoriteProvider>(context)
                .removeProduct(product.productID);
          } else {
            Provider.of<FavoriteProvider>(context)
                .addNewProduct(product, count: 1);
          }
        },
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
