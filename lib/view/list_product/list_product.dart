import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/category/category_provider.dart';
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/provider/utility/search_provider.dart';
import 'package:ann_shop_flutter/repository/load_more_product_repository.dart';
import 'package:ann_shop_flutter/ui/product_ui/config_product_ui.dart';
import 'package:ann_shop_flutter/ui/product/product_block.dart';
import 'package:ann_shop_flutter/ui/product/product_full.dart';
import 'package:ann_shop_flutter/ui/product/product_title.dart';
import 'package:ann_shop_flutter/view/list_product/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:provider/provider.dart';

class ListProduct extends StatefulWidget {
  ListProduct({this.appBar, this.categoryCode, this.categoryList, this.searchText, this.tagName, this.initData});

  final categoryCode;
  final searchText;
  final tagName;
  final categoryList;
  final initData;

  final SliverPersistentHeaderDelegate appBar;

  @override
  _BuildAllViewState createState() => _BuildAllViewState();

  static showByCategory(context,Category data) {
    Provider.of<ConfigProvider>(context).refreshFilter();
    Navigator.pushNamed(context, '/list-product-by-category', arguments: data);
  }

  static showByTag(context,ProductTag data) {
    Provider.of<ConfigProvider>(context).refreshFilter();
    Navigator.pushNamed(context, '/list-product-by-tag', arguments: data);
  }

  static showBySearch(context,Map data, {bool refreshSearch = true}) {
    if (refreshSearch) Provider.of<SearchProvider>(context).setText();
    Provider.of<ConfigProvider>(context).refreshFilter();
    Navigator.pushNamed(context, '/list-product-by-search', arguments: data);
  }
}

class _BuildAllViewState extends State<ListProduct> {
  LoadMoreProductRepository listSourceRepository;

  @override
  void initState() {
    super.initState();

    listSourceRepository = new LoadMoreProductRepository(
        categoryCode: widget.categoryCode,
        categoryList: widget.categoryList,
        searchText: widget.searchText,
        tagName: widget.tagName,
        initData: widget.initData);
  }

  List<Category> categories;

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigProvider config = Provider.of(context);

    SliverPersistentHeaderDelegate appbar = widget.appBar ?? CommonSliverPersistentHeaderDelegate(
            ConfigProductUI(),60);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Material(
        child: LoadingMoreCustomScrollView(
          showGlowLeading: false,
          slivers: <Widget>[
            SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: appbar,),
            SliverPadding(
                padding: (config.view == ViewType.grid)
                    ? EdgeInsets.symmetric(horizontal: defaultPadding)
                    : EdgeInsets.symmetric(horizontal: 0),
                sliver: LoadingMoreSliverList(_buildByView()))
          ],
        ),
      ),
    );
  }

  SliverListConfig<Product> _buildByView() {
    ConfigProvider config = Provider.of(context);
    if (config.view == ViewType.grid) {
      final textHeight = 140.0;
      final double screenWidth = MediaQuery.of(context).size.width;
      final countPerRow = screenWidth < 450 ? 2 : 3;
      final imageWidth =
          (screenWidth - ((countPerRow + 1) * defaultPadding)) / countPerRow;
      final imageHeight = imageWidth * 4 / 3;
      final childAspectRatio =
          imageWidth / (imageHeight + textHeight);
      return SliverListConfig<Product>(
        itemBuilder: ItemBuilder.itemBuilderGrid,
        sourceList: listSourceRepository,
        indicatorBuilder: _buildIndicator,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: countPerRow,
          mainAxisSpacing: defaultPadding,
          crossAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
      );
    } else {
      return SliverListConfig<Product>(
        itemBuilder: config.view == ViewType.list
            ? ItemBuilder.itemBuilderList
            : ItemBuilder.itemBuilderBig,
        sourceList: listSourceRepository,
        indicatorBuilder: _buildIndicator,
      );
    }
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return CustomLoadMoreIndicator(listSourceRepository, status);
  }

  Future<void> onRefresh() async {
    return await listSourceRepository.refresh(false);
  }
}

class ItemBuilder {
  static Widget itemBuilderList(BuildContext context, Product item, int index) {
    return Container(child: ProductTitle(item));
  }

  static Widget itemBuilderBig(BuildContext context, Product item, int index) {
    return ProductFull(item);
  }

  static Widget itemBuilderGrid(BuildContext context, Product item, int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final countPerRow = screenWidth < 450 ? 2 : 3;
    final imageWidth =
        (screenWidth - ((countPerRow + 1) * defaultPadding)) / countPerRow;
    final imageHeight = imageWidth * 4 / 3;

    return ProductBlock(
      item,
      imageHeight: imageHeight,
    );
  }
}
