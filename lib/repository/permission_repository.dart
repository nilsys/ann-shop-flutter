import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  factory PermissionRepository() => instance;

  PermissionRepository._internal();

  static final PermissionRepository instance = PermissionRepository._internal();

  /// don't use for location
  Future<bool> checkAndRequestPermission(PermissionGroup name) async {
    PermissionStatus _permissionStatus =
        await PermissionHandler().checkPermissionStatus(name);
    debugPrint('$name : $_permissionStatus');
    if (_permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      if (_permissionStatus == PermissionStatus.unknown ||
          _permissionStatus == PermissionStatus.denied) {
        final List<PermissionGroup> permissions = <PermissionGroup>[name];
        final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
            await PermissionHandler().requestPermissions(permissions);
        _permissionStatus = permissionRequestResult[name];
      }

      if (_permissionStatus == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
