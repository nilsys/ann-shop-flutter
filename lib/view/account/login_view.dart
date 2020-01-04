import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset < -50) {
        if (MediaQuery.of(context).viewInsets.bottom > 100 || true) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      }
    });
    showPassword = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;
  String phone;
  String otp;
  bool showPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Số di động',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              TextFormField(
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại',
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1, style: BorderStyle.solid),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: Validator.phoneNumberValidator,
                onSaved: (String value) {
                  phone = value;
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Mật khẩu/ Mã OTP',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              Stack(children: [
                TextFormField(
                  obscureText: showPassword,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu/ Mã OTP',
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                  ),
                  validator: Validator.passwordValidator,
                  onSaved: (String value) {
                    otp = value;
                  },
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppStyles.dartIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                )
              ]),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildTextButton('Gửi mã OTP'),
                    _buildTextButton('Quên mật khẩu'),
                  ],
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: FlatButton(
                  child: Text(
                    'Đăng nhập',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .merge(TextStyle(color: Colors.white)),
                  ),
                  onPressed: _validateInput,
                ),
              ),
              Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Chưa có tài khoản? '),
                    _buildTextButton('Đăng ký ngay!'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, {GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline),
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
    } else {
      Navigator.pushNamed(context, '/update-information');
    }
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }
}
