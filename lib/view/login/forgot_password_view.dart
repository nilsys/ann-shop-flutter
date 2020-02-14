import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/button/text_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _controllerBirthDate;

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

    step = 0;
    _controllerBirthDate =
        TextEditingController(text: Utility.fixFormatDate(''));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;
  String phone;
  String password;
  String birthDay;

  int step;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Số di động',
          style: Theme.of(context).textTheme.body2,
        ),
      )
    ];
    if (step == 0) {
      children.addAll([
        TextFormField(
          maxLength: 10,
          readOnly: Utility.isNullOrEmpty(password) == false,
          decoration: InputDecoration(
            hintText: 'Nhập số điện thoại',
          ),
          keyboardType: TextInputType.number,
          validator: Validator.phoneNumberValidator,
          onSaved: (String value) {
            phone = value;
          },
        ),
        SizedBox(
          height: 20,
        )
      ]);
    } else {
      children.addAll([
        Container(
          child: Text(
            phone,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ]);
    }
    if (step == 1) {
      children.addAll([
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Ngày sinh',
            style: Theme.of(context).textTheme.body2,
          ),
        ),
        InkWell(
          onTap: Utility.isNullOrEmpty(password) ? _showDateTimePicker : null,
          child: IgnorePointer(
            child: TextFormField(
              controller: _controllerBirthDate,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Chọn ngày sinh',
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (Utility.isNullOrEmpty(value)) {
                  return 'Chưa chọn ngày sinh';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ]);
    }

    if (step == 0) {
      children.addAll([
        RaisedButton(
          child: Text(
            'Tiếp tục',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _validateInput,
        ),
        SizedBox(height: 5),
      ]);
    } else {
      if (Utility.isNullOrEmpty(password)) {
        children.addAll([
          RaisedButton(
            child: Text('Xác nhận', style: TextStyle(color: Colors.white),),
            onPressed: _validateInput,
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: TextButton(
              'Quên ngày sinh',
              onPressed: () {
                AccountRegisterState.instance.reset(false, phone: phone);
                Navigator.popAndPushNamed(context, '/register_input_phone');
              },
            ),
          )
        ]);
      } else {
        children.addAll([
          Container(
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Mật khẩu mới của bạn là:\n',
                    style: Theme.of(context).textTheme.body1),
                TextSpan(
                    text: password, style: Theme.of(context).textTheme.title),
              ]),
            ),
          ),
          SizedBox(height: 30),
          RaisedButton(
           child: Text( 'Đăng nhập ngay', style: TextStyle(color: Colors.white),),
            onPressed: _onSubmit,
          ),
        ]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
        leading: IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              if (step > 0 && Utility.isNullOrEmpty(password) == false) {
                setState(() {
                  step--;
                });
              } else {
                Navigator.pop(context);
              }
            }),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: ListView(
            controller: _scrollController,
            children: children,
          ),
        ),
      ),
    );
  }

  final _formatDatePicker = 'd  M  yyyy';

  _showDateTimePicker() {
    DateTime temp = DateTime.now();
    if (Utility.isNullOrEmpty(birthDay) == false) {
      temp = DateTime.parse(birthDay);
    }
    DateTime maxDay = new DateTime.utc(DateTime.now().year - 1, 12, 31);

    DatePicker.showDatePicker(
      context,
      initialDateTime: temp,
      dateFormat: _formatDatePicker,
      maxDateTime: maxDay,
      pickerMode: DateTimePickerMode.date,
      onCancel: () {
        updateDate(null);
      },
      onChange: (dateTime, List<int> index) {
        updateDate(dateTime);
      },
      onConfirm: (dateTime, List<int> index) {
        updateDate(dateTime);
      },
    );
  }

  void updateDate(DateTime dateTime) {
    if (dateTime != null) {
      setState(() {
        birthDay = DateFormat('yyyy-MM-dd').format(dateTime);
        _controllerBirthDate.text = Utility.fixFormatDate(birthDay);
      });
    }
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (step == 0) {
        _onCheckPhoneNumber();
      } else {
        _onForgotPassword();
      }
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
        showLoading(context);
        AppResponse response =
            await AccountRepository.instance.checkPhoneNumber(phone);
        hideLoading(context);
        if (response.status) {
          if (response.data) {
            setState(() {
              step++;
            });
          } else {
            AppSnackBar.showFlushbar(
                context, 'Số điện thoại này chưa được đăng ký.');
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

  Future _onForgotPassword() async {
    try {
      showLoading(context);
      AppResponse response = await AccountRepository.instance
          .forgotPasswordByBirthDay(phone, birthDay);
      hideLoading(context);
      if (response.status) {
        setState(() {
          password = response.data.toString();
        });
      } else {
        AppSnackBar.showFlushbar(context, 'Ngày sinh không đúng.');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Ngày sinh không đúng.');
    }
  }

  Future _onSubmit() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context);
        AppResponse response =
            await AccountRepository.instance.login(phone, password);
        hideLoading(context);
        if (response.status) {
          AccountController.instance.finishLogin(response.data);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
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
