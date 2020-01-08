import 'package:ann_shop_flutter/core/app_input_formatter.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/button/primary_button.dart';
import 'package:ann_shop_flutter/ui/button/text_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterInputOtpView extends StatefulWidget {
  @override
  _RegisterInputOtpViewState createState() => _RegisterInputOtpViewState();
}

class _RegisterInputOtpViewState extends State<RegisterInputOtpView> {
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

    registerStream();
  }

  Stream<int> stream;
  int countDown;
  TextEditingController controllerOTP = TextEditingController();

  registerStream() {
    countDown = 60 - AccountRegisterState.instance.getDifferenceOTP();
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
    return 60 - second;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    print(AccountRegisterState.instance.otp);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập OTP'),
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
              Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Vui lòng nhập OTP đã được gửi đến số điện thoại của Quý khách',
                  style: Theme.of(context).textTheme.body2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: countDown <= 0
                    ? TextButton(
                        'Gửi lại OTP',
                        onPressed: () {
                          _onResentOTP();
                        },
                      )
                    : Text(
                        'OTP (00:$countDown)',
                        style: Theme.of(context).textTheme.body2,
                      ),
              ),
              TextFormField(
                controller: controllerOTP,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 15,
                    fontSize: 25,
                    color: Colors.black87),
                textAlign: TextAlign.center,
                showCursor: false,
                decoration: InputDecoration(
                  hintText: '______',
                  contentPadding: EdgeInsets.all(12),
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
              PrimaryButton(
                'Xác nhận',
                onPressed: checkLength6() ? _validateInput : null,
              ),
            ],
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
          Navigator.pushNamedAndRemoveUntil(context, '/register_input_password',
              ModalRoute.withName('/login'));
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
      try {
        showLoading(context);
        AppResponse response = await AccountRepository.instance
            .registerStep2RequestOTP(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.otp);
        hideLoading(context);
        if (response.status) {
          AccountRegisterState.instance.timeOTP = DateTime.now();
          registerStream();
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
