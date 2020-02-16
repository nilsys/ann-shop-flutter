import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:ann_shop_flutter/view/account/choose_city_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({this.isRegister = false});

  final bool isRegister;

  @override
  _UpdateInformationState createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  Account account;
  TextEditingController _controllerBirthDate;
  TextEditingController _controllerCity;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset < -50) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    account = Account.fromJson(AccountController.instance.account.toJson());
    _controllerBirthDate =
        TextEditingController(text: Utility.fixFormatDate(account.birthDay));
    _controllerCity = TextEditingController(text: account.city);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  final double contentPadding = 12;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isRegister) {
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Thông tin tài khoản'),
          leading: widget.isRegister
              ? Container()
              : IconButton(
                  icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                const SizedBox(height: 50),
                TextFormField(
                  initialValue: account.fullName,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.perm_identity),
                    hintText: 'Nhập họ và tên',
                  ),
                  validator: (value) {
                    if (Utility.isNullOrEmpty(value)) {
                      return 'Chưa nhập họ và tên';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    account.fullName = value;
                  },
                ),
                if (widget.isRegister == false) ...[
                  const SizedBox(height: 15),
                  TextFormField(
                      readOnly: true,
                      initialValue: account.phone,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_iphone),
                      )),
                ],
                const SizedBox(height: 15),
                InkWell(
                  onTap: _showDateTimePicker,
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _controllerBirthDate,
                      readOnly: true,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
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
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: account.address,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.map),
                    hintText: 'Nhập địa chỉ',
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    account.address = value;
                  },
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: _showCityPicker,
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _controllerCity,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        hintText: 'Chọn thành phố',
                      ),
                      validator: (value) {
                        if (Utility.isNullOrEmpty(value)) {
                          return 'Chưa nhập thành phố';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        account.city = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: contentPadding),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Nam',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      Checkbox(
                        value: account.gender == 'M',
                        onChanged: (value) {
                          setState(
                            () {
                              if (value == true) {
                                account.gender = 'M';
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text('Nữ', style: Theme.of(context).textTheme.display1),
                      Checkbox(
                        value: account.gender == 'F',
                        onChanged: (value) {
                          setState(
                            () {
                              if (value == true) {
                                account.gender = 'F';
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (_autoValidate && Utility.isNullOrEmpty(account.gender))
                  Container(
                    padding: EdgeInsets.only(
                        bottom: contentPadding + 10, left: contentPadding),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chưa chọn giới tín',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(color: Colors.red)),
                    ),
                  ),
                const SizedBox(height: 15),
                RaisedButton(
                  onPressed: _validateInput,
                  child: Text(
                    widget.isRegister ? 'Hoàn tất đăng ký' : 'Cập nhật',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _formatDatePicker = 'd  M  yyyy';

  void _showDateTimePicker() {
    var temp = DateTime.now();
    if (Utility.isNullOrEmpty(account.birthDay) == false) {
      temp = DateTime.parse(account.birthDay);
    }
    final maxDay = DateTime.utc(DateTime.now().year - 1, 12, 31);

    DatePicker.showDatePicker(
      context,
      initialDateTime: temp,
      dateFormat: _formatDatePicker,
      maxDateTime: maxDay,
      pickerMode: DateTimePickerMode.date,
      onCancel: () {
        updateDate(null);
      },
      onChange: (dateTime, index) {
        updateDate(dateTime);
      },
      onConfirm: (dateTime, index) {
        updateDate(dateTime);
      },
    );
  }

  void updateDate(DateTime dateTime) {
    if (dateTime != null) {
      setState(() {
        account.birthDay = DateFormat('yyyy-MM-dd').format(dateTime);
        _controllerBirthDate.text = Utility.fixFormatDate(account.birthDay);
      });
    }
  }

  void _showCityPicker() {
    ChooseCityBottomSheet.showBottomSheet(context, account.city, (value) {
      account.city = value;
      _controllerCity.text = account.city;
    });
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate() && Utility.isNullOrEmpty(account.gender) == false) {
      form.save();
      onFinish();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future onFinish() async {
    final _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context, message: 'Cập nhật...');
        final response =
            await AccountRepository.instance.updateInformation(account);
        hideLoading(context);
        if (response.status) {
          AccountController.instance.updateAccountInfo(account);
          Navigator.pop(context);
          AppSnackBar.showFlushbar(context, 'Cập nhật thành công');
        } else {
          AppSnackBar.showFlushbar(context,
              response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
        }
      } catch (e) {
        debugPrint('Update information: $e');
        AppSnackBar.showFlushbar(
            context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    }
  }
}
