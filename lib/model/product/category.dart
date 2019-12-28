import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';

class Category {
  int id;
  String icon;
  String name;
  String description;
  List<Category> children;
  ProductFilter filter;

  Category(
      {this.icon, this.name, this.description, this.children, this.filter});

  Category.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] ?? 'assets/images/categories/sale-product.png';
    name = json['name'];
    id = json['id'];
    description = json['description'];
    filter = ProductFilter.fromJson(json['filter']);
    if (json['children'] != null) {
      children = new List<Category>();
      json['children'].forEach((v) {
        children.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['description'] = this.description;
    data['children'] = this.children;
    data['filter'] = this.filter.toJson();
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
