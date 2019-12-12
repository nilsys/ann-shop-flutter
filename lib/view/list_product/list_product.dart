import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/repository/load_more_product_repository.dart';
import 'package:ann_shop_flutter/ui/product/product_title.dart';
import 'package:ann_shop_flutter/view/list_product/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ListProduct extends StatefulWidget {
  ListProduct({this.categoryCode, this.searchText});
  final categoryCode;
  final searchText;
  @override
  _BuildAllViewState createState() => _BuildAllViewState();
}

class _BuildAllViewState extends State<ListProduct> {
  LoadMoreProductRepository listSourceRepository;

  @override
  void initState() {
    // TODO: implement initState
    listSourceRepository = new LoadMoreProductRepository(category: widget.categoryCode);
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Material(
        child: LoadingMoreCustomScrollView(
          showGlowLeading: false,
          slivers: <Widget>[
            SliverPersistentHeader(
                pinned: false,
                floating: false,
                delegate: CommonSliverPersistentHeaderDelegate(
                    Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                    ),
                    1.0)),
            LoadingMoreSliverList(
              SliverListConfig<Product>(
                itemBuilder: ItemBuilder.itemBuilder,
                sourceList: listSourceRepository,
                indicatorBuilder: _buildIndicator,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return CustomLoadMoreIndicator(listSourceRepository, status);
  }

  Future<void> onRefresh() async {
    return await listSourceRepository.refresh(false);
  }
}

class ItemBuilder {
  static Widget itemBuilder(BuildContext context, Product item, int index) {
    return ProductTitle(item);
  }
}
