import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';

class EmptyListUI extends StatelessWidget {
  EmptyListUI({this.image, this.title, this.body});

  final title;
  final body;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: image == null
                ? SizedBox(
              width: 80,
              height: 80,
              child:
              Image.asset('assets/images/ui/recycle_bin_empty.png'),
            )
                : image,
          ),
          title == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.display1,
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
      ),
    );
  }
}
