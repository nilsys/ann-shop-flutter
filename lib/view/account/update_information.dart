import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/ui/button/primary_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/view/account/choose_city_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class UpdateInformation extends StatefulWidget {
  @override
  _UpdateInformationState createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  Account account;
  TextEditingController _controllerBirthDate;
  TextEditingController _controllerCity;
  final hintStyle = (TextStyle(fontStyle: FontStyle.italic));

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
    account = new Account.fromJson(AccountController.instance.account.toJson());
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thông tin tài khoản'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              SizedBox(height: 20),
              _buildTitle('Họ và tên'),
              TextFormField(
                initialValue: account.fullName,
                decoration: InputDecoration(
                  hintText: 'Nhập họ và tên',
                  hintStyle: hintStyle,
                  contentPadding: EdgeInsets.all(contentPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1, style: BorderStyle.solid),
                  ),
                ),
                validator: (value) {
                  if (Utility.isNullOrEmpty(value)) {
                    return 'Chưa nhập họ và tên';
                  }
                  return null;
                },
                onSaved: (String value) {
                  account.fullName = value;
                },
              ),
              _buildTitle('Số điện thoại'),
              TextFormField(
                readOnly: true,
                initialValue: account.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(contentPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1, style: BorderStyle.solid),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (String value) {
                  account.phone = value;
                },
              ),
              _buildTitle('Ngày sinh'),
              InkWell(
                onTap: _showDateTimePicker,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _controllerBirthDate,
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: 'Chọn ngày sinh',
                        hintStyle: hintStyle,
                        contentPadding: EdgeInsets.all(contentPadding),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 1,
                              style: BorderStyle.solid),
                        )),
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
              _buildTitle('Địa chỉ'),
              TextFormField(
                initialValue: account.address,
                decoration: InputDecoration(
                  hintText: 'Chọn địa chỉ',
                  hintStyle: hintStyle,
                  contentPadding: EdgeInsets.all(contentPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1, style: BorderStyle.solid),
                  ),
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (String value) {
                  account.address = value;
                },
              ),
              _buildTitle('Thành phố'),
              InkWell(
                onTap: _showCityPicker,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _controllerCity,
                    readOnly: true,
                    expands: false,
                    decoration: InputDecoration(
                      hintText: 'Chọn thành phố',
                      hintStyle: hintStyle,
                      contentPadding: EdgeInsets.all(contentPadding),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                    validator: (value) {
                      if (Utility.isNullOrEmpty(value)) {
                        return 'Chưa nhập thành phố';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      account.city = value;
                    },
                  ),
                ),
              ),
              _buildTitle(
                'Giới tính',
                padding: EdgeInsets.only(top: 15),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: contentPadding),
                child: Row(
                  children: <Widget>[
                    Text('Nam'),
                    Checkbox(
                      value: account.gender == 'M',
                      onChanged: (bool value) {
                        setState(
                          () {
                            if (value == true) {
                              account.gender = 'M';
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text('Nữ'),
                    Checkbox(
                      value: account.gender == 'F',
                      onChanged: (bool value) {
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
              (_autoValidate && Utility.isNullOrEmpty(account.gender))
                  ? Container(
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
                    )
                  : SizedBox(
                      height: 10,
                    ),
              PrimaryButton(
                'Cập nhật',
                onPressed: _validateInput,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitle(title, {EdgeInsetsGeometry padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        title,
        style: Theme.of(context).textTheme.body2,
      ),
    );
  }

  final _formatDatePicker = 'd  M  yyyy';

  _showDateTimePicker() {
    DateTime temp = DateTime.now();
    if (Utility.isNullOrEmpty(account.birthDay) == false) {
      temp = DateTime.parse(account.birthDay);
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
        account.birthDay = DateFormat('yyyy-MM-dd').format(dateTime);
        _controllerBirthDate.text = Utility.fixFormatDate(account.birthDay);
      });
    }
  }

  _showCityPicker() {
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
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context, message: 'Cập nhật...');
        AppResponse response =
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
        print(e);
        AppSnackBar.showFlushbar(
            context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    }
  }
}
