import 'package:ann_shop_flutter/model/product/product_filter.dart';

class AppFilter {
  int sort;
  int priceMin;
  int priceMax;
  int badge;

  int get countSet {
    int _count = badge > 0 ? 1 : 0;
    if (priceMin > 0 || priceMax > 0) _count++;
    return _count;
  }


  AppFilter({
    this.sort = 4,
    this.priceMin = 0,
    this.priceMax = 0,
    this.badge = 0,
  });

  AppFilter.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    priceMin = json['priceMin'];
    priceMax = json['priceMax'];
    badge = json['badge'];
  }

  AppFilter.fromCategoryFilter(ProductFilter filter) {
    sort = filter.productSort ?? 4;
    priceMin = filter.priceMin;
    priceMax = filter.priceMax;
    badge = filter.productBadge ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['priceMin'] = this.priceMin;
    data['priceMax'] = this.priceMax;
    data['badge'] = this.badge;
    return data;
  }
}
