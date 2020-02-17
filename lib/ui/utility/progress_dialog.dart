import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String _dialogMessage = "Loading...";

bool _isShowing = false;

ProgressDialog _progressDialog;

void showLoading(BuildContext context, {String message = 'Loading...'}) {
  _progressDialog ??= ProgressDialog(context, message: message)..show();
}

void hideLoading(BuildContext context) {
  if (_progressDialog != null) {
    _progressDialog.hide(contextHide: context);
    _progressDialog = null;
  }
}

void updateLoading(String message) {
  if (_progressDialog != null) {
    _progressDialog.update(message);
  }
}

class ProgressDialog {

  ProgressDialog(BuildContext buildContext, {String message = 'Loading...'}) {
    _dialogMessage = message;
    _buildContext = buildContext;
  }

  _MyDialog _dialog;

  BuildContext _buildContext, _context;

  void setMessage(String mess) {
    _dialogMessage = mess;
  }

  void update(String message) {
    _dialogMessage = message;
    _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void hide({BuildContext contextHide}) {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(contextHide ?? _context).pop();
    }
  }

  void show() {
    if (!_isShowing) {
      _dialog =  _MyDialog();
      _isShowing = true;
      showDialog<dynamic>(
        context: _buildContext,
        barrierDismissible: false,
        builder: (context) {
          _context = context;
          return Material(
              type: MaterialType.transparency, child: Center(child: _dialog));
        },
      );
    }
  }
}

// ignore: must_be_immutable
class _MyDialog extends StatefulWidget {
  final _dialog =  _MyDialogState();

  void update() {
    _dialog.changeState();
  }

  @override
  // ignore: must_be_immutable
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _MyDialogState extends State<_MyDialog> {
  void changeState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _isShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    final colorBG = Colors.black87;
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: colorBG,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Indicator(),
          ),

          /// Bottom
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            width: double.infinity,
            child: Text(
              _dialogMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
