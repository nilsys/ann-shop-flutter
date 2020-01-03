import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/provider/utility/blog_provider.dart';
import 'package:ann_shop_flutter/view/inapp/list_blog.dart';
import 'package:ann_shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogView extends StatefulWidget {
  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      Provider.of<BlogProvider>(context).checkReload();
    });
  }

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = Provider.of(context);
    final currentTitle = provider.currentCategory == null
        ? 'Ann Blog'
        : provider.currentCategory.name;
    String currentSlug = provider.currentCategory == null
        ? null
        : provider.currentCategory.filter.categorySlug;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
      ),
      body: ListBlog(
        currentSlug,
        topObject: _buildCategoryButtonList(),
      ),
    );
  }

  Widget _buildCategoryButtonList() {
    BlogProvider provider = Provider.of(context);

    if (Utility.isNullOrEmpty(provider.category.data)) {
      return null;
    } else {
      var categories = provider.category.data;
      return SliverPersistentHeader(
        pinned: false,
        floating: true,
        delegate: CommonSliverPersistentHeaderDelegate(
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 20, bottom: 5),
              width: double.infinity,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  index -= 1;
                  if (index < 0 || index == categories.length) {
                    return SizedBox(
                      width: 5,
                    );
                  }
                  BlogCategory item = categories[index];
                  bool selected = item.filter.categorySlug ==
                      provider.currentCategory.filter.categorySlug;
                  return ChoiceChip(
                    label: Text(
                      item.name,
                      textAlign: TextAlign.center,
                    ),
                    selected: selected,
                    onSelected: (value) {
                      provider.currentCategory = item;
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 10,
                  );
                },
                itemCount: categories.length + 2,
                scrollDirection: Axis.horizontal,
              ),
            ),
            55),
      );
    }
  }
}
