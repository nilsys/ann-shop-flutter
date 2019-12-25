import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/ui/product_ui/config_product_ui.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/view/list_product/custom_load_more_indicator.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProductByCategory extends StatefulWidget {
  ListProductByCategory(this.category);

  final Category category;

  @override
  _ListProductByCategoryState createState() => _ListProductByCategoryState();
}

class _ListProductByCategoryState extends State<ListProductByCategory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var message = Provider.of<DownloadImageProvider>(context).currentMessage;
    bool hasCategory = Utility.isNullOrEmpty(widget.category.children) == false;

    String categorySlug = widget.category.slug;
    List<String> categorySlugList;
    String productSearch;
    String tagSlug;
    if (widget.category.filter != null) {
      categorySlug = widget.category.filter.categorySlug;
      categorySlugList = widget.category.filter.categorySlugList;
      productSearch = widget.category.filter.productSearch;
      tagSlug = widget.category.filter.tagSlug;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: ListProduct(
          categoryCode: categorySlug,
          searchText: productSearch,
          tagName: tagSlug,
          categoryList: categorySlugList,
          appBar: CommonSliverPersistentHeaderDelegate(
              Column(
                children: <Widget>[
                  ConfigProductUI(),
                  hasCategory ? _buildCategoryButtonList() : Container(),
                ],
              ),
              hasCategory ? 110 : 60)),
      bottomNavigationBar:
          Utility.isNullOrEmpty(message) ? null : DownLoadBackground(),
    );
  }

  _buildCategoryButtonList() {
    var categories = widget.category.children;
    return Container(
      height: 45,
      color: Colors.white,
      padding: EdgeInsets.only(top: 10, bottom: 5),
      width: double.infinity,
      child: ListView.separated(
        itemBuilder: (context, index) {
          index -= 1;
          if (index < 0 || index == categories.length) {
            return SizedBox(
              width: 5,
            );
          }
          return _buildCategoryButton(categories[index]);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: categories.length + 2,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  _buildCategoryButton(Category item) {
    if (Utility.isNullOrEmpty(item.slug)) {
      return Container();
    } else {
      return ActionChip(
        label: Text(
          item.name,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87),
        ),
        onPressed: () {
          ListProduct.showByCategory(context, item);
        },
      );
    }
  }
}
