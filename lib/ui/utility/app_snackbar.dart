import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class AppSnackBar {
  static const _duration = Duration(seconds: 2, microseconds: 0);

  static Widget showFlushbar(BuildContext context, String message,
      {Duration duration = _duration}) {
    return Flushbar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: _duration,
      animationDuration: Duration(milliseconds: 500),
    )..show(context);
  }

  // k_added_to_list
  static Widget showHighlightTopMessage(BuildContext context, String message) {
    return Flushbar(
      margin: const EdgeInsets.only(top: 55),
      padding: const EdgeInsets.all(0),
      forwardAnimationCurve: Curves.easeOutQuart,
      animationDuration: const Duration(milliseconds: 500),
      messageText: Container(
        decoration: BoxDecoration(
            color: AppStyles.orange,
            border:
                Border(bottom: BorderSide(color: Colors.white, width: 1.5))),
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        alignment: AlignmentDirectional.center,
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.transparent,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 1, microseconds: 500),
    )..show(context);
  }

  static Widget showFlushbarWithButton(
    BuildContext context,
    String message,
    String button, {
    Duration duration = _duration,
    VoidCallback onPressed,
  }) {
    return Flushbar(
      messageText: Row(
        children: [
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            child: Text(
              button,
              style: TextStyle(color: AppStyles.orange),
            ),
            onPressed: onPressed,
          )
        ],
      ),
      duration: _duration,
      animationDuration: Duration(milliseconds: 500),
    )..show(context);
  }

  static Widget askLogin(BuildContext context,
      {String message = K.needLoginToContinue}) {
    return AppSnackBar.showFlushbarWithButton(context, message, "Đăng nhập",
        onPressed: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, "user/login");
    });
  }
}
