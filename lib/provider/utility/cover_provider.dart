import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/cover_repository.dart';
import 'package:flutter/material.dart';

class CoverProvider extends ChangeNotifier {
  CoverProvider() {
    covers = ResponseProvider();
    loadCoverHome();
  }

  ResponseProvider<List<Cover>> covers;

  loadCoverHome() async {
    try {
      covers.loading = 'try load';
      notifyListeners();
      List<Cover> data = await CoverRepository.instance.loadCoverHome();
      if (data != null) {
        covers.completed = data;
      } else {
        data = await CoverRepository.instance.loadCoverHomeOffline();
        covers.completed = data;
      }
    } catch (e) {
      log(e);
      covers.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }


  log(object) {
    print('cover_provider: ' + object.toString());
  }
}
