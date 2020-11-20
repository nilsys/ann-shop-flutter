import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/provider/utility/blog_provider.dart';
import 'package:ann_shop_flutter/ui/utility/request_login.dart';
import 'package:ann_shop_flutter/view/inapp/list_blog.dart';
import 'package:ann_shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blog_category_popup.dart';

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
    final String slug = provider.currentCategory?.filter?.categorySlug;
    final String title = provider.currentCategory?.name ?? "Bài viết";

    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        title: Text(title),
        titleSpacing: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: "Dismissible",
                  pageBuilder: (context, anim1, anim2) {
                    return BlogCategoryPopup(anim1, anim2);
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(1, 0), end: Offset(0, 0))
                          .animate(anim1),
                      child: child,
                    );
                  },
                );
              }),
        ],
      ),
      body: AC.instance.isLogin == false ? RequestLogin() : ListBlog(slug),
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
          width: double.infinity,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
            itemBuilder: (context, index) {
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
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
        55,
      ),
    );
  }
}
