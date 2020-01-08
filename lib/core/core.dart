
import 'package:connectivity/connectivity.dart';

final double defaultPadding = 15;
const int itemPerPage = 20;

class Core {
  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    /// init
  }

  static const domain = 'http://xuongann.com/';
}


checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return (connectivityResult != ConnectivityResult.none);
}