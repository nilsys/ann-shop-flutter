import 'package:ann_shop_flutter/model/product/category.dart';

class CategoryRepository {

  static final CategoryRepository instance = CategoryRepository._internal();

  factory CategoryRepository() => instance;

  CategoryRepository._internal() {
    /// init
    categories = new List();
    _dataMap.forEach((v) {
      categories.add(new Category.fromJson(v));
    });
    categoryGroups = new List();
    _groupMap.forEach((v) {
      categoryGroups.add(new CategoryGroup.fromJson(v));
    });
  }


  List<Category> categories;
  List<CategoryGroup> categoryGroups;


  Category getCategory(code){
    try{
      var item = categories.firstWhere((m){
        return m.code==code;
      });
      return item;
    }catch(e){
      return null;
    }
  }

  var _groupMap = [
    {
      'title': 'Quần áo nữ',
      'description': 'Quần áo nữ mới về',
      'icon': 'assets/images/categories/category-15.jpg',
      'code':'quan-ao-nu/product',
      'children': [
        'do-bo-nu/product',
        'vay-dam/product',
        'ao-thun-nu/product',
        'ao-so-mi-nu/product',
        'ao-dai-cach-tan/product',
        'quan-nu/product',
        'do-lot-nu/product',
        'ao-khoac-nu/product'
      ]
    },
    {
      'title': 'Quần áo nam',
      'description': 'Quần áo nam mới về',
      'icon': 'assets/images/categories/category-1.jpg',
      'code':'quan-ao-nam/product',
      'children': [
        'ao-thun-nam/product',
        'ao-so-mi-nam/product',
        'ao-khoac-nam/product',
        'quan-nam/product',
        'quan-lot-nam/product',
        'set-bo-nam/product'
      ]
    },
    {
      'title': 'Nước hoa',
      'description': 'Nước hoa giá rẻ',
      'icon': 'assets/images/categories/category-44.jpg',
      'code':'nuoc-hoa/product',
      'children': []
    },
    {
      'title': 'Bao lì xì',
      'description': 'Bao lì xì tết 2020',
      'icon': 'assets/images/categories/bao-li-xi-tet.jpg',
      'code':'bao-li-xi-tet/product',
      'children': []
    }
  ];

  var _dataMap = [
    {
      'icon': 'assets/images/categories/bao-li-xi-tet.jpg',
      'title': 'Bao lì xì tết',
      'code': 'bao-li-xi-tet/product'
    },
    {
      'icon': 'assets/images/categories/category-18.jpg',
      'title': 'Đồ bộ nữ',
      'code': 'do-bo-nu/product'
    },
    {
      'icon': 'assets/images/categories/category-17.jpg',
      'title': 'Váy đầm',
      'code': 'vay-dam/product'
    },
    {
      'icon': 'assets/images/categories/category-19.jpg',
      'title': 'Ao thun nữ',
      'code': 'ao-thun-nu/product'
    },
    {
      'icon': 'assets/images/categories/category-20.jpg',
      'title': 'Ao sơ mi nữ',
      'code': 'ao-so-mi-nu/product'
    },
    {
      'icon': 'assets/images/categories/category-16.jpg',
      'title': 'Áo dài cách tân',
      'code': 'ao-dai-cach-tan/product'
    },
    {
      'icon': 'assets/images/categories/category-23.jpg',
      'title': 'Quần nữ',
      'code': 'quan-nu/product'
    },
    {
      'icon': 'assets/images/categories/category-41.jpg',
      'title': 'Đồ lót nữ',
      'code': 'do-lot-nu/product'
    },
    {
      'icon': 'assets/images/categories/category-21.jpg',
      'title': 'Áo khoác nữ',
      'code': 'ao-khoac-nu/product'
    },
    {
      'icon': 'assets/images/categories/order-product.png',
      'title': 'Quần áo nữ order',
      'code': 'quan-ao-nu/product/hang-order'
    },
    {
      'icon': 'assets/images/categories/sale-product.png',
      'title': 'Quần áo nữ sale',
      'code': 'quan-ao-nu/product/hang-sale'
    },
    {
      'icon': 'assets/images/categories/category-3.jpg',
      'title': 'Áo thun nam',
      'code': 'ao-thun-nam/product'
    },
    {
      'icon': 'assets/images/categories/category-7.jpg',
      'title': 'Áo sơ mi nam',
      'code': 'ao-so-mi-nam/product'
    },
    {
      'icon': 'assets/images/categories/category-10.jpg',
      'title': 'Áo khoác nam',
      'code': 'ao-khoac-nam/product'
    },
    {
      'icon': 'assets/images/categories/category-11.jpg',
      'title': 'Quần nam',
      'code': 'quan-nam/product'
    },
    {
      'icon': 'assets/images/categories/category-42.jpg',
      'title': 'Quần lót nam',
      'code': 'quan-lot-nam/product'
    },
    {
      'icon': 'assets/images/categories/category-2.jpg',
      'title': 'Set bộ nam',
      'code': 'set-bo-nam/product'
    },
    {
      'icon': 'assets/images/categories/order-product.png',
      'title': 'Quần áo nam order',
      'code': 'ao-quan-nam/product/hang-order'
    },
    {
      'icon': 'assets/images/categories/sale-product.png',
      'title': 'Quần áo nam sale',
      'code': 'ao-quan-nam/product/hang-sale'
    },
    {
      'icon': 'assets/images/categories/category-44.jpg',
      'title': 'Nước hoa',
      'code': 'nuoc-hoa/product'
    }
  ];
}
