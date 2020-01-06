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
import 'package:ann_shop_flutter/ui/button/primary_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
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
                readOnly: Utility.isNullOrEmpty(password) == false,
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
                  phone = value;
                },
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Ngày sinh',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              InkWell(
                onTap: _showDateTimePicker,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _controllerBirthDate,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Chọn ngày sinh',
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
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
              Utility.isNullOrEmpty(password)
                  ? SizedBox(
                      height: 5,
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 15),
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Mật khẩu mới của bạn là:\n',
                              style: Theme.of(context).textTheme.body1),
                          TextSpan(
                              text: password,
                              style: Theme.of(context).textTheme.button),
                        ]),
                      ),
                    ),
              SizedBox(height: 30),
              Utility.isNullOrEmpty(password)
                  ? PrimaryButton(
                      'Quên mật khẩu',
                      onPressed: _validateInput,
                    )
                  : PrimaryButton(
                      'Đăng nhập ngay',
                      onPressed: _onSubmit,
                    ),
              Utility.isNullOrEmpty(password)
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: TextButton(
                        'Quên ngày sinh',
                        onPressed: () {
                          AccountRegisterState.instance.reset(false);
                          Navigator.popAndPushNamed(context, '/register_input_phone');
                        },
                      ),
                    )
                  : Container()
            ],
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
        showLoading(context);
        AppResponse response =
            await AccountRepository.instance.checkPhoneNumber(phone);
        hideLoading(context);
        if (response.status) {
          if (response.data) {
            _onForgotPassword();
            return;
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
      hideLoading(context);
    }
  }

  Future _onForgotPassword() async {
    try {
      AppResponse response = await AccountRepository.instance
          .forgotPasswordByBirthDay(phone, birthDay);
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
