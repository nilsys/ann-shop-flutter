import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/button/border_button.dart';
import 'package:ann_shop_flutter/ui/utility/ann-logo.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_bar_policy.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;
  String phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kho Hàng Sỉ ANN'),
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
                maxLength: 10,
                style: TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone),
                  hintText: 'Nhập số điện thoại',
                ),
                keyboardType: TextInputType.number,
                validator: Validator.phoneNumberValidator,
                onSaved: (value) {
                  phone = value;
                },
              ),
              const SizedBox(height: 15),
              RaisedButton(
                onPressed: _validateInput,
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: Platform.isIOS ? 30 : 1),
              if (Platform.isIOS && false)
                BorderButton(
                  'Đăng ký sau',
                  onPressed: () {
                    AccountController.instance.loginLater();
                    Navigator.pushReplacementNamed(context, '/home');
                    Provider.of<NavigationProvider>(context, listen: false)
                        .index = PageName.home.index;
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
        showLoading(context, message: 'Kiểm tra số điện thoại...');
        final AppResponse response =
            await AccountRepository.instance.checkPhoneNumber(phone);
        hideLoading(context);
        if (response.status) {
          if (response.data) {
            AccountRegisterState.instance.isRegister = false;
            await Navigator.pushNamed(context, '/login-password',
                arguments: phone);
          } else {
            await AppPopup.showCustomDialog(context, content: [
              AvatarGlow(
                endRadius: 50,
                duration: const Duration(milliseconds: 1000),
                glowColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.warning,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Số điện thoại ',
                        style: Theme.of(context).textTheme.body1),
                    TextSpan(
                        text: phone,
                        style: Theme.of(context).textTheme.body2.merge(
                            TextStyle(decoration: TextDecoration.underline))),
                    TextSpan(
                        text: ' chưa được đăng ký. Bạn có muốn đăng ký?',
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              CenterButtonPopup(
                normal: ButtonData('Quay lại'),
                highlight: ButtonData('Đăng ký', onPressed: onSentOTP),
              )
            ]);
          }
        } else {
          AppSnackBar.showFlushbar(context,
              response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
        }
      } catch (e) {
        debugPrint(e);
        AppSnackBar.showFlushbar(
            context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    }
  }

  Future onSentOTP() async {
    try {
      AccountRegisterState.instance.phone = phone;
      AccountRegisterState.instance.isRegister = true;
      if (AccountRegisterState.instance.checkTimeOTP() == false) {
        await Navigator.pushNamed(context, '/register_input_otp');
        return;
      }

      showLoading(context, message: 'Gửi OTP...');
      final AppResponse response = await AccountRepository.instance
          .registerStep2RequestOTP(
              phone, AccountRegisterState.instance.randomNewOtp());
      hideLoading(context);
      if (response.status) {
        AccountRegisterState.instance.timeOTP = DateTime.now();
        await Navigator.pushNamed(context, '/register_input_otp');
      } else {
        AppSnackBar.showFlushbar(context,
            response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    } catch (e) {
      debugPrint(e);
      AppSnackBar.showFlushbar(context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
    }
  }
}
