import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/product/category_product_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_item.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSlide extends StatefulWidget {
  ProductSlide(this.group, {this.customName});

  final Category group;
  final customName;

  @override
  _ProductSlideState createState() => _ProductSlideState();
}

class _ProductSlideState extends State<ProductSlide> {
  Category currentCategory;
  ScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController();
    if (Utility.isNullOrEmpty(widget.group.slug)) {
      currentCategory = widget.group.children[0];
    } else {
      currentCategory = widget.group;
    }
  }

  @override
  Widget build(BuildContext context) {
    CategoryProductProvider provider = Provider.of(context);
    var products = provider.getByCategory(currentCategory.slug);

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
            color: AppStyles.dividerColor,
          ),
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.customName ?? widget.group.name,
              style: Theme.of(context).textTheme.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
                            return _buildCategoryButton(widget.group,
                                customName: 'Tất cả');
                          } else {
                            var _child = widget.group.children[index];
                            return _buildCategoryButton(_child);
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
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppStyles.dividerColor, width: 1))),
                child: MaterialButton(
                  onPressed: () {
                    ListProduct.showByCategory(context, currentCategory);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'XEM THÊM',
                        style: Theme.of(context).textTheme.button.merge(
                              TextStyle(color: Theme.of(context).primaryColor),
                            ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              )
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
        Provider.of<CategoryProductProvider>(context)
            .loadCategory(currentCategory.slug, refresh: true);
      }),
    );
  }

  Widget buildLoading(BuildContext context) {
    return buildBox(
      child: Indicator(),
    );
  }

  Widget buildBox({@required child}) {
    return Container(
      height: itemHeight - 10,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  final imageWidth = 150.0;
  final imageHeight = 200.0;

  double get itemHeight => imageHeight + 140;

  Widget buildProductList(BuildContext context, List<Product> data) {
    return Container(
      height: itemHeight,
      padding: EdgeInsets.only(left: 0, right: 0),
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == data.length) {
            return _buildViewMoreButton();
          }
          return ProductItem(
            data[index],
            width: imageWidth,
            imageHeight: imageHeight,
          );
        },
      ),
    );
  }

  _buildCategoryButton(Category item, {String customName}) {
    String _name = customName ?? item.name;
    if (Utility.isNullOrEmpty(item.slug)) {
      return Container();
    } else {
      bool isSelect = item == currentCategory;
      return ChoiceChip(
        label: Text(
          _name,
          textAlign: TextAlign.center,
          style: TextStyle(color: isSelect ? Colors.white : Colors.black87),
        ),
        selected: isSelect,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              currentCategory = item;
              if(controller.hasClients){
                controller.jumpTo(0);
              }
            });
          }
        },
        selectedColor: Colors.black87,
        disabledColor: Colors.grey,
      );
    }
  }

  _buildViewMoreButton() {
    return Container(
      color: Colors.white,
      width: imageWidth + 15,
      padding: EdgeInsets.only(right: 15, bottom: 120),
      child: Center(
        child: InkWell(
          onTap: () {
            ListProduct.showByCategory(context, currentCategory);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
              ),
              Text(
                'Xem thêm',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
