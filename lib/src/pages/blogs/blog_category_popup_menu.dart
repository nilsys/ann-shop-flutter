import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/provider/utility/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogCategoryPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BlogProvider provider = Provider.of(context, listen: false);
    return PopupMenuButton<BlogCategory>(
      icon: Icon(
        Icons.filter_list_outlined,
        color: Colors.white,
      ),
      onSelected: (value) {
        Provider.of<BlogProvider>(context, listen: false).currentCategory =
            value;
      },
      // offset: Offset(0, 100),
      itemBuilder: (BuildContext context) => <PopupMenuItem<BlogCategory>>[
        for (final item in provider.category.data ?? [])
          _buildItem(
            context,
            item: item,
            current: provider.currentCategory,
          )
      ],
    );
  }

  Widget _buildItem(BuildContext context,
      {@required BlogCategory item, @required BlogCategory current}) {
    final bool isChoose =
        item.filter.categorySlug == current.filter.categorySlug;
    return CheckedPopupMenuItem<BlogCategory>(
      checked: isChoose,
      value: item,
      child: Text(
        item.name,
        // maxLines: 2,
        // textAlign: TextAlign.left,
        style: isChoose
            ? TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
                fontSize: 14)
            : TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
      ),
    );
  }
}
