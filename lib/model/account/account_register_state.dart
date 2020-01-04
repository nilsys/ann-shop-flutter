import 'dart:math';

class AccountRegisterState {
  static final AccountRegisterState instance = AccountRegisterState._internal();

  factory AccountRegisterState() => instance;

  AccountRegisterState._internal() {
    /// init
  }

  String _phone;

  String get phone => _phone;

  set phone(String phone) {
    if (_phone != phone) {
      _phone = phone;
      timeOTP = null;
    }
  }

  String password;
  String otp;

  reset() {
    _phone = null;
    password = null;
    Random rand = Random();
    otp = '';
    for (int i = 0; i < 6; i++) {
      otp += rand.nextInt(9).toString();
    }
    print('otp: $otp');
    timeOTP = null;
  }

  DateTime timeOTP;

  bool checkTimeOTP() {
    if (timeOTP == null) {
      return true;
    } else {
      Duration difference = DateTime.now().difference(timeOTP);
      if (difference.inMinutes > 1 || difference.inSeconds > 60) {
        return true;
      } else {
        return false;
      }
    }
  }

  int getDifferenceOTP() {
    if(timeOTP==null){
      return 60;
    }
    return DateTime.now().difference(timeOTP).inSeconds;
  }
}
