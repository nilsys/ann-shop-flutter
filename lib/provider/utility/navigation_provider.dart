import 'dart:async';

import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier{

  int index = 0;


  var reTap = StreamController<int>.broadcast();

  switchTo(int value) {
    if(index != value) {
      this.index = value;
      notifyListeners();
    }else{
      reTap.add(index);
    }
  }

}

enum PageName { home, category, search,notification, account}
