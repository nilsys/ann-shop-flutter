import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/account/account.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppOneSignal {
  factory AppOneSignal() => instance;

  AppOneSignal._internal();

  static final AppOneSignal instance = AppOneSignal._internal();

  String userId;
  String pushToken;
  final _privateKey = "4cfab7f0-6dc2-4004-a631-fc4ba7cbf046";

  Future<void> initOneSignal() async {
    await OneSignal.shared.init(_privateKey, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    await OneSignal.shared
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

  bool isInitOpen = false;
  void initOneSignalOpenedHandler(BuildContext context) {
    if(isInitOpen){
      return;
    }
    isInitOpen = true;
    OneSignal.shared.setNotificationReceivedHandler((notification) {
//      _processNotificationReceived(notification, false);
    });

    OneSignal.shared.setNotificationOpenedHandler((notificationOpen) {
      _processNotificationReceived(notificationOpen.notification, false);
    });
    sendTagsUserInfo();
  }

  void _processNotificationReceived(OSNotification notification, bool init) {
    final payload = notification.payload;
    final launchUrl = payload.launchUrl;
    final data = payload.additionalData;

    if (isNullOrEmpty(data)) {
      final action = data['action'] ?? '';
      final value = data['actionValue'] ?? '';
      final message = data['message'] ?? 'Notification';

      if (init) {
        AppAction.instance
            .onHandleActionInit(MyApp.context, action, value, message);
      } else {
        AppAction.instance
            .onHandleAction(MyApp.context, action, value, message);
      }
    } else if (isNullOrEmpty(launchUrl) == false) {
      launch(launchUrl);
    }
  }

  void sendUserTag() {
    Account user = AC.instance.account;
    if (AC.instance.isLogin && user != null) {
      sendTags({
        NoticeTags.full_name: user.fullName,
        NoticeTags.phone: user.phone,
        NoticeTags.city: user.city
      });
    } else {
      deleteTags([NoticeTags.full_name, NoticeTags.phone, NoticeTags.city]);
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
  static const String full_name = "full_name";
  static const String phone = "phone";
  static const String city = "city";
}
