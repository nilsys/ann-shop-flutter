import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';

class ListProductByTag extends StatelessWidget {
  ListProductByTag(this.tag);


  final ProductTag tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tag.name),
      ),
      body: ListProduct(tagName: tag.slug),
    );
  }
}
