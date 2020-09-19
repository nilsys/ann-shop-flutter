import 'dart:io';

class NoLoginInfo {
  int viewProduct;
  int searchProduct;
  int viewBloc;

  NoLoginInfo() {
    this.viewProduct = 0;
    this.searchProduct = 0;
    this.viewBloc = 0;
  }

  NoLoginInfo.fromJson(Map<String, dynamic> json) {
    viewProduct = json['view_product'] ?? 0;
    searchProduct = json['search_product'] ?? 0;
    viewBloc = json['view_bloc'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view_product'] = this.viewProduct;
    data['search_product'] = this.searchProduct;
    data['view_bloc'] = this.viewBloc;
    return data;
  }
}

class NoLoginConfig {
  bool requestLogin;
  bool showPrice;
  int maxSearchProduct;
  int maxViewBloc;
  int maxViewProduct;
  bool showNotification;
  bool showAccount;
  bool showScan;
  bool showFavorite;
  bool canPostProduct;
  bool canCopyProduct;
  bool canLikeProduct;
  bool canDownloadProduct;
  bool canPostBloc;
  bool canCopyBloc;

  NoLoginConfig() {
    if (Platform.isIOS) {
      requestLogin = false;
      showPrice = false;
      maxSearchProduct = -1;
      maxViewBloc = 5;
      maxViewProduct = 10;
      showNotification = false;
      showAccount = false;
      showScan = false;
      showFavorite = false;
      canPostProduct = false;
      canCopyBloc = false;
      canLikeProduct = false;
      canDownloadProduct = false;
      canPostBloc = false;
      canCopyBloc = false;
    } else {
      requestLogin = true;
    }
  }
}
