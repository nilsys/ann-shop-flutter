import 'package:ann_shop_flutter/core/core.dart';

import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/provider/utility/account_repository.dart';
import 'package:ann_shop_flutter/provider/utility/app_response.dart';
import 'package:ping9/ping9.dart';

import 'package:ann_shop_flutter/ui/utility/ann-logo.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/bottom_bar_policy.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  AC _accountController;

  String phone;

  @override
  void initState() {
    super.initState();

    _accountController = AC.instance;

    if (_accountController.account != null &&
        !isEmpty(_accountController.account.phone)) {
      phone = _accountController.account.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Core.appFullName),
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
                    initialValue: phone,
                    autofocus: true,
                    maxLength: 10,
                    style: TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_iphone),
                      hintText: 'Nhập số điện thoại',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: Validator.phoneNumberValidator,
                    onSaved: (value) {
                      phone = value;
                    },
                    onFieldSubmitted: (String value) {
                      _validateInput();
                    }),
                const SizedBox(height: 15),
                RaisedButton(
                  onPressed: _validateInput,
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (AC.instance.requestLogin == false) ...[
                  const SizedBox(height: 15),
                  BorderButton(
                    onPressed: _skipLogin,
                    child: Text('Bỏ qua'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _skipLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.popUntil(context, ModalRoute.withName("home"));
    } else {
      Navigator.pushReplacementNamed(context, "home");
    }
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
        showLoading(context, message: 'Kiểm tra số điện thoại...');
        final AppResponse response =
            await AccountRepository.instance.checkPhoneNumber(phone);
        hideLoading(context);

        if (response.status) {
          if (response.data) {
            AccountRegisterState.instance.isRegister = false;
            await Navigator.pushNamed(context, 'user/login/password',
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
                        style: Theme.of(context).textTheme.bodyText2),
                    TextSpan(
                        text: phone,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(decoration: TextDecoration.underline))),
                    TextSpan(
                        text: ' chưa được đăng ký. Bạn có muốn đăng ký?',
                        style: Theme.of(context).textTheme.bodyText2),
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
        print(e);
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
        await Navigator.pushNamed(context, 'user/otp');
        return;
      }

      showLoading(context, message: 'Gửi OTP...');
      AccountRegisterState.instance.randomNewOtp();
      await Future.delayed(const Duration(milliseconds: 500));
      hideLoading(context);

      AccountRegisterState.instance.timeOTP = DateTime.now();
      await Navigator.pushNamed(context, 'user/otp');
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
    }
  }
}
