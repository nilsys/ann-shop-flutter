import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppOneSignal {
  static final AppOneSignal instance = AppOneSignal._internal();

  factory AppOneSignal() {
    return instance;
  }

  AppOneSignal._internal();

  String userId;
  String pushToken;
  final _privateKey = "4cfab7f0-6dc2-4004-a631-fc4ba7cbf046";

  void initOneSignal(BuildContext context) async {

    OneSignal.shared.init(_privateKey, iOSSettings: {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });

  }

  void initOneSignalOpenedHandler(BuildContext context) {
    OneSignal.shared.setNotificationReceivedHandler((notification) {
//      _processNotificationReceived(notification, false);
    });

    OneSignal.shared.setNotificationOpenedHandler((notificationOpen) {
      _processNotificationReceived(notificationOpen.notification, false);
    });
  }

  void _processNotificationReceived(OSNotification notification, bool init) {
    OSNotificationPayload payload = notification.payload;
    String launchUrl = payload.launchUrl;
    Map<String, dynamic> data = payload.additionalData;

    if (data.keys.length > 0) {
      String action = data.keys.elementAt(0);
      String value = data[action];

      if (init) {
        AppAction.instance
            .onHandleActionInit(MyApp.context, action, value, '');
      } else {
        AppAction.instance
            .onHandleAction(MyApp.context, action, value, '');
      }
    } else if (Utility.isNullOrEmpty(launchUrl) == false) {
      launch(launchUrl);
    }
  }

  void sendTag(String name, dynamic value) {
    OneSignal.shared.sendTag(name, value);
  }

  void sendTags(Map<String, dynamic> tags) {
    OneSignal.shared.sendTags(tags);
  }

  void deleteTag(String name) {
    OneSignal.shared.deleteTag(name);
  }

  void deleteTags(List<String> names) {
    OneSignal.shared.deleteTags(names);
  }

  void sendTagsUserInfo() {}
}

class NoticeTags {
  static const String logon = "logon";
  static const String last_name = "full_name";
}
