import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

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



void printTrack(Object object, {int frames = 1}) {
  final output = "${Trace.current().frames[frames].location} | $object";
  final pattern = RegExp('.{1,1000}');
  pattern.allMatches(output).forEach((match) => debugPrint(match.group(0)));
}
