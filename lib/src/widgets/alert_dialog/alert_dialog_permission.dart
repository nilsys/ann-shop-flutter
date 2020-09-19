import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping9/ping9.dart';
import 'package:quiver/strings.dart';

class AlertDialogPermission extends ANNAlertDialog {
  // region Singleton Pattern
  static final _instance = AlertDialogPermission._internal();

  // endregion

  // region Getter
  static AlertDialogPermission get instance => _instance;

  // endregion

  AlertDialogPermission._internal() {
    title = 'Cấp quyền cho ${Core.appName}';
    message = 'Vui lòng cấp quyền để sử dụng tín năng này.';
    btnLabel = 'Mở cài đặt';
    btnLabelCancel = 'Bỏ qua';
  }

  factory AlertDialogPermission() => _instance;

  @override
  void onPressedAccept(BuildContext context) {
    openAppSettings();

    super.onPressedAccept(context);
  }

  void setMessage(Permission permission) {
    var strPermission = '';

    if (permission == Permission.notification)
      strPermission = 'Thông báo';
    else if (permission == Permission.camera)
      strPermission = Platform.isIOS ? 'Camera' : 'Máy ảnh';
    else if (permission == Permission.photos ||
        permission == Permission.storage)
      strPermission = Platform.isIOS ? 'Ảnh' : 'Bộ nhớ';
    else
      strPermission = permission.toString();

    if (isEmpty(strPermission))
      message = 'Vui lòng cấp quyền để sử dụng tín năng này.';
    else
      message =
          'Vui lòng cấp quyền sử dụng $strPermission để tín năng này hoạt động.';
    
    if (Platform.isIOS) {
      if (permission == Permission.camera) {
        message += '\n\nSau khi chọn [Mở cài đặt] -> Kích hoạt [Camera] -> Trở về ứng dụng ANN.';
      } else if (permission == Permission.photos) {
        message += '\n\nSau khi chọn [Mở cài đặt] -> Chọn [Ảnh] -> Chọn [Đọc và ghi] -> Trở về ứng dụng ANN.';
      }
    } else if (Platform.isAndroid) {
      message += '\n\nSau khi chọn [Mở cài đặt] bên dưới -> Chọn [Quyền] -> Kích hoạt [Bộ nhớ] và [Máy ảnh] -> Trở về ứng dụng ANN.';
    }
  }
}
