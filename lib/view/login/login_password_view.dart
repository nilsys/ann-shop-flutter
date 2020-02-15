import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/utility/ann-logo.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_bar_policy.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPasswordView extends StatefulWidget {
  LoginPasswordView(this.phone);

  final phone;

  @override
  _LoginPasswordViewState createState() => _LoginPasswordViewState();
}

class _LoginPasswordViewState extends State<LoginPasswordView> {
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
  String password;
  bool showPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      bottomNavigationBar: BottomBarPolicy(),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                height: 100,
                margin: EdgeInsets.only(top: 50, bottom: 40),
                child: AnnLogo(),
              ),
              TextFormField(
                initialValue: widget.phone,
                style: TextStyle(fontWeight: FontWeight.w600),
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                obscureText: !showPassword,
                style: TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'Nhập mật khẩu',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )),
                validator: Validator.passwordValidator,
                onSaved: (String value) {
                  password = value;
                },
              ),
              SizedBox(height: 15),
              RaisedButton(
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _validateInput,
              ),
              SizedBox(height: 15),
              RaisedButton(
                color: Colors.grey[200],
                child: Text(
                  'Quên mật khẩu?',
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_password',
                      arguments: widget.phone);
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInput() {
    FocusScope.of(context).requestFocus(FocusNode());
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      onLogin();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future onLogin() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context, message: 'Đăng nhập...');
        AppResponse response =
            await AccountRepository.instance.login(widget.phone, password);
        hideLoading(context);
        if (response.status) {
          AccountController.instance.finishLogin(response.data);
          Navigator.pushReplacementNamed(context, '/home');
          Provider.of<NavigationProvider>(context, listen: false).index =
              PageName.home.index;
        } else {
          AppSnackBar.showFlushbar(context,
              response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
        }
      } catch (e) {
        print(e);
        AppSnackBar.showFlushbar(
            context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    }
  }
}
