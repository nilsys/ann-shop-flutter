import 'dart:convert';

import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/cover_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InAppProvider extends ChangeNotifier {
  InAppProvider() {
    inApp = ResponseProvider();
    loadCoverInApp();
    opens = [];
  }

  ResponseProvider<List<InApp>> inApp;

  loadCoverInApp() async {
    try {
      inApp.loading = 'try load';
      notifyListeners();
      List<InApp> data = await CoverRepository.instance.loadInAppNotification();
      if (data != null) {
        inApp.completed = data;
      } else {
        inApp.completed = [];
      }
    } catch (e) {
      log(e);
      inApp.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }

  List<int> opens;
  final _keyOpen = 'key_open_notificatio_in_app';
  loadOpen(){

  }
  saveOpen(){

  }
  bool checkOpen(int notificationID){
    return opens.contains(notificationID);
  }
  openNotification(int notificationID) {
    try {
      if (opens.contains(notificationID) == false) {
        opens.add(notificationID);
        notifyListeners();
      }
    } catch (e) {
      log(e);
    }
  }

  log(object) {
    print('inapp_provider: ' + object.toString());
  }
}
