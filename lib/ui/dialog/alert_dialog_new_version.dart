import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertDialogNewVersion {
  static final AlertDialogNewVersion _instance =
      AlertDialogNewVersion._internal();

  final String _title = 'Cập nhật mới';
  final String _message = 'Ứng dụng đã có phiên bản mới.\nVui lòng cập nhật!';
  final String _btnLabel = 'Cập nhật ngay';
  final String _btnLabelCancel = 'Bỏ qua';

  AlertDialogNewVersion._internal();

  factory AlertDialogNewVersion() => _instance;

  static AlertDialogNewVersion get instance => _instance;

  Future<void> show(BuildContext context) async {
    var _alert;

    if (Platform.isIOS) {
      _alert = new CupertinoAlertDialog(
        title: Text(_title),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
            child: Text(_btnLabel),
            onPressed: () => _launchURL(Core.urlStore),
          ),
          FlatButton(
            child: Text(_btnLabelCancel),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    } else {
      _alert = new AlertDialog(
        title: Text(_title),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
            child: Text(_btnLabel),
            onPressed: () => _launchURL(Core.urlStore),
          ),
          FlatButton(
            child: Text(_btnLabelCancel),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _alert,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
