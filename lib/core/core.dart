import 'dart:io';

import 'package:connectivity/connectivity.dart';

final double defaultPadding = 15;
const int itemPerPage = 20;

class Core {
  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    /// init
  }

  static const annLogoWithLink = 'https://ann.com.vn/wp-content/uploads/ANN-logo-4.png';
  static const annLogoOrange = 'https://ann.com.vn/logo/ann-logo-2-400x150.png';
  static const annLogoWhite = 'https://ann.com.vn/logo/ann-logo-400x150.png';
  static const domain = 'http://xuongann.com/';

  static const dynamicLinkStore = 'https://app.ann.com.vn/download';

  static get urlStore {
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
}

checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return (connectivityResult != ConnectivityResult.none);
}
