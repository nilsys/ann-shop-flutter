import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class AppDynamicLinks {
  factory AppDynamicLinks() => instance;

  AppDynamicLinks._internal();

  static final AppDynamicLinks instance = AppDynamicLinks._internal();

  bool isInit = false;

  void checkAndInit(context) {
    if (isInit) {
      return;
    }
    isInit = true;
    _initDynamicLinks(context);
  }

  Future<void> _initDynamicLinks(BuildContext context) async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      processDynamicLinks(context, deepLink, true);
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final deepLink = dynamicLink?.link;

      if (deepLink != null) {
        processDynamicLinks(context, deepLink, false);
      }
    }, onError: (e) async {
      print(e);
    });
  }

  void processDynamicLinks(BuildContext context, Uri deepLink, bool init) {
    if (deepLink.queryParameters != null) {
      final type = deepLink.queryParameters['action'] ?? '';
      final value = deepLink.queryParameters['actionValue'] ?? '';
      final message = deepLink.queryParameters['message'] ?? '';
      if (init) {
        AppAction.instance.onHandleActionInit(context, type, value, message);
      } else {
        AppAction.instance.onHandleAction(context, type, value, message);
      }
    }
  }
}
