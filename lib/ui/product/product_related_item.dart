import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/material.dart';

class ProductRelatedItem extends StatelessWidget {
  ProductRelatedItem(this.product);

  final ProductRelated product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        border: new Border.all(
          color: Colors.grey,
          width: 1.5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
          onTap: () {
            _searchProduct(context, product.sku);
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: AppImage(Core.domain + product.avatar),
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
                        style: Theme.of(context).textTheme.title,
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
                            .subhead
                            .merge(TextStyle(color: Colors.grey)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _buildBadge(context, product.badge),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  final colors = [Colors.grey[700], Colors.orange, Colors.brown, Colors.cyan];
  final names = ['Hết hàng', 'Có sẳn', 'Hàng order', 'Hàng sale'];

  _buildBadge(context, int badge) {
    if (badge == null || badge < 0 || badge > 3) badge = 0;
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(color: colors[badge]),
      child: Text(
        names[badge],
        style: Theme.of(context)
            .textTheme
            .body2
            .merge(TextStyle(color: Colors.white)),
      ),
    );
  }

  _searchProduct(context, String sku) {
//    ListProduct.showBySearch(context, {'title': sku, 'products': null},refreshSearch: false);
  }
}
