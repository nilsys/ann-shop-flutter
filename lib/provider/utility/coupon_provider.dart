import 'package:ann_shop_flutter/model/utility/coupon.dart';
import 'package:ann_shop_flutter/model/utility/promotion.dart';
import 'package:ping9/ping9.dart';

import 'package:ann_shop_flutter/provider/utility/coupon_repository.dart';
import 'package:flutter/material.dart';

class CouponProvider extends ChangeNotifier {
  ApiResponse<List<Coupon>> myCoupons;
  ApiResponse<List<Promotion>> promotions;

  CouponProvider() {
    myCoupons = ApiResponse();
    promotions = ApiResponse();

    loadListPromotion();
    loadMyCoupon();
  }

  Future loadMyCoupon() async {
    try {
      myCoupons.loading = 'try load categories';
      notifyListeners();
      final data = await CouponRepository.instance.loadMyCoupon();
      if (data != null) {
        myCoupons.completed = data;
        notifyListeners();
        return;
      }
    } catch (e) {
      print(e);
    }
    myCoupons.error = 'Load fail';
    notifyListeners();
  }

  Future loadListPromotion() async {
    try {
      promotions.loading = 'try load categories';
      notifyListeners();
      final data = await CouponRepository.instance.loadListPromotion();
      if (data != null) {
        promotions.completed = data;
        notifyListeners();
        return;
      }
    } catch (e) {
      print(e);
    }
    promotions.error = 'Load fail';
    notifyListeners();
  }
}
