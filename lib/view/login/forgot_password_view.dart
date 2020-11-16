import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/src/widgets/alert_dialog/alert_forgot_password.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/account/account_register_state.dart';
import 'package:ann_shop_flutter/provider/utility/account_repository.dart';
import 'package:ann_shop_flutter/provider/utility/app_response.dart';


import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:ping9/ping9.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView(this.phone);

  final phone;

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  //region Parameters
  final _formKey = GlobalKey<FormState>();
  final _formatDatePicker = 'd  M  yyyy';

  String birthDay;
  TextEditingController _controllerBirthDate;
  String password;

  bool _autoValidate = false;
  //endregion

  @override
  void initState() {
    super.initState();
    _controllerBirthDate = TextEditingController(text: Utility.fixFormatDate(''));
  }

  @override
  void dispose() {
    super.dispose();
  }

  //region Private
  //region Date Time Picker
  void _updateDate(DateTime dateTime) {
    if (dateTime != null) {
      setState(() {
        birthDay = DateFormat('yyyy-MM-dd').format(dateTime);
        _controllerBirthDate.text = Utility.fixFormatDate(birthDay);
      });
    }
  }

  _showDateTimePicker() {
    DateTime now = DateTime.now();
    DateTime temp = new DateTime(now.year - 25, 1, 1);
    if (isNullOrEmpty(birthDay) == false) {
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
        _updateDate(null);
      },
      onChange: (dateTime, List<int> index) {
        _updateDate(dateTime);
      },
      onConfirm: (dateTime, List<int> index) {
        _updateDate(dateTime);
        this._validateInput();
      },
    );
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _onForgotPassword();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _onForgotPassword() async {
    try {
      showLoading(context);
      AppResponse response = await AccountRepository.instance
          .forgotPasswordByBirthDay(widget.phone, birthDay);
      hideLoading(context);

      if (response.status) {
        /// go to update password
        AccountRegisterState.instance.otp = response.data;
        AccountRegisterState.instance.phone = widget.phone;
        Navigator.pushNamedAndRemoveUntil(context, 'user/register/password',
            ModalRoute.withName('user/login'));
      } else {
        AppSnackBar.showFlushbar(context, 'Ngày sinh không đúng.');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Ngày sinh không đúng.');
    }
  }
  //endregion

  //region Forgot Birthday
  void _onForgotBirthDay(BuildContext context) async {
    var phoneSupport = '0913268406';

    AppResponse response = await AccountRepository.instance
      .getPhoneSupportForgotPassword(widget.phone);

    if (response.status)
      phoneSupport = response.data;

    AlertForgotPassword(phoneSupport).show(context);
  }
  //endregion
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: DismissKeyBoard(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView(
              children: [
                SizedBox(height: 50),
                TextFormField(
                  style: TextStyle(fontWeight: FontWeight.w600),
                  initialValue: widget.phone,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone),
                  ),
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: isNullOrEmpty(password)
                      ? _showDateTimePicker
                      : null,
                  child: IgnorePointer(
                    child: TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w600),
                      controller: _controllerBirthDate,
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        helperText: ' ',
                        hintText: 'Chọn ngày sinh',
                      ),
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Chưa chọn ngày sinh';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                RaisedButton(
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _validateInput,
                ),
                SizedBox(height: 15),
                RaisedButton(
                  color: Colors.white,
                  child: Text('Quên ngày sinh'),
                  onPressed: () => _onForgotBirthDay(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
