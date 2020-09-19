import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/repository/utility_repository.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPolicy extends StatefulWidget {
  @override
  _ShopPolicyState createState() => _ShopPolicyState();
}

class _ShopPolicyState extends State<ShopPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chính sách bán hàng'),
      ),
      body: FutureProvider<List<Cover>>(
          create: (_) => UtilityRepository.instance.loadPolicy(),
          child: Consumer<List<Cover>>(
            builder: (key, List<Cover> data, child) {
              if (isNullOrEmpty(data)) {
                return Indicator();
              } else {
                return ListView(
                  children: data.map((item) => _buildItem(item)).toList(),
                );
              }
            },
          )),
    );
  }

  Widget _buildItem(Cover item) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: ListTile(
        onTap: () {
          AppAction.instance.onHandleAction(
              context, item.action, item.actionValue, item.name);
        },
        leading: Icon(
          Icons.question_answer,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(item.name),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: AppStyles.dividerColor),
      ),
    );
  }
}
