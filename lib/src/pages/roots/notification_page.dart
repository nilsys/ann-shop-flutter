import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/provider/utility/inapp_repository.dart';
import 'package:ann_shop_flutter/ui/inapp/inapp_category_ui.dart';
import 'package:ann_shop_flutter/ui/utility/request_login.dart';
import 'package:ann_shop_flutter/view/inapp/list_inapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
          title: Text(InAppRepository.instance.getNameInApp(
              Provider.of<InAppProvider>(context).currentCategory)),
        ),
        body: _buildPageData(),
      ),
      onRefresh: () => _onRefresh(context),
    );
  }

  Widget _buildPageData() {
    if (AC.instance.isLogin == false) {
      return RequestLogin();
    }

    InAppProvider provider = Provider.of(context);

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            decoration: BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1, color: Colors.grey[400])),
            ),
            child: InAppCategoryUI(),
          ),
          Expanded(
            flex: 1,
            child: ListInApp(
              kind: provider.currentCategory,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {}
}
