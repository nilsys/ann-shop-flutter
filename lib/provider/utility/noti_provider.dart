import 'dart:convert';
import 'dart:core';
import 'package:ann_shop_flutter/model/utility/noti.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationProvider with ChangeNotifier {
  ResponseProvider<List<Noti>> notifications;

  NotificationProvider() {
    // init
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkReload() {
    if (notifications.isLoading == false) {
      if (notifications.isLoadFinish() == false) {
        fetchNotification();
      }
    }
  }

  fetchNotification() async {
    try {
      notifications.loading = 'loading';
      notifyListeners();
      final url = 'xuongann.com/api/v1/inbox/get-inbox';
      final response = await http.get(url);
      print(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var message = json.decode(response.body);
        if (message['message'] == null ||
            message['message'].toString().length < 10) {
          notifications.completed = new List();
        } else {
          var list = message['message'] as List;
          notifications.completed =
              list.map((item) => Noti.fromMap(item)).toList();
        }
      } else {
        notifications.error = 'Error statusCode ${response.statusCode}';
      }
    } catch (e) {
      notifications.error = 'Error exception' + e.toString();
      print('fetchNotification ' + e.toString());
    }
    notifyListeners();
  }

  openNotification(String id) async {
    try {
      var item = notifications.data.firstWhere((item) => item.id == id);
      if (item != null && item.status == '0') {
        var _body = {
          "id": id.toString(),
        };
        final url = 'xuongann.con/api/v1/inbox/update-status';
        http.post(url, body: jsonEncode(_body)).then((response) {
          print(url);
          print(response.statusCode);
          print(response.body);
        });
        item.status = '1';
        notifyListeners();
      }
    } catch (e) {
      print('Read notification: ' + e.toString());
    }
  }
}
