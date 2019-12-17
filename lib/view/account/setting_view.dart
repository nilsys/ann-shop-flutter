import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/currency_input_formatter.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/copy_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CopySetting copy = Core.copySetting;
    controllerBonus =
        TextEditingController(text: Utility.formatPrice(copy.bonusPrice));
    controllerPhone = TextEditingController(text: copy.phoneNumber.toString());
    controllerAddress = TextEditingController(text: copy.address.toString());
    setState(() {
      valueCode = copy.productCode;
      valueName = copy.productName;
    });
  }

  TextEditingController controllerBonus = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  bool valueCode = false;
  bool valueName = false;

  _saveSetting() {
    String _value = controllerBonus.text ?? '';
    _value = _value.replaceAll(',', '');
    int _bonus = _value.isEmpty ? 0 : int.parse(_value);
    CopySetting copy = CopySetting(
      productName: valueName,
      productCode: valueCode,
      address: controllerAddress.text,
      phoneNumber: controllerPhone.text,
      bonusPrice: _bonus,
    );
    Core.updateCopySetting(copy);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveSetting();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cài đặt'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _saveSetting();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child: CustomScrollView(physics: BouncingScrollPhysics(), slivers: <
              Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildTitleCommon('Cài đặt copy sản phẩm'),
                  _buildItemCommon('Mã sản phẩm',
                      trailing: CupertinoSwitch(
                        value: valueCode,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          valueCode = value;
                        },
                      )),
                  _buildItemCommon('Tên sản phẩm',
                      trailing: CupertinoSwitch(
                        value: valueName,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setState(() {
                            valueName = value;
                          });
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      controller: controllerBonus,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: 'Giá lẽ cộng thêm (vnđ)'),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter()
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      controller: controllerPhone,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      decoration:
                          InputDecoration(labelText: 'Điện thoại của khách'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      controller: controllerAddress,
                      keyboardType: TextInputType.text,
                      decoration:
                          InputDecoration(labelText: 'Địa chỉ của khách'),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildTitleCommon(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
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
      child: ListTile(
        onTap: null,
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
