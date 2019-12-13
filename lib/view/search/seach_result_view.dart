import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';

class SearchResultView extends StatelessWidget {
  SearchResultView(this.data);

  final data;

  String get title => data['title'];

  List<Product> get products => data['products'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListProduct(searchText: title, initData: products,),
    );
  }
}
