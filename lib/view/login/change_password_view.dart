import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/validator.dart';
import 'package:ann_shop_flutter/repository/account_repository.dart';
import 'package:ann_shop_flutter/repository/app_response.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:flutter/material.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
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
    showPassword = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;
  String confirmPassword;
  String password;
  bool showPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
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
                  'Mật khẩu',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              Stack(children: [
                TextFormField(
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu',
                  ),
                  validator: Validator.passwordValidator,
                  onSaved: (String value) {
                    password = value;
                  },
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppStyles.dartIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                )
              ]),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Nhập lại mật khẩu',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              Stack(children: [
                TextFormField(
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: 'Nhập lại mật khẩu',
                  ),
                  validator: Validator.passwordValidator,
                  onSaved: (String value) {
                    confirmPassword = value;
                  },
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppStyles.dartIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                )
              ]),
              SizedBox(height: 30),
              RaisedButton(
                child: Text(
                  'Đổi mật khẩu',
                  style: TextStyle(color: Colors.white),
                ),
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
      if (password != confirmPassword) {
        AppSnackBar.showFlushbar(context, 'Nhập lại mật khẩu chưa đúng');
      } else {
        onSubmit();
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future onSubmit() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        showLoading(context);
        AppResponse response =
            await AccountRepository.instance.changePassword(password);
        hideLoading(context);
        if (response.status) {
          Navigator.pop(context);
          AppSnackBar.showFlushbar(context, 'Đổi mật khẩu thành công');
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
