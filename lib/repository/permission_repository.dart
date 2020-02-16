import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future showPopupOpenSetting(BuildContext context,
      {String message =
          'Cần quyền truy cập Hình Ảnh của bạn để sử dụng tín năng này. Bạn có muốn mở thiết lập cài đặt?'}) async {
    await AppPopup.showCustomDialog(
      context,
      content: [
        AvatarGlow(
          endRadius: 50,
          duration: const Duration(milliseconds: 1000),
          glowColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.settings,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.body2,
          textAlign: TextAlign.center,
        ),
        CenterButtonPopup(
            normal: ButtonData(
              'Không',
            ),
            highlight: ButtonData(
              'Mở cài đặt',
              onPressed: () {
                PermissionHandler().openAppSettings();
              },
            ))
      ],
    );
  }
}
