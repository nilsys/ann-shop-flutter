import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/acount/account.dart';
import 'package:flutter/material.dart';

class AddInformation extends StatefulWidget {
  @override
  _AddInformationState createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  Account account;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    account = new Account();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cập nhật thông tin'),
        actions: <Widget>[
          FlatButton(
            child: Text('Để sau'),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ButtonTheme(
          height: 45,
          child: FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text('Hoàn thành'),
            onPressed: () {
              onFinish();
            },
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                initialValue: account.fullName,
                maxLength: 40,
                decoration: InputDecoration(
                  filled: true,
                  counterText: '',
                  fillColor: Colors.grey,
                  hintText: 'Họ và Tên',
                  labelText: 'Họ và Tên',
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1, style: BorderStyle.solid),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty == true) {
                    return 'Vui long nhập Họ và Tên';
                  }
                  return null;
                },
                onSaved: (String value) {
                  account.fullName = value;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Giới tín',
              ),
              Row(
                children: <Widget>[
                  Text('Nam'),
                  Checkbox(
                    value: account.gender == 1,
                    onChanged: (bool value) {
                      setState(
                        () {
                          if (value == true) {
                            account.gender = 1;
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text('Nữ'),
                  Checkbox(
                    value: account.gender != 1,
                    onChanged: (bool value) {
                      setState(
                        () {
                          if (value == true) {
                            account.gender = 0;
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isProcess = false;

  Future onFinish() async {}
}
