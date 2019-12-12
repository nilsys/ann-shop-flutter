import 'package:flutter/material.dart';

class EmptyListUI extends StatelessWidget {
  EmptyListUI({this.image, this.title, this.body});

  final title;
  final body;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Icon(
            Icons.redeem,
            size: 30,
          ),
        ),
        title == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
              ),
        body == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                ),
              ),
      ],
    );
  }
}
