import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';

import 'package:ann_shop_flutter/provider/utility/cover_repository.dart';
import 'package:flutter/material.dart';

class SpamCoverProvider extends ChangeNotifier {
  SpamCoverProvider() {
    // instructor
  }

  Map<String, ApiResponse<List<Cover>>> covers = new Map();

  ApiResponse<List<Cover>> getBySlug(String code) {
    if (covers[code] == null) {
      covers[code] = ApiResponse<List<Cover>>();
      loadCover(code);
    }
    return covers[code];
  }

  checkLoad(String code) {
    if (covers[code] == null) {
      covers[code] = ApiResponse<List<Cover>>();
      loadCover(code);
    } else {
      if (covers[code].isLoading == false ||
          covers[code].isCompleted == false) {
        loadCover(code);
      }
    }
  }

  loadCover(String code) async {
    if (covers[code] == null) {
      covers[code] = ApiResponse<List<Cover>>();
    }
    if (isNullOrEmpty(code)) {
      covers[code].completed = [];
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
