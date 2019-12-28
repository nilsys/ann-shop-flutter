import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/inapp/inapp_category_ui.dart';
import 'package:ann_shop_flutter/view/inapp/list_inapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InAppView extends StatefulWidget {
  @override
  _InAppViewState createState() => _InAppViewState();
}

class _InAppViewState extends State<InAppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
      ),
      body: _buildPageData(),
    );
  }

  Widget _buildPageData() {
    InAppProvider provider = Provider.of(context);

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(width: 1, color: AppStyles.dividerColor)),
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
}
