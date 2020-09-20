import 'package:ann_shop_flutter/src/pages/blogs/bloc_category_bar.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/provider/utility/blog_provider.dart';
import 'package:ann_shop_flutter/ui/utility/request_login.dart';
import 'package:ann_shop_flutter/view/inapp/list_blog.dart';
import 'package:ann_shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      Provider.of<BlogProvider>(context, listen: false).checkReload();
    });
  }

  final GlobalKey appBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = Provider.of<BlogProvider>(context);
    String title;
    String slug;

    // Get title
    if (provider.currentCategory == null)
      title = 'Bài viết';
    else
      title = provider.currentCategory.name;

    // Get slug
    if (provider.currentCategory == null)
      slug = null;
    else
      slug = provider.currentCategory.filter.categorySlug;

    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        title: Text(title),
        elevation: 0,
        titleSpacing: 0,
      ),
      body: AC.instance.isLogin == false
          ? RequestLogin()
          : Column(
              children: [
                BlogCategoryBar(
                  appBarKey: appBarKey,
                ),
                Expanded(
                  child: ListBlog(slug),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryButtonList(BlogProvider provider) {
    if (isNullOrEmpty(provider.category.data)) return null;

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
        55,
      ),
    );
  }
}
