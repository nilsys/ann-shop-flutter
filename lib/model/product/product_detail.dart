import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:html_unescape/html_unescape.dart';

class ProductDetail extends Product {
  String categoryName;
  String categorySlug;
  List<ProductColor> colors;
  List<ProductSize> sizes;
  List<ProductTag> tags;

  String content;
  List<String> contentImages;

  ProductDetail({this.content});

  @override
  String getTextCopy({index, hasContent = true}) {
    String value =
        super.getTextCopy(index: index);

    if(hasContent) {
      String _getContent = getContent();
      if (Utility.isNullOrEmpty(_getContent) == false) {
        _getContent = HtmlUnescape().convert(_getContent);
        _getContent = _getContent.replaceAll("<br />", '\n');
        value += '🔖 $_getContent\n';
      }
    }
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

  String getContent() {
    return this
        .content
        .replaceAllMapped(RegExp(r"<img[\w\W]+?>"), (match) => '');
  }

  ProductDetail.fromProduct(Product product) {
    productID = product.productID;
    sku = product.sku;
    name = product.name;
    slug = product.slug;
    materials = product.materials;
    badge = product.badge;
    availability = product.availability;
    avatar = product.avatar;
    regularPrice = product.regularPrice;
    oldPrice = product.oldPrice;
    retailPrice = product.retailPrice;
    images = product.images;
  }

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    Product _product = Product.fromJson(json);
    ProductDetail _detail = ProductDetail.fromProduct(_product);
    _detail.productID = json['id'];
    // _detail
    _detail.categoryName = json['categoryName'];
    _detail.categorySlug = json['categorySlug'];
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

    _detail.content = json['content'];
    List<RegExpMatch> matches =
    RegExp(r"/uploads[\w\W]+?.jpg|/uploads[\w\W]+?.png")
        .allMatches(_detail.content)
        .toList();
    if (Utility.isNullOrEmpty(matches) == false) {
      _detail.contentImages = new List();
      matches.forEach((f) {
        String srcImage = f.group(0);
        if (Utility.isNullOrEmpty(srcImage) == false) {
          _detail.contentImages.add(srcImage);
        }
      });
    }
    return _detail;
  }
}
