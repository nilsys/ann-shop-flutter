import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/provider/utility/seach_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchIntro extends StatefulWidget {
  @override
  _SearchIntroState createState() => _SearchIntroState();
}

class _SearchIntroState extends State<SearchIntro> {
  final hotKeys = [
    'Quần áo nam',
    'Quần áo nữ',
    'Free size',
    'Bao lì xì',
    'Đầm nữ',
    'Quần short',
    'Nước hoa',
    'Khuyến mãi',
    'Hàng order',
    'Hàng tồn kho'
  ];

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: ListView(
        children: <Widget>[
          Container(
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
          ),
          Wrap(
            children: hotKeys.map((title) => _buildHotKey(title)).toList(),
          ),
          Utility.isNullOrEmpty(provider.history)
              ? Container()
              : Container(
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
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          provider.removeHistoryAll();
                        },
                      )
                    ],
                  ),
                ),
          Utility.isNullOrEmpty(provider.history)
              ? Container()
              : Wrap(
                  children: provider.history
                      .map((title) => _buildHotKey(title))
                      .toList(),
                )
        ],
      ),
    );
  }

  Widget _buildHotKey(String title) {
    return InkWell(
      onTap: () {
        Provider.of<SearchProvider>(context).setText(text: title);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey[300]),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
