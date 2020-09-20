import 'dart:async';

import 'package:flutter/services.dart';

class OrientationControl {
  static const MethodChannel _channel = MethodChannel('orientation');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> forcePortraitIOS() async {
    await _channel.invokeMethod('forceOrientationPortrait');
  }

  static Future<void> forceLanscapeLeftIOS() async {
    await _channel.invokeMethod('forceOrientationLanscapeLeft');
  }

  static Future<void> forceLanscapeRightIOS() async {
    await _channel.invokeMethod('forceOrientationLanscapeRight');
  }
}
