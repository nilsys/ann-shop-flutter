
import 'package:ann_shop_flutter/model/product/product.dart';

class ProductFavorite {
  Product product;
  int count;

  ProductFavorite({this.product, this.count});

  ProductFavorite.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    product = Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['product'] = this.product.toJson();
    return data;
  }
}