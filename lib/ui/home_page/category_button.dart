import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Category item;

  CategoryButton(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ExtendedImage.network(
                  domain + this.item.icon,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            width: 80,
            child: Text(
              this.item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
