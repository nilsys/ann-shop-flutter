import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';

class Category {
  int id;
  String icon;
  String name;
  String description;
  List<Category> children;
  ProductFilter filter;

  bool get vailable {
    if (filter != null) {
      if (Utility.isNullOrEmpty(filter.categorySlug) == false ||
          Utility.isNullOrEmpty(filter.categorySlugList) == false ||
          Utility.isNullOrEmpty(filter.tagSlug) == false ||
          Utility.isNullOrEmpty(filter.productSearch) == false) {
        return true;
      }
    }
    return false;
  }

  dynamic get getID {
    if(filter == null){
      return null;
    }else{
      if(Utility.isNullOrEmpty(filter.categorySlug)){
        return filter.categorySlug;
      }
      if(Utility.isNullOrEmpty(filter.categorySlugList)){
        return filter.categorySlugList;
      }
      if(Utility.isNullOrEmpty(filter.tagSlug)){
        return filter.tagSlug;
      }
      if(Utility.isNullOrEmpty(filter.productSearch)){
        return filter.productSearch;
      }
    }
    return null;
  }

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
