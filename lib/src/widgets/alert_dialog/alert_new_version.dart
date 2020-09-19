import 'package:ann_shop_flutter/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ping9/ping9.dart';
import 'package:url_launcher/url_launcher.dart';


class AlertNewVersion extends ANNAlertDialog {

  AlertNewVersion() {
    title = 'Cập nhật mới';
    message = 'Ứng dụng đã có phiên bản mới.\nVui lòng cập nhật!';
    btnLabel = 'Cập nhật ngay';
    btnLabelCancel = 'Bỏ qua';
  }

  @override
  void onPressedAccept(BuildContext context) async {
    final urlStore = Core.urlStore;

    if (await canLaunch(urlStore)) {
      await launch(urlStore);

      super.onPressedAccept(context);
    } else {
      throw 'Could not launch $urlStore';
    }
  }
}
