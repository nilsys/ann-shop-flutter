import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProductByTag extends StatelessWidget {
  ListProductByTag(this.tag);

  final ProductTag tag;
  AppFilter filter = AppFilter();

  @override
  Widget build(BuildContext context) {
    var message = Provider.of<DownloadImageProvider>(context).currentMessage;
    ProductFilter productFilter = ProductFilter(productSearch: tag.slug);

    return Scaffold(
      appBar: AppBar(
        title: Text(tag.name),
      ),
      body: ListProduct(filter, productFilter: productFilter),
      bottomNavigationBar:
          Utility.isNullOrEmpty(message) ? null : DownLoadBackground(),
    );
  }
}
