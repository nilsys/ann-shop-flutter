import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _phoneNumberController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  var phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nhập số điện thoại'),
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 10,
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey,
                    labelText: 'Nhập số điện thoại',
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: Utility.phoneNumberValidator,
                  onSaved: (String value) {
                    phone = value;
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ButtonTheme(
                        height: 45,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: Text('Tiếp tục'),
                          onPressed: _validateInput,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      goToVerifiedNumber();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future goToVerifiedNumber() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    }else {
      Navigator.pushNamed(context, '/');
    }
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }
}
