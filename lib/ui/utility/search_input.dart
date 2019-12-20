import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/provider/utility/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatefulWidget {
  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: TextField(
                controller: Provider.of<SearchProvider>(context).controller,
                style: TextStyle(color: Colors.white),
                autofocus: true,
                showCursor: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 1),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Tên sản phẩm, Mã sản phẩm...'),
                onSubmitted: (text) {
                  Provider.of<SearchProvider>(context).onSearch(context,
                      Provider.of<SearchProvider>(context).controller.text);
                }),
          ),
          Utility.isNullOrEmpty(Provider.of<SearchProvider>(context).text)
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      Provider.of<SearchProvider>(context).setText();
                    });
                  },
                ),
        ],
      ),
    );
  }
}
