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
          widget.data.map((item) => _buildColumn(item)).toList(),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildColumn(Cover item) {
    String _body =
        item.message.length <= 150 ? item.message : item.message.substring(0, 149);
    return Column(
      children: <Widget>[
        Container(
          height: 10,
          color: AppStyles.dividerColor,
        ),
        InkWell(
          onTap: (){
            AppAction.instance
                .onHandleAction(context, item.action, item.actionValue, item.name);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(defaultPadding),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Utility.isNullOrEmpty(item.image)
                      ? Container()
                      : Container(
                          width: 100,
                          height: double.infinity,
                          margin: EdgeInsets.only(right: 15),
                          child: AppImage(
                            item.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Utility.fixFormatDate(item.createdDate),
                            style: Theme.of(context).textTheme.body2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: _body + '...',
                                  style: Theme.of(context).textTheme.body1),
                              TextSpan(
                                text: 'xem thêm >',
                                style: Theme.of(context).textTheme.body1.merge(
                                      TextStyle(color: Colors.blue),
                                    ),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
