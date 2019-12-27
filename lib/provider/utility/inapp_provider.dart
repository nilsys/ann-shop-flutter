import 'dart:convert';

import 'package:ann_shop_flutter/core/storage_manager.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/cover_repository.dart';
import 'package:flutter/material.dart';

class InAppProvider extends ChangeNotifier {
  InAppProvider() {
    inApp = ResponseProvider();
    loadCoverInApp();
    opens = [];
  }

  ResponseProvider<List<InApp>> inApp;
  Map<String, List<InApp>> mapInApp;

  List<InApp> getByCategory(String name) {
    if (Utility.isNullOrEmpty(name) || name == 'all') {
      return inApp.data;
    } else {
      return mapInApp[name];
    }
  }

  loadCoverInApp() async {
    try {
      inApp.loading = 'try load';
      notifyListeners();
      List<InApp> data = await CoverRepository.instance.loadInAppNotification();
      if (data != null) {
        inApp.completed = data;
        mapInApp = new Map();
        for (int i = 0; i < data.length; i++) {
          if (mapInApp[data[i].category] == null) {
            mapInApp[data[i].category] = [data[i]];
          } else {
            mapInApp[data[i].category].add(data[i]);
          }
        }
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

  loadOpen() async {
    String response = await StorageManager.getObjectByKey(_keyOpen);
    if (Utility.isNullOrEmpty(response)) {
      opens = new List();
    } else {
      try {
        var message = json.decode(response);
        opens = message.cast<String>();
      } catch (e) {
        opens = new List();
      }
    }
  }

  saveOpen() {
    var myJsonString =
    json.encode(opens);
    StorageManager.setObject(_keyOpen, myJsonString);
  }

  bool checkOpen(int notificationID) {
    return opens.contains(notificationID) == false;
  }

  openNotification(int notificationID) {
    try {
      if (opens.contains(notificationID) == false) {
        opens.add(notificationID);
        saveOpen();
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
