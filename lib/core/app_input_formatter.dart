import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int value = int.parse(newValue.text);

    final formatter = new NumberFormat("###,###", "en_US");

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class OTPInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newText = newValue.text;
    if(newText.length == 5) {
      if (oldValue.text.contains('_')) {
        newText = newText.replaceAll(RegExp('[^0-9]'), '');
        if (newText.length > 0) {
          newText = newText.substring(0, newText.length - 1);
        }
      } else {
        print(oldValue.text);
        print(newValue.text);
      }
    }else {
      newText = newText.replaceAll(RegExp('[^0-9]'), '');
    }
    for (int i = newText.length; i < 6; i++) {
      newText += '_';
    }
    newText = newText.substring(0, 6);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
