import 'dart:io';

import 'package:ann_shop_flutter/src/controllers/ann_controller.dart';
import 'package:ann_shop_flutter/src/widgets/alert_dialog/alert_ask_permission.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends ANNController {
  static final _instance = PermissionController._internal();

  static PermissionController get instance => _instance;

  // endregion

  PermissionController._internal();

  factory PermissionController() => instance;

  Future<bool> checkAndRequestPermission(
      BuildContext context, Permission name) async {
    var status = await name.status;

    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.undetermined) {
      final result = await name.request();

      if (result == PermissionStatus.granted)
        return true;
      else
        return false;
    } else if (status == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showAlertDialog(context, name);

        return false;
      } else {
        final result = await name.request();

        if (result == PermissionStatus.granted)
          return true;
        else
          return false;
      }
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showAlertDialog(context, name);

      return false;
    } else {
      return false;
    }
  }

  void _showAlertDialog(BuildContext context, Permission permission) {
    AlertAskPermission()
      ..setMessage(permission)
      ..show(context);
  }
}
