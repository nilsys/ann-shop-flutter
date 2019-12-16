import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopContact extends StatelessWidget {
  final urlMap = 'https://www.google.com/maps?cid=5068651584244638837&hl=vi';
  final urlFB = 'https://fb.com/bosiquanao.net';
  final urlWebsite = 'http://xuongann.com/';

  final phones = ['0918569400', '0918567409', '0913268406', '0936786404'];
  final styleTitle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87);
  final styleBody = TextStyle(
      fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black87);
  final styleLink = TextStyle(
      fontSize: 18, fontWeight: FontWeight.normal, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin liên hệ'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            RichText(
              text: TextSpan(children: [
                _buildTitle('Địa chỉ: '),
                _buildBody('68 Đường C12, P. 13, Q. Tân Bình, TP. HCM   '),
                _buildLink('(xem bản đồ Google)', urlMap),
              ]),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(children: [
                _buildTitle('Zalo: '),
                _buildLinkPhone(phones[0]),
                _buildBody('  -  '),
                _buildLinkPhone(phones[1]),
                _buildBody('  -  '),
                _buildLinkPhone(phones[2]),
                _buildBody('  -  '),
                _buildLinkPhone(phones[3]),
              ]),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(children: [
                _buildTitle('Facebook: '),
                _buildLink(urlFB, urlFB),
              ]),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(children: [
                _buildTitle('Website: '),
                _buildLink(urlWebsite, urlWebsite),
              ]),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(children: [
                _buildTitle('Làm việc: 8h30 - 20h30 (Chủ Nhật 8h30 - 18h30)'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _buildTitle(name) {
    return TextSpan(
      text: name,
      style: styleTitle,
    );
  }

  _buildBody(name) {
    return TextSpan(
      text: name,
      style: styleBody,
    );
  }

  _buildLink(name, link) {
    return TextSpan(
      text: name,
      style: styleLink,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          launch(link);
        },
    );
  }

  _buildLinkPhone(name) {
    return TextSpan(
      text: name,
      style: styleLink,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          launch("https://zalo.me/$name");
//          if (Platform.isIOS) {
//            launch("tel:/$name");
//          } else {
//            launch("tel:$name");
//          }
        },
    );
  }
}
