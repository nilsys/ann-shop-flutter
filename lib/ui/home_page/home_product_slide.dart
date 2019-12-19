import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/provider/category/category_provider.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProductSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoryProvider provider = Provider.of(context);
    var data = provider.categories.data;
    if (Utility.isNullOrEmpty(data)) {
      return SliverFillRemaining(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Indicator(),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ProductSlide(data[index]);
          },
          childCount: data.length,
        ),
      );
    }
  }
}
