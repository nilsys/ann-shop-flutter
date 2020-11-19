import 'package:flutter/cupertino.dart';
import 'package:ping9/ping9.dart';
import 'package:url_launcher/url_launcher.dart';


class AlertForgotPassword extends ANNAlertDialog {
  final String phone;

  AlertForgotPassword(this.phone) {
    title = 'Hổ trợ lấy mật khẩu';
    message = 'Vui lòng liên hệ Zalo: $phone,\n để có thể lấy lại mật khẩu.';
    btnLabel = 'Liên hệ Zalo';
    btnLabelCancel = 'Bỏ qua';
  }

  @override
  void onPressedAccept(BuildContext context) async {
    final zalo = 'http://zalo.me/$phone';

    if (await canLaunch(zalo)) {
      await launch(zalo);

      super.onPressedAccept(context);
    } else {
      throw 'Could not launch $zalo';
    }
  }
}
