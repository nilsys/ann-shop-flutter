import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/ui/list_product/popup_product_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFilterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onSave(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.close),onPressed: (){
            onSave(context);
            Navigator.pop(context);
          },),
          title: Text('Lọc sản phẩm theo?'),
        ),
        body: PopupProductFilter(),
      ),
    );
  }

  void onSave(context) {
    Provider.of<ConfigProvider>(context).saveFilter();
  }
}
