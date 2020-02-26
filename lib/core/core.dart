import 'dart:io';

import 'package:ann_shop_flutter/ui/dialog/alert_dialog_new_version.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

final double defaultPadding = 15;
const int itemPerPage = 20;

class Core {
  static final Core _instance = Core._internal();
  static const annLogoWithLink =
      'https://ann.com.vn/wp-content/uploads/ANN-logo-4.png';
  static const annLogoOrange = 'https://ann.com.vn/logo/ann-logo-2-400x150.png';
  static const annLogoWhite = 'https://ann.com.vn/logo/ann-logo-400x150.png';
  static const domain = 'http://xuongann.com/';
  static const dynamicLinkStore = 'https://app.ann.com.vn/download';

  factory Core() => _instance;

  Core._internal();

  static Core get instance => _instance;

  static String get urlStore {
    if (Platform.isIOS) {
      return 'itms-apps://itunes.apple.com/app/1493113793';
    } else {
      return 'https://play.google.com/store/apps/details?id=com.ann.app';
    }
  }

  static get urlStoreReview {
    if (Platform.isIOS) {
      return "itms-apps://itunes.apple.com/app/id1493113793?action=write-review";
    } else {
      return 'https://play.google.com/store/apps/details?id=com.ann.app';
    }
  }

  Future<void> versionCheck(BuildContext context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      if (newVersion > currentVersion) {
        AlertDialogNewVersion.instance.show(context);
      }
    } catch (e) {}
  }
}

checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return (connectivityResult != ConnectivityResult.none);
}
