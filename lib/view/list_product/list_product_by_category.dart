import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/home_page/category_button.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProductByCategory extends StatefulWidget {
  ListProductByCategory(this.data);

  final Map data;

  @override
  _ListProductByCategoryState createState() => _ListProductByCategoryState();
}

class _ListProductByCategoryState extends State<ListProductByCategory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    category = widget.data['category'];
    initData = widget.data['initData'];
    filter = AppFilter.fromCategoryFilter(category.filter);
  }

  Category category;
  List<Product> initData;
  AppFilter filter;

  @override
  Widget build(BuildContext context) {
    var message = Provider.of<DownloadImageProvider>(context).currentMessage;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListProduct(filter,
          productFilter: category.filter,
          initData: initData,
          topObject: _buildCategoryButtonGrid()),
      bottomNavigationBar:
          Utility.isNullOrEmpty(message) ? null : DownLoadBackground(),
    );
  }

  Widget _buildCategoryButtonGrid() {
    var data = category.children;

    if (Utility.isNullOrEmpty(data)) {
      return null;
    } else {
      int crossAxisCount = data.length >= 8 ? 2 : 1;
      return SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(defaultPadding),
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: crossAxisCount * 100.0,
                padding: EdgeInsets.only(left: 0, right: 0),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return CategoryButton(data[index]);
                  },
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                  ),
                ),
              ),
              Container(
                height: 10,
                color: AppStyles.dividerColor,
              )
            ],
          ),
        ),
      );
    }
  }

  _buildCategoryButtonList() {
    var categories = category.children;
    return Container(
      height: 45,
      color: Colors.white,
      padding: EdgeInsets.only(top: 10, bottom: 5),
      width: double.infinity,
      child: ListView.separated(
        itemBuilder: (context, index) {
          index -= 1;
          if (index < 0 || index == categories.length) {
            return SizedBox(
              width: 5,
            );
          }
          return ActionChip(
            label: Text(
              categories[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              ListProduct.showByCategory(context, categories[index]);
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: categories.length + 2,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
