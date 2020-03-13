import 'dart:io';

import 'package:ann_shop_flutter/src/widgets/alert_dialog/alert_dialog_permission.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ann_service.dart';

class PermissionService extends ANNService {
  // region Singleton Pattern
  static final _instance = PermissionService._internal();

  // endregion

  // region Parameters
  PermissionHandler _permission;

  // endregion

  // region Getter
  static PermissionService get instance => _instance;

  // endregion

  PermissionService._internal() {
    _permission = new PermissionHandler();
  }

  factory PermissionService() => instance;

  Future<bool> checkAndRequestPermission(
      BuildContext context, PermissionGroup name) async {
    var status = await _permission.checkPermissionStatus(name);

    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.unknown) {
      final result = await _permission.requestPermissions([name]);

      status = result[name];

      if (status == PermissionStatus.granted)
        return true;
      else
        return false;
    } else if (status == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showAlertDialog(context, name);

        return false;
      } else {
        final result = await _permission.requestPermissions([name]);

        status = result[name];

        if (status == PermissionStatus.granted)
          return true;
        else
          return false;
      }
    } else {
      return false;
    }
  }

  void _showAlertDialog(BuildContext context, PermissionGroup permission) {
    final alertDialog = AlertDialogPermission.instance;

    alertDialog.setMessage(permission);
    alertDialog.show(context);
  }
}
