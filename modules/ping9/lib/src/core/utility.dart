import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';

final double defaultPadding = 15;
const int itemPerPage = 20;

class Utility {
  static String formatPrice(dynamic number) {
    final oCcy = new NumberFormat("#,###", "en_US");
    if (number is String) {
      if (number.toString().isNotEmpty) {
        int value = int.parse(number);

        return oCcy.format(value);
      } else {
        return '';
      }
    } else {
      return oCcy.format(number);
    }
  }

  static String fixFormatDate(String oldDay) {
    try {
      DateTime dateTime = DateTime.parse(oldDay);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      print(e);
      return '';
    }
  }
}

checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return (connectivityResult != ConnectivityResult.none);
}

bool isNullOrEmpty(object) {
  if (object == null) {
    return true;
  }
  if (object is String) {
    return object.trim().isEmpty;
  }
  if (object is Iterable) {
    return object.isEmpty;
  }
  if (object is Map) {
    return object.keys.isEmpty;
  }
  return false;
}
