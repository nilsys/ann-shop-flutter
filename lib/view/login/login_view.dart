import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/button/text_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String password;
  bool showPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: TextButton(
            'Chính sách và điều khoản của ANN',
            onPressed: () {
              Navigator.pushNamed(context, '/web-view', arguments: {
                'url': 'https://ann.com.vn/chinh-sach-bao-mat-thong-tin',
                'title': 'Chính sách và điều khoản'
              });
            },
          ),
        ),
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
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
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
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Mật khẩu',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              Stack(children: [
                TextFormField(
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
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
                    password = value;
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
              SizedBox(height: 30),
              PrimaryButton(
                'Đăng nhập',
                onPressed: _validateInput,
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton('Đăng ký ngay', onPressed: () {
                      AccountRegisterState.instance.reset(true);
                      Navigator.pushNamed(context, '/register_input_phone');
                    }),
                    TextButton('Quên mật khẩu', onPressed: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInput() {
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
            await AccountRepository.instance.login(phone, password);
        hideLoading(context);
        if (response.status) {
          AccountController.instance.finishLogin(response.data);
          Provider.of<NavigationProvider>(context).index = PageName.home.index;
          Navigator.pushReplacementNamed(context, '/home');
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
