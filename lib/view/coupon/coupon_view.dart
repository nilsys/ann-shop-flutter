import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/ui/product/product_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> data = Provider.of<SeenProvider>(context).products;
    for(var item in data){
      print(item.toJson().toString());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Danh sách ưu đãi'),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ProductTitle(data[index]);
              }, childCount: data.length),
            )
          ],
        ),
      ),
    );
  }
}
