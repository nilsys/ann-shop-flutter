import 'package:ann_shop_flutter/model/utility/blog_category.dart';
import 'package:ann_shop_flutter/provider/utility/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';

class BlogCategoryPopup extends StatelessWidget {
  const BlogCategoryPopup(this.animation, this.animation2);

  final Animation<double> animation;
  final Animation<double> animation2;

  @override
  Widget build(BuildContext context) {
    final BlogProvider provider = Provider.of(context, listen: false);
    final List<BlogCategory> data = provider.category.data ?? [];
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            children: [
              InkWell(
                onTap: ()=>Navigator.of(context).pop(),
                child: Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: BoxDecoration(color: Colors.green),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Danh mục sản phẩm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 16, top: 8),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _buildItem(
                      context,
                      item: data[index],
                      current: provider.currentCategory,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Text(
                      Utility.l_i_n_e,
                      maxLines: 1,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context,
      {@required BlogCategory item, @required BlogCategory current}) {
    final bool isChoose =
        item.filter.categorySlug == current.filter.categorySlug;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<BlogProvider>(context, listen: false).currentCategory =
            item;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
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
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14),
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  size: 18,
                  color: Colors.grey,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
