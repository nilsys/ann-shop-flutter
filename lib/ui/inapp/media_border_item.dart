import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';

import 'package:flutter/material.dart';

class MediaBorderItem extends StatelessWidget {
  MediaBorderItem(this.item);

  final Cover item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppStyles.cardColor,
        border: Border.all(color: AppStyles.borderColor, width: 1)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => showBloc(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16,16,16,0),
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16,8,16,8),
                child: RichText(
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(
                        text: item.message + '...',
                        style: Theme.of(context).textTheme.bodyText2),
                    TextSpan(
                      text: 'xem thêm >',
                      style: Theme.of(context).textTheme.bodyText2.merge(
                        TextStyle(color: Colors.blue),
                      ),
                    )
                  ]),
                ),
              ),
              if (isNullOrEmpty(item.images) == false) ...[
                const SizedBox(height: 8),
                ImageGrid(item.images),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void showBloc(BuildContext context) {
    if (AC.instance.canViewBlog) {
      AppAction.instance
          .onHandleAction(context, item.action, item.actionValue, item.name);
    } else {
      AppSnackBar.askLogin(context);
    }
  }
}
