import 'package:ann_shop_flutter/core/core.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';

import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/provider/utility/spam_cover_provider.dart';

import 'package:ann_shop_flutter/ui/home_page/category_button.dart';
import 'package:ann_shop_flutter/ui/product_ui/product_banner.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:ann_shop_flutter/view/search/search_title.dart';
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

    super.initState();

    category = widget.data['category'];
    initData = widget.data['initData'];
    showSearchInput = widget.data['showSearch'] ?? false;
    filter = AppFilter.fromCategoryFilter(category.filter);

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      Provider.of<SpamCoverProvider>(context,listen: false).checkLoad(category.getSlugBanner);
    });
  }

  bool showSearchInput;
  Category category;
  List<Product> initData;
  AppFilter filter;

  @override
  Widget build(BuildContext context) {
    var message = Provider.of<DownloadImageProvider>(context).currentMessage;

    return Scaffold(
      appBar: showSearchInput
          ? AppBar(
              title: Padding(
                  padding: EdgeInsets.only(right: defaultPadding),
                  child: SearchTitle(category.name)),
              titleSpacing: 0,
            )
          : AppBar(
              title: Text(category.name),
            ),
      body: ListProduct(filter,
          productFilter: category.filter,
          initData: initData,
          topObject: _buildCategoryButtonGrid()),
      bottomNavigationBar: isNullOrEmpty(message)
          ? null
          : BottomAppBar(
              child: DownLoadBackground(),
            ),
    );
  }

  Widget _buildCategoryButtonGrid() {
    List<Category> _categories = category.children;

    List<Widget> children = [];
    if (isNullOrEmpty(_categories) == false) {
      int crossAxisCount = _categories.length >= 8 ? 2 : 1;
      children.add(Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.all(defaultPadding),
//              alignment: Alignment.centerLeft,
//              child: Text(
//                category.name,
//                style: Theme.of(context).textTheme.headline6,
//                overflow: TextOverflow.ellipsis,
//                textAlign: TextAlign.left,
//              ),
//            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: crossAxisCount * 100.0,
              padding: EdgeInsets.only(left: 0, right: 0),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return CategoryButton(_categories[index]);
                },
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                ),
              ),
            ),
            Container(
              height: 10,
              color: AppStyles.dividerColor,
            ),
          ],
        ),
      ));
    }
    if (isNullOrEmpty(category.getSlugBanner) == false) {
      ApiResponse<List<Cover>> _covers =
          Provider.of<SpamCoverProvider>(context)
              .getBySlug(category.getSlugBanner);
      if (isNullOrEmpty(_covers.data) == false) {
        children.add(
          ProductBanner(
            _covers.data,
            border: Border(
                bottom: BorderSide(color: AppStyles.dividerColor, width: 10)),
          ),
        );
      }
    }
    if (isNullOrEmpty(children)) {
      return null;
    } else {
      children.add(SizedBox(height: 20));
      return SliverList(
        delegate: SliverChildListDelegate(children),
      );
    }
  }
}
