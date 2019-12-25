import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/cover_repository.dart';
import 'package:flutter/material.dart';

class CoverProvider extends ChangeNotifier {
  CoverProvider() {
    coversHome = ResponseProvider();
    postsHome = ResponseProvider();
    notificationHome = ResponseProvider();
    loadCoverHome();
    loadNotificationHome();
    loadPostHome();
  }

  ResponseProvider<List<Cover>> coversHome;
  ResponseProvider<List<Cover>> postsHome;
  ResponseProvider<List<Cover>> notificationHome;

  loadCoverHome() async {
    try {
      coversHome.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance.loadCoverHome();
      if (data != null) {
        coversHome.completed = data;
      } else {
        data = await CoverRepository.instance.loadCoverHomeOffline();
        coversHome.completed = data;
      }
    } catch (e) {
      log(e);
      coversHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadNotificationHome() async {
    try {
      notificationHome.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance.loadHomeNotification();
      if (data != null) {
        notificationHome.completed = data;
      } else {
        notificationHome.completed = [];
      }
    } catch (e) {
      log(e);
      notificationHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  loadPostHome() async {
    try {
      postsHome.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance.loadHomePost();
      if (data != null) {
        postsHome.completed = data;
      } else {
        postsHome.completed = [];
      }
    } catch (e) {
      log(e);
      postsHome.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }


  log(object) {
    print('cover_provider: ' + object.toString());
  }
}
