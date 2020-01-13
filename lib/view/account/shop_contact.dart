import 'dart:io';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/repository/utility_repository.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopContact extends StatelessWidget {
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
      body: FutureProvider<Map>(
          create: (_) => UtilityRepository.instance.loadContact(),
          child: Consumer<Map>(
            builder: (key, Map data, child) {
              if (data == null) {
                return Indicator();
              } else {
                final urlMap = data['urlMap'];
                final urlFB = data['urlFB'];
                final urlWebsite = data['urlWebsite'];
                final address = data['address'];
                final timeWork = data['timeWork'];
                final phones =
                    data['phone'] == null ? [] : data['phone'].cast<String>();

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(children: [
                          _buildTitle('Địa chỉ: '),
                          _buildBody(address),
                          _buildLink('(xem bản đồ Google)', urlMap),
                        ]),
                      ),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(children: [
                          _buildTitle('Zalo: '),
                          _buildLinkZalo(phones[0]),
                          _buildBody('  -  '),
                          _buildLinkZalo(phones[1]),
                          _buildBody('  -  '),
                          _buildLinkZalo(phones[2]),
                          _buildBody('  -  '),
                          _buildLinkZalo(phones[3]),
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
                          _buildTitle(timeWork),
                        ]),
                      ),
                    ],
                  ),
                );
              }
            },
          )),
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

  _buildLinkZalo(name) {
    return TextSpan(
      text: name,
      style: styleLink,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          launch("https://zalo.me/$name");
        },
    );
  }

  _buildLinkPhone(name) {
    return TextSpan(
      text: name,
      style: styleLink,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          if (Platform.isIOS) {
            launch("tel:/$name");
          } else {
            launch("tel:$name");
          }
        },
    );
  }
}
