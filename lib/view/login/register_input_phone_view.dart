import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/button/primary_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterInputPhoneView extends StatefulWidget {
  @override
  _RegisterInputPhoneViewState createState() => _RegisterInputPhoneViewState();
}

class _RegisterInputPhoneViewState extends State<RegisterInputPhoneView> {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập số điện thoai'),
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
                initialValue: AccountRegisterState.instance.phone,
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
                  AccountRegisterState.instance.phone = value;
                },
              ),
              SizedBox(height: 30),
              PrimaryButton(
                'Gửi OTP',
                onPressed: _validateInput,
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
      _onCheckPhoneNumber();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _onCheckPhoneNumber() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context, message: 'Gửi OTP...');
        AppResponse response = await AccountRepository.instance
            .checkPhoneNumber(AccountRegisterState.instance.phone);
        hideLoading(context);
        if (response.status) {
          if (response.data != AccountRegisterState.instance.isRegister) {
            _onSubmit();
            return;
          } else {
            AppSnackBar.showFlushbar(
                context, AccountRegisterState.instance.isRegister?'Số điện thoại này đã được đăng ký.':'Số điện thoại này chưa được đăng ký.');
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

  Future _onSubmit() async {
    try {
      if (AccountRegisterState.instance.checkTimeOTP() == false) {
        hideLoading(context);
        Navigator.pushNamed(context, '/register_input_otp');
      } else {
        AppResponse response = await AccountRepository.instance
            .registerStep2RequestOTP(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.otp);
        if (response.status) {
          AccountRegisterState.instance.timeOTP = DateTime.now();
          Navigator.pushNamed(context, '/register_input_otp');
        } else {
          AppSnackBar.showFlushbar(context,
              response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
        }
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
    }
  }
}
