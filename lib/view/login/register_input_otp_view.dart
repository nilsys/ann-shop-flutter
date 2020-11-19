import 'package:ann_shop_flutter/core/app_input_formatter.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/provider/utility/account_repository.dart';
import 'package:ann_shop_flutter/provider/utility/app_response.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:ping9/ping9.dart';
import 'package:ping9/ping9.dart' as Ping9;

import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterInputOtpView extends StatefulWidget {
  @override
  _RegisterInputOtpViewState createState() => _RegisterInputOtpViewState();
}

class _RegisterInputOtpViewState extends State<RegisterInputOtpView> {
  final _timeout = 10;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    registerStream();
  }

  Stream<int> stream;
  int countDown;
  TextEditingController controllerOTP = TextEditingController();

  registerStream() {
    countDown = _timeout - AccountRegisterState.instance.getDifferenceOTP();
    stream = Stream<int>.periodic(Duration(seconds: 1), transform);
    stream = stream.takeWhile((value) {
      return countDown > 0;
    });
    listenStream();
  }

  listenStream() async {
    await for (int i in stream) {
      setState(() {
        countDown = i;
      });
    }
  }

  int transform(int value) {
    int second = AccountRegisterState.instance.getDifferenceOTP();
    return _timeout - second;
  }

  @override
  void dispose() {
    stream.takeWhile((value) {
      return true;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập mã OTP'),
      ),
      body: DismissKeyBoard(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  'Vui lòng nhập mã OTP đã gửi đến số điện thoại ',
                              style: Theme.of(context).textTheme.bodyText2),
                          TextSpan(
                              text: AccountRegisterState.instance.phone,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(TextStyle(
                                      decoration: TextDecoration.underline))),
                          TextSpan(
                              text: '  của quý khách',
                              style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  child: countDown <= 0
                      ? Ping9.TextButton(
                          'Gửi lại mã OTP',
                          onPressed: () {
                            _onResentOTP();
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Gửi lại mã OTP (00:$countDown)',
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                ),
                TextFormField(
                  controller: controllerOTP,
                  autofocus: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 15,
                      fontSize: 25,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                  showCursor: false,
                  onFieldSubmitted: (String value) {
                    this._validateInput();
                  },
                  decoration: InputDecoration(
                    hintText: '______',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .merge(TextStyle(color: Colors.red)),
                  ),
                  inputFormatters: [OTPInputFormatter()],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value != AccountRegisterState.instance.otp) {
                      return 'OTP không trùng khớp';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(height: 30),
                RaisedButton(
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: checkLength6() ? _validateInput : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkLength6() {
    String text = controllerOTP.text.replaceAll('_', '');
    return text.length == 6;
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        countDown = 0;
      });
      _onValidateOTP();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _onValidateOTP() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context, message: 'Xác nhận OTP...');
        AppResponse response = await AccountRepository.instance
            .registerStep3ValidateOTP(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.otp);
        hideLoading(context);

        if (response.status) {
          Navigator.pushNamedAndRemoveUntil(context, 'user/register/password',
              ModalRoute.withName('user/login'));
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

  Future _onResentOTP() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
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
                  text: 'Xác nhận số điện thoại ',
                  style: Theme.of(context).textTheme.bodyText2),
              TextSpan(
                  text: AccountRegisterState.instance.phone,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(decoration: TextDecoration.underline))),
              TextSpan(
                  text: ' là chính xác?',
                  style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        CenterButtonPopup(
          normal: ButtonData('Quay lại', onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'user/login', (route) => false);
          }),
          highlight: ButtonData('Xác nhận', onPressed: _onValidateOTP),
        )
      ]);
    }
  }
}
