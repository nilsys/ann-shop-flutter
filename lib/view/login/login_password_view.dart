import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/provider/utility/account_repository.dart';
import 'package:ann_shop_flutter/provider/utility/app_response.dart';
import 'package:ann_shop_flutter/src/route/route.dart';
import 'package:ann_shop_flutter/src/models/ann_page.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/ui/utility/ann-logo.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_bar_policy.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class LoginPasswordView extends StatefulWidget {
  const LoginPasswordView(this.phone);

  final String phone;

  @override
  _LoginPasswordViewState createState() => _LoginPasswordViewState();
}

class _LoginPasswordViewState extends State<LoginPasswordView> {
  // region Parameters
  final _formKey = GlobalKey<FormState>();

  AC _accountController;

  String password;
  bool showPassword;

  @override
  void initState() {
    super.initState();
    _accountController = AC.instance;
    if (_accountController.account != null &&
        !isEmpty(_accountController.account.password)) {
      password = _accountController.account.password;
    }
    showPassword = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      bottomNavigationBar: BottomBarPolicy(),
      body: DismissKeyBoard(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView(
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
                  initialValue: password,
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
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _validateInput,
                ),
                const SizedBox(height: 15),
                RaisedButton(
                  color: Colors.white,
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
      ),
    );
  }

  void _validateInput() {
    FocusScope.of(context).requestFocus(FocusNode());
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      onLogin();
    }
  }

  Future onLogin() async {
    final bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context, message: 'Đăng nhập...');
        final AppResponse response =
            await AccountRepository.instance.login(widget.phone, password);
        hideLoading(context);

        if (response.status) {
          AC.instance.finishLogin(response.data, password);
          Routes.navigateLogin(context, ANNPage.home);
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
