import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:flutter/material.dart';

class AppPopup {
  static Future<void> showCustomDialog(BuildContext context,
      {String title,
      Widget titleWidget,
      List<Widget> content,
      List<Widget> actions,
      bool barrierDismissible = true}) async {
    if (titleWidget == null && title != null) {
      titleWidget = Text(
        title,
        textAlign: TextAlign.center,
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleWidget,
          content: SingleChildScrollView(
            child: ListBody(
              children: content,
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  static Future<void> showBottomSheet(BuildContext context,
      {String title, List<Widget> content}) async {
    Widget titleWidget;
    if (Utility.isNullOrEmpty(title) == false) {
      titleWidget = Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
            style: BorderStyle.solid,
          )),
        ),
        height: kToolbarHeight,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                softWrap: true,
              ),
            ),
            Container(
              width: 40,
            ),
          ],
        ),
      );
    }
    List<Widget> _children = [
      Container(
        height: titleWidget != null ? 60 : 15,
      )
    ];
    _children.addAll(content);
    _children.add(Container(
      height: 20,
    ));
    Widget _scrollWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: ListBody(
          children: _children,
        ),
      ),
    );

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: titleWidget == null
              ? _scrollWidget
              : Stack(
                  children: <Widget>[
                    _scrollWidget,
                    Align(
                      alignment: Alignment.topCenter,
                      child: titleWidget,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

enum MenuItem { edit, delete, open, setDefault }

class ButtonData {
  ButtonData(this.text, {this.onPressed});

  final String text;
  final VoidCallback onPressed;
}

class CenterButtonPopup extends StatelessWidget {
  CenterButtonPopup({this.normal, this.highlight});

  final ButtonData normal;
  final ButtonData highlight;

  @override
  Widget build(BuildContext context) {
    Widget btnNormal;
    if (normal != null) {
      btnNormal = ButtonTheme(
        height: 35,
        child: RaisedButton(
          color: Colors.white,
          child: Text(
            normal.text,
            style: TextStyle(color: Colors.black87),
          ),
          onPressed: () {
            Navigator.pop(context);
            if (normal.onPressed != null) {
              normal.onPressed();
            }
          },
        ),
      );
    }
    Widget btnHighlight;
    if (highlight != null) {
      btnHighlight = ButtonTheme(
        height: 35,
        child: RaisedButton(
          child: Text(
            highlight.text,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
            if (highlight.onPressed != null) {
              highlight.onPressed();
            }
          },
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: (btnNormal != null && btnHighlight != null)
          ? Row(
              children: <Widget>[
                Expanded(
                  child: btnNormal,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: btnHighlight,
                ),
              ],
            )
          : Center(
              child: btnNormal ?? btnHighlight,
            ),
    );
  }
}
