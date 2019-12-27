import 'dart:math';

import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_item.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_view_more.dart';
import 'package:ann_shop_flutter/ui/utility/title_view_more.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeenBlock extends StatelessWidget {
  SeenBlock({this.exceptID});

  final int exceptID;

  @override
  Widget build(BuildContext context) {
    final imageWidth = 150.0;
    final imageHeight = 200.0;
    SeenProvider provider = Provider.of(context);
    if (provider.products != null &&
        provider.products.length >= (exceptID == null ? 1 : 2)) {

      int length = min(provider.products.length , 10);
      return SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: new Border(
              top: BorderSide(
                color: AppStyles.dividerColor,
                width: 10,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              TitleViewMore(
                title: 'Sản phẩm đã xem',
              ),
              Container(
                height: imageHeight + 140,
                padding: EdgeInsets.only(left: 0, right: 0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    if (provider.products[index].productID ==
                        exceptID) {
                      return Container();
                    }
                    return ProductItem(
                      provider.products[index],
                      width: imageWidth,
                      imageHeight: imageHeight,
                    );
                  },
                ),
              ),
              BottomViewMore(onPressed: () {
                Navigator.pushNamed(context, '/seen');
              },)
            ],
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }
}
