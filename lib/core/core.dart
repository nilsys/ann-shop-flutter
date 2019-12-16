
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';

final double defaultPadding = 15;
final int itemPerPage = 30;
ConfigProvider appConfig;
class Core {

  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    /// init
  }

  static const appVersion = '1.0.0';

  static const domainAPI = 'http://xuongann.com/api/v1/';
  static const domain = 'http://xuongann.com/';

  static bool get isLogin => false;
}