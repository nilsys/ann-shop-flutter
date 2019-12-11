import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/provider/utility/seach_provider.dart';
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
            children: <Widget>[
              _buildHotKey('Quần áo nam'),
              _buildHotKey('Quần áo nữ'),
              _buildHotKey('Free size'),
              _buildHotKey('Bao lì xì'),
              _buildHotKey('Đầm nữ'),
              _buildHotKey('Quần short'),
              _buildHotKey('Nước hoa'),
              _buildHotKey('Khuyến mãi'),
              _buildHotKey('Hàng order'),
              _buildHotKey('Hàng tồn kho'),
            ],
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
                          provider.history = [];
                        },
                      )
                    ],
                  ),
                ),
          Utility.isNullOrEmpty(provider.history)
              ? Container()
              : Column(
                  children: provider.history
                      .map((title) => _buildHistory(title))
                      .toList(),
                )
        ],
      ),
    );
  }

  Widget _buildHistory(String title) {
    return InkWell(
      onTap: () {
        Provider.of<SearchProvider>(context).setText(text: title);
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
          height: 35,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear, size: 20,),
                onPressed: () {
                  Provider.of<SearchProvider>(context).removeHistoryUnit(title);
                },
              )
            ],
          )),
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
