import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProductByCategory extends StatelessWidget {
  ListProductByCategory(this.category);

  final Category category;

  @override
  Widget build(BuildContext context) {
    var message = Provider.of<DownloadImageProvider>(context).currentMessage;
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListProduct(categoryCode: category.slug,),
      bottomNavigationBar: Utility.isNullOrEmpty(message)?null: DownLoadBackground(),
    );
  }
}
