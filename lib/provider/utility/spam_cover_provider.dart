import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/cover_repository.dart';
import 'package:flutter/material.dart';

class SpamCoverProvider extends ChangeNotifier {
  SpamCoverProvider() {
    // instructor
  }

  Map<String, ResponseProvider<List<Cover>>> covers = new Map();

  ResponseProvider<List<Cover>> getBySlug(String code) {
    if (covers[code] == null) {
      covers[code] = ResponseProvider<List<Cover>>();
      loadProduct(code);
    }
    return covers[code];
  }

  checkLoad(String code) {
    if (covers[code] == null) {
      covers[code] = ResponseProvider<List<Cover>>();
      loadProduct(code);
    } else {
      if (covers[code].isLoading == false ||
          covers[code].isCompleted == false) {
        loadProduct(code);
      }
    }
  }

  loadProduct(String code) async {
    if (covers[code] == null) {
      covers[code] = ResponseProvider<List<Cover>>();
    }
    try {
      covers[code].loading = 'Loading';
      var data = await CoverRepository.instance.loadCover(code);
      if (data == null) {
        covers[code].error = 'Load fail';
      } else {
        covers[code].completed = data;
      }
      notifyListeners();
    } catch (e) {
      covers[code].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }
}
