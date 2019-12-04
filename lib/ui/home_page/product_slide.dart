import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/provider/product/product_home_provider.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSlide extends StatelessWidget {
  ProductSlide({@required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.centerLeft,
            child: Consumer<ProductHomeProvider>(
              builder: (_, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          provider.categoryIDs[index].toUpperCase(),
                          style: Theme.of(context).textTheme.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    UIManager.btnViewAll(
                      'Xem tất cả',
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
          ),
          Consumer<ProductHomeProvider>(
            builder: (_, provider, child) {
              var products = provider.categories[index];
              if (products.isLoading) {
                return buildLoading(context);
              } else if (products.isError) {
                return buildError(context);
              } else {
                if (Utility.isNullOrEmpty(products.data)) {
                  return buildEmpty(context);
                } else {
                  return buildProductList(context, products.data);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmpty(BuildContext context) {
    return buildBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.description),
            SizedBox(
              height: 10,
            ),
            Text('Empty'),
          ],
        ),
      ),
    );
  }

  Widget buildError(BuildContext context) {
    return buildBox(
      child: SomethingWentWrong(onReload: () {
        Provider.of<ProductHomeProvider>(context)
            .loadCategory(index, force: true);
      }),
    );
  }

  Widget buildLoading(BuildContext context) {
    return buildBox(
      child: UIManager.defaultIndicator(),
    );
  }

  Widget buildBox({@required child}) {
    return Container(
      height: 200,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  final imageWidth = 180.0;
  final imageHeight = 240.0;

  Widget buildProductList(BuildContext context, List<Product> data) {
    return Container(
      height: 400,
      padding: EdgeInsets.only(left: 0, right: 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == data.length) {
            return Container(
              color: Colors.white,
              width: 15,
            );
          }
          return buildProduct(context, data[index]);
        },
      ),
    );
  }

  Widget buildProduct(BuildContext context, Product product) {
    return Container(
      width: imageWidth + 15,
      padding: EdgeInsets.only(left: 15),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: imageHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ExtendedImage.network(
                  GlobalConfig.instance.domain + product.getCover,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.body2,
                maxLines: 1,
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
            Container(
              padding: EdgeInsets.only(top: 8),
              height: 40,
              child: Row(
                children: <Widget>[
                  buildIconButton(Icons.content_copy, onPressed: (){}),
                  SizedBox(width: 5,),
                  buildIconButton(Icons.file_download, onPressed: (){}),
                  SizedBox(width: 5,),
                  buildIconButton(Icons.favorite, onPressed: (){}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(icon, {onPressed}) {
    return Container(
      color: Colors.orange,
      width: 45,
      height: 40,
      child: IconButton(
        icon: Icon(icon, size: 20,),
        onPressed: () {},
      ),
    );
  }
}
