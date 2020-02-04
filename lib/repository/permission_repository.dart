import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  static final PermissionRepository instance = PermissionRepository._internal();

  factory PermissionRepository() => instance;

  PermissionRepository._internal() {
    /// init
  }

  /// don't use for location
  Future<bool> checkAndRequestPermission(PermissionGroup name) async {
    PermissionStatus _permissionStatus =
        await PermissionHandler().checkPermissionStatus(name);
    print(name.toString() + ': ' + _permissionStatus.toString());
    if (_permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      if (_permissionStatus == PermissionStatus.unknown || _permissionStatus == PermissionStatus.denied) {
        final List<PermissionGroup> permissions = <PermissionGroup>[
          name
        ];
        Map<PermissionGroup, PermissionStatus> permissionRequestResult =
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
