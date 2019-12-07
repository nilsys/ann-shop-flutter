import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/category.dart';
import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/provider/product/category_product_provider.dart';
import 'package:ann_shop_flutter/ui/home_page/product_item.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/ui/utility/title_view_more.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSlide extends StatefulWidget {
  ProductSlide(this.group);

  final CategoryGroup group;

  @override
  _ProductSlideState createState() => _ProductSlideState();
}

class _ProductSlideState extends State<ProductSlide> {
  String code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    code = widget.group.code;
  }

  @override
  Widget build(BuildContext context) {
    CategoryProductProvider provider = Provider.of(context);
    var products = provider.getByCategory(code);
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
            color: Colors.grey,
          ),
          TitleViewMore(
            title: widget.group.title,
            onPressed: () {},
          ),
          Consumer<CategoryProductProvider>(
            builder: (_, provider, child) {
              var products = provider.getByCategory(code);
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
        Provider.of<CategoryProductProvider>(context)
            .loadCategory(code);
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

  final imageWidth = 150.0;

  final imageHeight = 200.0;

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
          return ProductItem(
            data[index],
            width: imageWidth,
            height: imageHeight,
          );
        },
      ),
    );
  }
}
