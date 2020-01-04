import 'package:ann_shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:flutter/material.dart';

class OrderManagementView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
      ),
      body: Container(
        child: EmptyListUI(
          image: Icon(Icons.redeem),
          body: 'Bạn chưa có hoá đơn nào',
        ),
      ),
    );
  }
}
