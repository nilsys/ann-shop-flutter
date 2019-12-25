import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';

class Category {
  int id;
  String icon;
  String name;
  String slug;
  String description;
  List<Category> children;
  ProductFilter filter;

  bool get vailable {
    if (Utility.isNullOrEmpty(slug) == false) {
      return true;
    }
    if (filter != null) {
      if (Utility.isNullOrEmpty(filter.categorySlug) == false ||
          Utility.isNullOrEmpty(filter.categorySlugList) == false ||
          Utility.isNullOrEmpty(filter.tagSlug) == false ||
          Utility.isNullOrEmpty(filter.productSearch) == false){
        return true;
      }
    }
    return false;
  }

  Category({this.icon, this.name, this.slug, this.description, this.children});

  Category.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] ?? 'assets/images/categories/sale-product.png';
    name = json['name'];
    id = json['id'];
    slug = json['slug'];
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
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['children'] = this.children;
    data['filter'] = this.filter.toJson();
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}