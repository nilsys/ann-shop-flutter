import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/src/themes/ann_color.dart';
import 'package:ann_shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:ann_shop_flutter/ui/utility/ann-logo.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_bar_policy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPasswordView extends StatefulWidget {
  const LoginPasswordView(this.phone);

  final String phone;

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
        FocusScope.of(context).requestFocus(FocusNode());
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
        title: const Text('Đăng nhập'),
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
                margin: const EdgeInsets.only(top: 50, bottom: 40),
                child: AnnLogo(),
              ),
              TextFormField(
                initialValue: widget.phone,
                style: TextStyle(fontWeight: FontWeight.w600),
                enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                autofocus: true,
                obscureText: !showPassword,
                style: TextStyle(fontWeight: FontWeight.w600),
                onFieldSubmitted: (String value) {
                  _validateInput();
                },
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
                onSaved: (value) {
                  password = value;
                },
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(color: ANNColor.white),
                ),
                onPressed: _validateInput,
              ),
              const SizedBox(height: 15),
              RaisedButton(
                color: ANNColor.white,
                child: const Text('Quên mật khẩu?'),
                onPressed: () {
                  Navigator.pushNamed(context, 'user/forgot_password',
                      arguments: widget.phone);
                },
              ),
              const SizedBox(height: 30),
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
    final bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        final loadingDialog = new LoadingDialog(context, message: 'Đăng nhập...');

        loadingDialog.show();
        final AppResponse response =
            await AccountRepository.instance.login(widget.phone, password);
        loadingDialog.close();

        if (response.status) {
          AccountController.instance.finishLogin(response.data);
          Navigator.pushNamedAndRemoveUntil(
              context, 'home', (Route<dynamic> route) => false);
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
