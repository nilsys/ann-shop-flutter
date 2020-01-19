import 'package:ann_shop_flutter/model/utility/coupon.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/coupon_repository.dart';
import 'package:flutter/material.dart';

class CouponProvider extends ChangeNotifier {
  CouponProvider() {
    coupons = ResponseProvider();
//    loadData();
  }

  ResponseProvider<List<Coupon>> coupons;

  loadData() async {
    try {
      coupons.loading = 'try load categories';
      notifyListeners();
      List<Coupon> data =
      await CouponRepository.instance.loadMyCoupon();
      if (data != null) {
        coupons.completed = data;
        notifyListeners();
        return;
      }
    } catch (e) {
      log(e);
    }
    coupons.error = 'Load fail';
    notifyListeners();
  }



  log(object) {
    print('coupon_provider: ' + object.toString());
  }
}
