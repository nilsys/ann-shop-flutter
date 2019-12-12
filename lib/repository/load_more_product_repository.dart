import 'dart:async';

import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:loading_more_list/loading_more_list.dart';

class LoadMoreProductRepository extends LoadingMoreBase<Product> {
  LoadMoreProductRepository({this.category, this.searchText}) {
    // TODO:
    pageIndex = 1;
    listenSortConfig = ConfigProvider.onSortChanged.stream.listen((data) {
      sortID = data;
      this.refresh(false);
    });
  }
  @override
  void dispose() {
    listenSortConfig.cancel();
    super.dispose();
  }
  final String category;
  final String searchText;
  StreamSubscription listenSortConfig;

  int pageIndex;
  int sortID;

  // TODO: implement hasMore
  bool _hasMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore => _hasMore;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    // TODO: implement refresh
    _hasMore = true;
    pageIndex = 1;
    var result = await super.refresh(true);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      List<Product> list = await ProductRepository.instance
          .loadByCategory(category, page: pageIndex, pageSize: 20, sort: sortID);

      if (pageIndex == 1) {
        this.clear();
      }

      list.forEach((item) {
        this.add(item);
      });

      _hasMore = list.length < 20;
      pageIndex++;
      isSuccess = true;
    } catch (exception) {
      isSuccess = false;
      _hasMore = false;
      print(exception);
    }
    return isSuccess;
  }
}
