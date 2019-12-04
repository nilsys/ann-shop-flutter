import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier{

  int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    // todo
  }

  switchTo(value) {
    this.index = value;
    notifyListeners();
  }
}

enum PageName { home, category, search, account, basket }
