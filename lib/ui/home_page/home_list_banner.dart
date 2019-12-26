import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeListBanner extends StatefulWidget {
  HomeListBanner({this.data});

  final List<Cover> data;

  @override
  _HomeListBannerState createState() => _HomeListBannerState();
}

class _HomeListBannerState extends State<HomeListBanner> {
  @override
  Widget build(BuildContext context) {
    if (Utility.isNullOrEmpty(widget.data) == false) {
      return SliverList(
        delegate: SliverChildListDelegate(
          widget.data
              .map((item) => _buildColumn(item))
              .toList(),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildColumn(Cover item){
    return Column(
      children: <Widget>[
        Container(
          height: 10,
          color: AppStyles.dividerColor,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding, defaultPadding, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            item.name,
            style: Theme.of(context).textTheme.title,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(defaultPadding,0 , defaultPadding, defaultPadding),
          alignment: Alignment.centerLeft,
          child: Text(
            '(' + Utility.fixFormatDate(item.createdDate) + ')',
            style: Theme.of(context).textTheme.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
//          padding: EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: (){
              AppAction.instance.onHandleAction(context, item.type, item.value, 'Banner');
            },
            child: AppImage(
              item.image,
              fit: BoxFit.fitWidth,
            ),
          ),
        )
      ],
    );
  }
}
