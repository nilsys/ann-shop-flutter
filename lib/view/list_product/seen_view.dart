import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/product/product_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> data = Provider.of<SeenProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Danh sách đã xem'),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: <Widget>[
                    ProductTitle(data[index]),
                    Container(
                      height: 2,
                      color: AppStyles.dividerColor,
                    )
                  ],
                );
              }, childCount: data.length),
            )
          ],
        ),
      ),
    );
  }
}
