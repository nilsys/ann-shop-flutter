import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ping9/ping9.dart';

import 'package:ann_shop_flutter/provider/utility/cover_repository.dart';
import 'package:flutter/material.dart';

class CoverProvider extends ChangeNotifier {
  ApiResponse<List<Cover>> coversHome;
  ApiResponse<List<Cover>> postsHome;
  ApiResponse<List<Cover>> notificationHome;
  ApiResponse<List<Cover>> headerProduct;
  ApiResponse<List<Cover>> footerProduct = ApiResponse();

  CoverProvider() {
    coversHome = ApiResponse();
    postsHome = ApiResponse();
    notificationHome = ApiResponse();
    headerProduct = ApiResponse();
    footerProduct = ApiResponse();

    loadCoverHome();
    loadNotificationHome();
    loadPostHome();
  }

  checkLoadCoverHomePage() {
    if (coversHome.isError) {
      loadCoverHome();
    }
    if (postsHome.isError) {
      loadPostHome();
    }
    if (notificationHome.isError) {
      loadNotificationHome();
    }
  }

  refreshCoverProductPage(String slug) {
    loadHeaderProduct(slug);
    loadFooterProduct(slug);
  }

  loadCoverHome() async {
    try {
      coversHome.loading = 'try load';
      notifyListeners();
      List<Cover> data =
          await CoverRepository.instance.loadCover('banners?page=home');
      if (data != null) {
        coversHome.completed = data;
      } else {
        data = await CoverRepository.instance.loadCoverHomeOffline();
        coversHome.completed = data;
      }
    } catch (e) {
      print(e);
      coversHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadNotificationHome() async {
    try {
      notificationHome.loading = 'try load';
      notifyListeners();
      List<Cover> data =
          await CoverRepository.instance.loadCover('home/notifications');
      if (data != null) {
        notificationHome.completed = data;
      } else {
        notificationHome.completed = [];
      }
    } catch (e) {
      print(e);
      notificationHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadPostHome() async {
    try {
      postsHome.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance.loadCover('home/posts');
      if (data != null) {
        postsHome.completed = data;
      } else {
        postsHome.completed = [];
      }
    } catch (e) {
      print(e);
      postsHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadHeaderProduct(String slug) async {
    try {
      headerProduct.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance
          .loadCover('banners?page=product&position=header&slug=$slug');
      if (data != null) {
        headerProduct.completed = data;
      } else {
        headerProduct.completed = [];
      }
    } catch (e) {
      print(e);
      headerProduct.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadFooterProduct(String slug) async {
    try {
      footerProduct.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance
          .loadCover('banners?page=product&position=footer&slug=$slug');
      if (data != null) {
        footerProduct.completed = data;
      } else {
        footerProduct.completed = [];
      }
    } catch (e) {
      print(e);
      footerProduct.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }
}
