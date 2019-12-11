import 'package:ann_shop_flutter/provider/utility/seach_provider.dart';
import 'package:ann_shop_flutter/ui/utility/search_input.dart';
import 'package:ann_shop_flutter/view/search/search_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: SearchInput(),
        ),
        body: SearchIntro(),
      ),
    );
  }
}
