import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';

class ListProductByCategory extends StatelessWidget {
  ListProductByCategory(this.category);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: ListProduct(categoryCode: category.code,),
    );
  }
}
