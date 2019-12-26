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

  openNotification(int notificationID) {
    try {
      var item = inApp.data.firstWhere((item) => item.id == notificationID);
      if (item != null && item.status == 0) {
        var _body = {
          "inbox_id": notificationID.toString(),
        };
        final url = 'http://xuongann.com/api/flutter/inbox/update-status';
        http.post(url, body: jsonEncode(_body)).then((response) {
          print(url);
          print(response.statusCode);
          print(response.body);
        });
        item.status = 1;
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
