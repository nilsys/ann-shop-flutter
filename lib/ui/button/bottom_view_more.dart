import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';

class BottomViewMore extends StatelessWidget {
  BottomViewMore({this.onPressed});

  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
          border:
              Border(top: BorderSide(color: AppStyles.dividerColor, width: 1))),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'XEM THÊM',
              style: Theme.of(context).textTheme.button.merge(
                    TextStyle(color: Theme.of(context).primaryColor),
                  ),
            ),
            Icon(
              Icons.navigate_next,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
