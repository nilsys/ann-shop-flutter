import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:ann_shop_flutter/view/search/search_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProductBySearch extends StatefulWidget {
  ListProductBySearch(this.data);

  final Map data;

  @override
  _ListProductBySearchState createState() => _ListProductBySearchState();
}

class _ListProductBySearchState extends State<ListProductBySearch> {
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
        title: Padding(
            padding: EdgeInsets.only(right: defaultPadding),
            child: SearchTitle(category.name)),
        titleSpacing: 0,
      ),
      body: ListProduct(
        filter,
        productFilter: category.filter,
        initData: initData,
      ),
      bottomNavigationBar:
          Utility.isNullOrEmpty(message) ? null : DownLoadBackground(),
    );
  }
}
