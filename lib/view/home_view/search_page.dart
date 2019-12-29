import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/provider/utility/search_provider.dart';
import 'package:ann_shop_flutter/ui/utility/search_input.dart';
import 'package:ann_shop_flutter/view/search/search_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  SearchPage({this.showIcon = false});

  final showIcon;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: showIcon
              ? Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(AppIcons.search),
                )
              : null,
          title: SearchInput(),
        ),
        body: SearchIntro(),
      ),
    );
  }
}
