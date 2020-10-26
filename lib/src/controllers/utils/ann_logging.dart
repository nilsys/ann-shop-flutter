import 'dart:developer' as developer;

import 'package:ann_shop_flutter/core/core.dart';

class ANNLogging {
  static final _instance = ANNLogging._internal();
  static ANNLogging get instance => _instance;
  ANNLogging._internal();

  factory ANNLogging() => _instance;

  void logInfo(String message) {
    developer.log(message, time: DateTime.now(), name: Core.appSchema);
  }

  void logError(String message, Object e) {
    developer.log(message,
        time: DateTime.now(), name: Core.appSchema, error: e);
  }
}
