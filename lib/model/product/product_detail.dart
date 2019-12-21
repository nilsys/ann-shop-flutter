import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';

class ProductDetail extends Product {
  String categoryName;
  String categorySlug;
  String avatar;
  List<String> images;
  List<ProductColor> colors;
  List<ProductSize> sizes;
  List<ProductTag> tags;

  ProductDetail(
      {this.categoryName,
      this.categorySlug,
      this.images,
      this.colors,
      this.sizes,
      this.tags});

  String getTextCopy({index, hasContent = true}) {
    String value =
        super.getTextCopy(index: index, hasContent: hasContent);
    if (Utility.isNullOrEmpty(colors) == false) {
      value += '\n📚 Màu: ';
      for (var item in colors) {
        value += item.name + '; ';
      }
    }
    if (Utility.isNullOrEmpty(sizes) == false) {
      value += '\n📚 Size: ';
      for (var item in sizes) {
        value += item.name + '; ';
      }
    }
    return value;
  }

  ProductDetail.fromProduct(Product product) {
    productID = product.productID;
    sku = product.sku;
    name = product.name;
    slug = product.slug;
    materials = product.materials;
    badge = product.badge;
    availability = product.availability;
    thumbnails = product.thumbnails;
    regularPrice = product.regularPrice;
    oldPrice = product.oldPrice;
    retailPrice = product.retailPrice;
    content = product.content;
    contentImages = product.contentImages;
  }

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    Product _product = Product.fromJson(json);
    ProductDetail _detail = ProductDetail.fromProduct(_product);
    _detail.productID = json['id'];
    // _detail
    _detail.categoryName = json['categoryName'];
    _detail.categorySlug = json['categorySlug'];
    _detail.avatar = json['avatar'];
    _detail.images = json['images'].cast<String>();
    if (json['colors'] != null) {
      _detail.colors = new List<ProductColor>();
      json['colors'].forEach((v) {
        _detail.colors.add(new ProductColor.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      _detail.sizes = new List<ProductSize>();
      json['sizes'].forEach((v) {
        _detail.sizes.add(new ProductSize.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      _detail.tags = new List<ProductTag>();
      json['tags'].forEach((v) {
        _detail.tags.add(new ProductTag.fromJson(v));
      });
    }
    return _detail;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = this.productID;
    data['categoryName'] = this.categoryName;
    data['categorySlug'] = this.categorySlug;
    data['avatar'] = this.avatar;
    data['images'] = this.images;
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
