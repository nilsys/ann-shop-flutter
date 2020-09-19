import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/provider/category/category_provider.dart';

import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProductSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoryProvider provider = Provider.of(context);
    var data = provider.dataHome.data;
    if (isNullOrEmpty(data)) {
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
            return ProductSlide(data[index].category,
                banner: data[index].banner);
          },
          childCount: data.length,
        ),
      );
    }
  }
}
