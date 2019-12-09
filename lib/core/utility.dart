import 'package:intl/intl.dart';

class Utility {

  static bool isNullOrEmpty<T>(Iterable<T> array) {
    return array == null || array.length == 0;
  }

  static bool stringIsNullOrEmpty(String value) {
    return (value?.trim()?.isEmpty ?? true);
  }

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

  static String phoneNumberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Vui lòng nhập số điện thoại';
    } else if (!regExp.hasMatch(value)) {
      return 'Số điện thoại chưa đúng';
    }
    return null;
  }
}
