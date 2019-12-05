import 'package:ann_shop_flutter/model/product.dart';

class ProductDetail {
  int id;
  String categoryName;
  String categorySlug;
  String name;
  String sku;
  String avatar;
  List<ProductThumbnails> thumbnails;
  String materials;
  double regularPrice;
  double oldPrice;
  double retailPrice;
  String content;
  String slug;
  List<String> images;
  List<ProductColors> colors;
  List<ProductSize> sizes;
  int badge;
  List<String> tags;

  ProductDetail(
      {this.id,
        this.categoryName,
        this.categorySlug,
        this.name,
        this.sku,
        this.avatar,
        this.thumbnails,
        this.materials,
        this.regularPrice,
        this.oldPrice,
        this.retailPrice,
        this.content,
        this.slug,
        this.images,
        this.colors,
        this.sizes,
        this.badge,
        this.tags});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categorySlug = json['categorySlug'];
    name = json['name'];
    sku = json['sku'];
    avatar = json['avatar'];
    if (json['thumbnails'] != null) {
      thumbnails = new List<ProductThumbnails>();
      json['thumbnails'].forEach((v) {
        thumbnails.add(new ProductThumbnails.fromJson(v));
      });
    }
    materials = json['materials'];
    regularPrice = json['regularPrice'];
    oldPrice = json['oldPrice'];
    retailPrice = json['retailPrice'];
    content = json['content'];
    slug = json['slug'];
    images = json['images'].cast<String>();
    if (json['colors'] != null) {
      colors = new List<ProductColors>();
      json['colors'].forEach((v) {
        colors.add(new ProductColors.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      sizes = new List<ProductSize>();
      json['sizes'].forEach((v) {
        sizes.add(new ProductSize.fromJson(v));
      });
    }
    badge = json['badge'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categorySlug'] = this.categorySlug;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['avatar'] = this.avatar;
    if (this.thumbnails != null) {
      data['thumbnails'] = this.thumbnails.map((v) => v.toJson()).toList();
    }
    data['materials'] = this.materials;
    data['regularPrice'] = this.regularPrice;
    data['oldPrice'] = this.oldPrice;
    data['retailPrice'] = this.retailPrice;
    data['content'] = this.content;
    data['slug'] = this.slug;
    data['images'] = this.images;
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    data['badge'] = this.badge;
    data['tags'] = this.tags;
    return data;
  }
}
