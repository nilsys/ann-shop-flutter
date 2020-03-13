import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:flutter/material.dart';

class SearchTitle extends StatelessWidget {
  SearchTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'search');
      },
      child: Container(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              AppIcons.search,
              size: 20,
              color: Colors.grey,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 1,
              child: Text(
                text ?? 'Bạn tìm gì hôm nay?',
                style: Theme.of(context).textTheme.body1,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
