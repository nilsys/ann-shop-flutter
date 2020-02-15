import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterInputPasswordView extends StatefulWidget {
  @override
  _RegisterInputPasswordViewState createState() =>
      _RegisterInputPasswordViewState();
}

class _RegisterInputPasswordViewState extends State<RegisterInputPasswordView> {
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
  String confirmPassword;
  String password;
  bool showPassword;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tạo mật khẩu'),
          leading: Container(),
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                SizedBox(height: 50),
                TextFormField(
                  obscureText: !showPassword,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                TextFormField(
                  obscureText: !showPassword,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      helperText: ' ',
                      hintText: 'Nhập lại mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      )),
                  validator: Validator.passwordValidator,
                  onSaved: (String value) {
                    confirmPassword = value;
                  },
                ),
                SizedBox(height: 15),
                RaisedButton(
                  child: Text(
                    'Tạo mật khẩu',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _validateInput,
                ),
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
      if (password != confirmPassword) {
        AppSnackBar.showFlushbar(context, 'Nhập lại mật khẩu chưa đúng');
      } else {
        onSubmit();
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future onSubmit() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context);
        AppResponse response = await AccountRepository.instance
            .registerStep4CreatePassword(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.otp, password);
        hideLoading(context);
        if (response.status) {
          AccountController.instance.finishLogin(response.data);
          Provider.of<NavigationProvider>(context, listen: false).index =
              PageName.home.index;
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
          if (AccountRegisterState.instance.isRegister) {
            Navigator.pushNamed(context, '/update-information',
                arguments: true);
          }
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
