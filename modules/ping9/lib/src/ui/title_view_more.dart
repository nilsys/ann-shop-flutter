import 'package:flutter/material.dart';
import 'package:ping9/src/core/utility.dart';
import 'package:ping9/src/theme/app_styles.dart';

class TitleViewMore extends StatelessWidget {
  TitleViewMore({@required this.title, this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (onPressed != null) {
      return InkWell(
        onTap: onPressed,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Xem thêm'),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        color: AppStyles.titleBlockColor,
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
