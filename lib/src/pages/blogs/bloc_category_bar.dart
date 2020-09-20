import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/provider/utility/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';

class BlogCategoryBar extends StatefulWidget {
  const BlogCategoryBar({this.appBarKey});

  final GlobalKey appBarKey;

  @override
  _BlogCategoryBarState createState() => _BlogCategoryBarState();
}

class _BlogCategoryBarState extends State<BlogCategoryBar> {

  final double heightBar = 32;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showCategory,
      child: Container(
        height: heightBar,
        decoration: BoxDecoration(color: AppStyles.orange.withAlpha(100)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildCurrentCategory(),
      ),
    );
  }

  Widget _buildCurrentCategory() {
    final BlogProvider provider = Provider.of(context, listen: false);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Text(
            provider.currentCategory?.name ?? "Tất cả",
            textAlign: TextAlign.right,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14),
          ),
        ),
        Icon(Icons.arrow_drop_down, color: Colors.grey),
      ],
    );
  }

  Future showCategory() async {
    final BlogProvider provider = Provider.of(context, listen: false);
    if (provider.loading != null) {
      showLoading(context);
      await Future.wait([provider.loading]);
      hideLoading(context);
    }
    final categories = provider.category.data;
    clearOverlay();
    final RenderBox renderBox = context.findRenderObject();
    final double size = renderBox.size.width;
    final double childAspectRatio = size / 3 / 46;
    final double appBarBox = widget.appBarKey == null
        ? 0
        : (widget.appBarKey.currentContext.findRenderObject() as RenderBox)
            .size
            .height;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
          color: Colors.black.withAlpha(80),
          child: InkWell(
            onTap: clearOverlay,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: appBarBox),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: heightBar,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCurrentCategory(),
                    ),
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: size / 3,
                          width: 0.6,
                          child: Container(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: size / 3,
                          width: 0.6,
                          child: Container(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        GridView.builder(
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 0,
                              childAspectRatio: childAspectRatio,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: categories.length,
                            itemBuilder: (context, i) {
                              return _buildItem(
                                context,
                                item: categories[i],
                                current: provider.currentCategory,
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  Widget _buildItem(BuildContext context,
      {@required BlogCategory item, @required BlogCategory current}) {
    final bool isChoose =
        item.filter.categorySlug == current.filter.categorySlug;
    return InkWell(
      onTap: () {
        if (isChoose == false) {
          Provider.of<BlogProvider>(context, listen: false).currentCategory =
              item;
        }
        clearOverlay();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          item.name,
          maxLines: 2,
          textAlign: TextAlign.left,
          style: isChoose
              ? TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                  fontSize: 14)
              : TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14),
        ),
      ),
    );
  }

  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  OverlayEntry overlayEntry;
}
