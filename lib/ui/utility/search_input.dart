import 'package:ann_shop_flutter/core/app_icons.dart';
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
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: TextField(
          controller: Provider.of<SearchProvider>(context).controller,
          style: Theme.of(context).textTheme.body1,
          autofocus: true,
          showCursor: true,
          cursorColor: Colors.black87,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              icon: Icon(
                AppIcons.search,
                size: 20,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .merge(TextStyle(fontStyle: FontStyle.italic)),
              hintText: 'Tên sản phẩm, Mã sản phẩm...'),
          onSubmitted: (text) {
            Provider.of<SearchProvider>(context).onSearch(
                context, Provider.of<SearchProvider>(context).controller.text);
          }),
    );
  }

  _buildIconClear() {
    return IconButton(
      icon: Icon(
        Icons.clear,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          Provider.of<SearchProvider>(context).setText();
        });
      },
    );
  }
}
