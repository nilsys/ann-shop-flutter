import 'dart:async';

import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:loading_more_list/loading_more_list.dart';

class LoadMoreProductRepository extends LoadingMoreBase<Product> {
  LoadMoreProductRepository({this.categoryCode, this.searchText, this.initData}) {
    // TODO:
    if(this.initData == null) {
      pageIndex = 1;
    }else{
      pageIndex = 2;
      initData.forEach((item) {
        this.add(item);
      });
    }
    listenSortConfig = ConfigProvider.onFilterChanged.stream.listen((data) {
      sortID = data;
      this.refresh(false);
    });
  }

  @override
  void dispose() {
    listenSortConfig.cancel();
    super.dispose();
  }

  final List<Product> initData;
  final String categoryCode;
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
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      List<Product> list = categoryCode != null
          ? await ProductRepository.instance.loadByCategory(categoryCode,
              page: pageIndex, pageSize: 30, sort: sortID)
          : await ProductRepository.instance.loadBySearch(searchText,
              page: pageIndex, pageSize: 30, sort: sortID);

      if (pageIndex == 1) {
        this.clear();
      }

      list.forEach((item) {
        this.add(item);
      });

      _hasMore = list.length == 30;
      pageIndex++;
      isSuccess = true;
    } catch (exception) {
      isSuccess = false;
      _hasMore = false;
      print('load more exception: ' + exception.toString());
    }
    return isSuccess;
  }
}
