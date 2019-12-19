import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:ann_shop_flutter/view/search/search_title.dart';
import 'package:flutter/material.dart';

class ListProductBySearch extends StatelessWidget {
  ListProductBySearch(this.data);

  final data;

  String get title => data['title'];

  List<Product> get products => data['products'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.only(right: defaultPadding),
            child: SearchTitle(title)),
        titleSpacing: 0,
      ),
      body: ListProduct(
        searchText: title,
        initData: products,
      ),
    );
  }
}
