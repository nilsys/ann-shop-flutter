import 'dart:convert';
import 'dart:io';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/utility/app_filter.dart';

class ListProductRepository {
  static final ListProductRepository instance =
      ListProductRepository._internal();

  factory ListProductRepository() => instance;

  ListProductRepository._internal();

  String getFilterParams(AppFilter filter) {
    var params = '';
    if (filter != null) {
      if (filter.sort > 0) {
        params += '&sort=${filter.sort}';
      }
      if (filter.priceMin > 0) {
        params += '&priceMin=${filter.priceMin}';
      }
      if (filter.priceMax > 0) {
        params += '&priceMax=${filter.priceMax}';
      }
      if (filter.badge > 0) {
        params += '&productBadge=${filter.badge}';
      }
    }
    return params;
  }

  List<Product> listProductByString(String body) {
    try {
      if (isNullOrEmpty(body)) {
        return [];
      }
      var message = jsonDecode(body);
      List<Product> _data = new List();
      message.forEach((v) {
        _data.add(new Product.fromJson(v));
      });
      return _data;
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> loadByCategoryFilter(Category category,
      {page = 1, pageSize = itemPerPage}) {
    AppFilter filter = AppFilter.fromCategoryFilter(category.filter);
    return loadByProductFilter(category.filter,
        filter: filter, pageSize: pageSize, page: page);
  }

  Future<List<Product>> loadByProductFilter(ProductFilter productFilter,
      {page = 1, pageSize = itemPerPage, AppFilter filter}) {
    if (productFilter != null) {
      if (isNullOrEmpty(productFilter.categorySlug) == false) {
        return _loadByCategory(productFilter.categorySlug,
            filter: filter, page: page, pageSize: pageSize);
      } else if (isNullOrEmpty(productFilter.categorySlugList) == false) {
        return _loadByListCategory(productFilter.categorySlugList,
            filter: filter, page: page, pageSize: pageSize);
      } else if (isNullOrEmpty(productFilter.productSearch) == false) {
        return loadBySearch(productFilter.productSearch,
            filter: filter, page: page, pageSize: pageSize);
      } else if (isNullOrEmpty(productFilter.tagSlug) == false) {
        return _loadByTag(productFilter.tagSlug,
            filter: filter, page: page, pageSize: pageSize);
      } else if (isNullOrEmpty(productFilter.productSKU) == false) {
        return loadBySku(productFilter.productSKU,
            filter: filter, page: page, pageSize: pageSize);
      } else {
        return _loadAllByFilter(filter: filter, page: page, pageSize: pageSize);
      }
    }
    return null;
  }

  Future<List<Product>> _loadAllByFilter(
      {page = 1, pageSize = itemPerPage, AppFilter filter}) async {
    try {
      var url = 'flutter/products?pageNumber=$page&pageSize=$pageSize';
      url += getFilterParams(filter);
      final response = await AppHttp.get(
        url,
      ).timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/products?categorySlugList[0]=ao-thun-nu&categorySlugList[1]=so-mi-nu
  Future<List<Product>> _loadByListCategory(List<String> names,
      {page = 1, pageSize = itemPerPage, AppFilter filter}) async {
    var categorySlugList = 'categorySlugList[0]=${names[0]}';
    for (int i = 1; i < names.length; i++) {
      categorySlugList += '&categorySlugList[$i]=${names[i]}';
    }
    try {
      var url =
          'flutter/products?$categorySlugList&pageNumber=$page&pageSize=$pageSize';
      url += getFilterParams(filter);
      final response = await AppHttp.get(
        url,
      ).timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/products?categorySlug=bao-li-xi-tet&pageNumber=1&pageSize=28&sort=4
  Future<List<Product>> _loadByCategory(String name,
      {page = 1, pageSize = itemPerPage, AppFilter filter}) async {
    try {
      var url =
          'flutter/products?categorySlug=$name&pageNumber=$page&pageSize=$pageSize';
      url += getFilterParams(filter);
      final response = await AppHttp.get(
        url,
      ).timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/products?productSearch
  Future<List<Product>> loadBySearch(String text,
      {page = 1, pageSize = itemPerPage, AppFilter filter}) async {
    try {
      var url =
          'flutter/products?productSearch=$text&pageNumber=$page&pageSize=$pageSize';
      url += getFilterParams(filter);
      final response = await AppHttp.get(
        url,
      ).timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Product>> _loadByTag(String text,
      {page = 1, pageSize = itemPerPage, AppFilter filter}) async {
    try {
      var url =
          'flutter/products?tagSlug=$text&pageNumber=$page&pageSize=$pageSize';
      url += getFilterParams(filter);
      final response = await AppHttp.get(url).timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://backend.xuongann.com/api/flutter/products?productSKU=cs001
  Future<List<Product>> loadBySku(String sku,
      {page = 1, pageSize = itemPerPage, AppFilter filter}) async {
    try {
      var url =
          'flutter/products?productSKU=$sku&pageNumber=$page&pageSize=$pageSize';
      url += getFilterParams(filter);
      final response = await AppHttp.get(url).timeout(Duration(minutes: 5));

      if (response.statusCode == HttpStatus.ok) {
        return listProductByString(response.body);
      } else if (response.statusCode == HttpStatus.notFound) {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  final _prefixCategoryKey = 'key_product_by_category_';

  cacheProduct(String _keyCache, List<Product> products) {
    var myJsonString =
        jsonEncode(products.map((value) => value.toJson()).toList());
    UserDefaults.instance
        .setObject(_prefixCategoryKey + _keyCache, myJsonString);
  }

  Future<List<Product>> loadByCache(String _keyCache) async {
    try {
      String body = await UserDefaults.instance
          .getObjectByKey(_prefixCategoryKey + _keyCache);

      if (isNullOrEmpty(body) == false) {
        return listProductByString(body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
