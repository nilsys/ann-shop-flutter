import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/product/category_product_provider.dart';
import 'package:ann_shop_flutter/repository/category_repository.dart';
import 'package:ann_shop_flutter/ui/product/product_item.dart';
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
  String currentCode;
  final double itemHeight = 340;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentCode = widget.group.code;
  }

  @override
  Widget build(BuildContext context) {
    CategoryProductProvider provider = Provider.of(context);
    var products = provider.getByCategory(currentCode);
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
          Column(
            children: <Widget>[
              Utility.isNullOrEmpty(widget.group.children)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 30,
                      width: double.infinity,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          index -= 2;
                          if (index < -1 ||
                              index == widget.group.children.length) {
                            return SizedBox(
                              width: 5,
                            );
                          }
                          if (index < 0) {
                            return _buildCategoryButton(
                                widget.group.code, 'Tất cả');
                          } else {
                            var _code = widget.group.children[index];
                            var _name = CategoryRepository.instance
                                .getCategory(_code)
                                .title;
                            return _buildCategoryButton(_code, _name);
                          }
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        itemCount: widget.group.children.length + 3,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
              Consumer<CategoryProductProvider>(
                builder: (_, provider, child) {
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
          )
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
        Provider.of<CategoryProductProvider>(context).loadCategory(currentCode);
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
      height: itemHeight - 10,
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
      height: itemHeight,
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

  _buildCategoryButton(String _code, String _name) {
    bool isSelect = _code == currentCode;
    return InkWell(
      onTap: () {
        setState(() {
          currentCode = _code;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelect ? Colors.black : null,
          borderRadius: BorderRadius.circular(5),
          border: isSelect ? null : Border.all(color: Colors.grey, width: 1),
        ),
        child: Text(
          _name,
          textAlign: TextAlign.center,
          style: TextStyle(color: isSelect ? Colors.white : Colors.grey),
        ),
      ),
    );
  }
}
