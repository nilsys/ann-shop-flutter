import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';
import 'package:ping9/src/theme/app_styles.dart';

class BottomViewMore extends StatelessWidget {
  BottomViewMore({this.onPressed, this.blockName = ""});

  final onPressed;
  final String blockName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: AppStyles.viewMoreColor,
          border: Border(
              top:
                  BorderSide(color: Theme.of(context).dividerColor, width: 1))),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isNullOrEmpty(blockName)
                  ? 'XEM THÊM'
                  : 'XEM THÊM ${this.blockName.toUpperCase()}',
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
