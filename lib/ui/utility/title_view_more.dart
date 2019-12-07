import 'package:flutter/material.dart';

class TitleViewMore extends StatelessWidget {
  TitleViewMore({@required this.title, @required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: onPressed,
            child: Container(
              child: Row(
                children: <Widget>[
                  Text('Xem thêm'),
                  Icon(Icons.navigate_next),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
