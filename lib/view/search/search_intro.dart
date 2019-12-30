import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/provider/utility/search_provider.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchIntro extends StatefulWidget {
  @override
  _SearchIntroState createState() => _SearchIntroState();
}

class _SearchIntroState extends State<SearchIntro> {
  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of(context);
    bool hasHotKey = Utility.isNullOrEmpty(provider.history) == false;
    bool hasHistory = Utility.isNullOrEmpty(provider.history) == false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: RefreshIndicator(
        onRefresh: () async {
          print('Check keyboard: ${MediaQuery.of(context).viewInsets.bottom}');
          if (MediaQuery.of(context).viewInsets.bottom > 100 || true) {
            print('Close keyboard');
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        child: ListView(
          children: <Widget>[
            hasHotKey
                ? Container(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Từ Khoá Hot',
                            style: Theme.of(context).textTheme.title,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            hasHotKey
                ? Wrap(
                    children: provider.hotKeys.data
                        .map((title) => _buildHotKey(title))
                        .toList(),
                  )
                : Container(),
            hasHistory
                ? Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.watch_later,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Lịch Sử',
                            style: Theme.of(context).textTheme.title,
                            maxLines: 1,
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'XOÁ',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            provider.removeHistoryAll();
                          },
                        )
                      ],
                    ),
                  )
                : Container(),
            hasHistory
                ? Wrap(
                    children: provider.history
                        .map((title) => _buildHistory(title))
                        .toList(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildHotKey(Category item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:5.0),
      child: ActionChip(
          label: Text(item.name, textAlign: TextAlign.center),
          onPressed: () {
            ListProduct.showBySearch(context, item);
          }),
    );
  }

  Widget _buildHistory(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ActionChip(
          label: Text(title, textAlign: TextAlign.center),
          onPressed: () {
            Provider.of<SearchProvider>(context).onSearch(context, title);
          }),
    );
  }
}
