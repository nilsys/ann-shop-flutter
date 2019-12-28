import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:ann_shop_flutter/repository/inapp_repository.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:flutter/material.dart';

class InAppItem extends StatelessWidget {
  InAppItem(this.item);

  final InApp item;

  @override
  Widget build(BuildContext context) {
    bool isNew = false;
    return InkWell(
      onTap: () {
        if (Utility.isNullOrEmpty(item.action)) {
          AppPopup.showCustomDialog(context,
              title: item.name,
              message: item.message,
              btnNormal: ButtonData(title: 'Đóng'));
        } else {
          AppAction.instance.onHandleAction(
              context, item.action, item.actionValue, item.name);
        }
      },
      child: Container(
        color: isNew ? Colors.lightBlue[50] : Colors.white,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: InAppRepository.instance
                              .getColorInApp(item.kind)),
                      child: Icon(
                        InAppRepository.instance.getIconInApp(item.kind),
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              textAlign: TextAlign.start,
                              maxLines: 10,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Utility.fixFormatDate(item.createdDate),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 10),
                child: Text(
                  item.message,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 1,
                color: AppStyles.dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
