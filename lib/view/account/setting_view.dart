import 'package:ann_shop_flutter/model/utility/copy_setting.dart';
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    CopySetting copy = Provider.of<ConfigProvider>(context).copySetting;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          FavoriteButton(color: Colors.white),
        ],
      ),
      body: Container(
        child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                _buildTitleCommon('Cài đặt copy sản phẩm'),
                _buildItemCommon('Mã sản phẩm',
                    trailing: CupertinoSwitch(
                      value: copy.productCode,
                      onChanged: (value) {},
                    )),
                _buildItemCommon('Tên sản phẩm',
                    trailing: CupertinoSwitch(
                      value: copy.productName,
                      onChanged: (value) {},
                    )),
                _buildItemCommon('Giá lẽ cộng thêm',
                    trailing: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(),
                      ),
                    )),
                _buildItemCommon('Điện thoại của khách',
                    trailing: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(),
                      ),
                    )),
                _buildItemCommon('Địa chỉ của khách',
                    trailing: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(),
                      ),
                    )),
              ]))
            ]),
      ),
    );
  }

  Widget _buildTitleCommon(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      child: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _buildItemCommon(String title, {trailing}) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: ListTile(
        onTap: null,
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
