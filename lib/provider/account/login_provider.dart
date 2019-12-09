import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    // instructor
  }

  int phone;
  LoginState state;


}

enum LoginState{
  inputPhone,
  validateOTP
}