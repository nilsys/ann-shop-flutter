import 'package:ping9/ping9.dart';

import 'ac.dart';

extension ACRestrict on AC {

  bool get canViewProduct {
    if (isLogin || noLoginConfig.maxViewProduct < 0) {
      return true;
    }
    if (noLoginInfo.viewProduct < noLoginConfig.maxViewProduct) {
      noLoginInfo.viewProduct++;
      printTrack("noLoginInfo.viewProduct: ${noLoginInfo.viewProduct}");
      saveRestrict();
      return true;
    }
    return false;
  }

  bool get canSearchProduct {
    if (isLogin || noLoginConfig.maxSearchProduct < 0) {
      return true;
    }
    if (noLoginInfo.searchProduct < noLoginConfig.maxSearchProduct) {
      noLoginInfo.searchProduct++;
      printTrack("noLoginInfo.searchProduct: ${noLoginInfo.searchProduct}");
      saveRestrict();
      return true;
    }
    return false;
  }

  bool get canViewBlog {
    if (isLogin || noLoginConfig.maxViewBloc < 0) {
      return true;
    }
    if (noLoginInfo.viewBloc < noLoginConfig.maxViewBloc) {
      noLoginInfo.viewBloc++;
      printTrack("noLoginInfo.viewBloc: ${noLoginInfo.viewBloc}");
      saveRestrict();
      return true;
    }
    return false;
  }

  bool get requestLogin => isLogin || noLoginConfig.requestLogin;

  bool get showPrice => isLogin || noLoginConfig.showPrice;

  bool get showNotification => isLogin || noLoginConfig.showNotification;

  bool get showAccount => isLogin || noLoginConfig.showAccount;

  bool get showScan => isLogin || noLoginConfig.showScan;

  bool get showFavorite => isLogin || noLoginConfig.showFavorite;

  bool get canPostProduct => isLogin || noLoginConfig.canPostProduct;

  bool get canCopyProduct => isLogin || noLoginConfig.canCopyProduct;

  bool get canLikeProduct => isLogin || noLoginConfig.canLikeProduct;

  bool get canDownloadProduct => isLogin || noLoginConfig.canDownloadProduct;

  bool get canPostBloc => isLogin || noLoginConfig.canPostBloc;

  bool get canCopyBloc => isLogin || noLoginConfig.canCopyBloc;
}
