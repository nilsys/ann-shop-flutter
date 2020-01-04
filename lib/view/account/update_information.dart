import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/button/text_button.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class UpdateInformation extends StatefulWidget {
  @override
  _UpdateInformationState createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  Account account;

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
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Lưu',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _validateInput,
          ),
        ],
      ),
      body: Container(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                child: Text(
                  'Thông tin cá nhân',
                  style: Theme.of(context).textTheme.title,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
              Container(
                height: 1,
                color: AppStyles.dividerColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: account.fullName,
                      decoration: InputDecoration(
                        hintText: 'Họ và tên',
                        contentPadding: EdgeInsets.all(contentPadding),
                        border: UnderlineInputBorder(),
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
                    TextFormField(
                      readOnly: true,
                      initialValue: account.phone,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(contentPadding),
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        account.phone = value;
                      },
                    ),
                    TextFormField(
                      initialValue: account.address,
                      decoration: InputDecoration(
                        hintText: 'Địa chỉ',
                        contentPadding: EdgeInsets.all(contentPadding),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (Utility.isNullOrEmpty(value)) {
                          return 'Chưa nhập địa chỉ';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        account.address = value;
                      },
                    ),
                    TextFormField(
                      initialValue: account.city,
                      expands: false,
                      decoration: InputDecoration(
                        hintText: 'Thành phố',
                        contentPadding: EdgeInsets.all(contentPadding),
                        border: UnderlineInputBorder(),
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
                    Container(
                      padding: EdgeInsets.fromLTRB(contentPadding,10,contentPadding,0),
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
                          padding: EdgeInsets.only(bottom: contentPadding + 10, left: contentPadding),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'Chưa chọn giới tín',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .merge(TextStyle(color: Colors.red)),
                            ),
                        )
                        : SizedBox(height: 10,)
                  ],
                ),
              ),
              Container(
                height: 10,
                color: AppStyles.dividerColor,
              ),
              Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: TextButton(
                  'Đổi mật khẩu.',
                  onPressed: () {
                    Navigator.pushNamed(context, '/change-password');
                  },
                ),
              )
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
        showLoading();
        AppResponse response =
            await AccountRepository.instance.updateInformation(account);
        hideLoading();
        if (response.status) {
          AccountController.instance.finishLogin(response.data);
          Navigator.pushReplacementNamed(context, '/home');
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

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }

  ProgressDialog _progressDialog;

  showLoading() {
    if (_progressDialog == null) {
      _progressDialog = ProgressDialog(context, message: 'Cập nhập...')..show();
    }
  }

  hideLoading() {
    if (_progressDialog != null) {
      _progressDialog.hide(contextHide: context);
      _progressDialog = null;
    }
  }
}
