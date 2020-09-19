import 'dart:async';

import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';


import 'package:flutter/material.dart';

class ProductBanner extends StatefulWidget {
  ProductBanner(this.covers, {this.border});

  final BoxBorder border;
  final List<Cover> covers;

  @override
  _ProductBannerState createState() => _ProductBannerState();
}

class _ProductBannerState extends State<ProductBanner>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = Timer.periodic(Duration(seconds: 5), _autoChangePage);
  }

  void _autoChangePage(timer) {
    if (_pageController == null || length < 1) {
    } else {
      if (_currentPage < (length - 1)) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    time.cancel();
    super.dispose();
  }

  int length = -1;
  Timer time;
  final ratio = 25 / 80;
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1, keepPage: false);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final double padding = 0;
    final width = MediaQuery.of(context).size.width - (padding * 2);
    final height = width * ratio;
    var covers = widget.covers;
    if (isNullOrEmpty(covers)) {
      length = -1;
      return Container();
    } else {
      length = covers.length;
      return Container(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
//                    borderRadius: BorderRadius.circular(5),
                  border: widget.border,
                ),
                margin: EdgeInsets.symmetric(horizontal: padding),
                child: _buildPageView(context, covers)),
            covers.length > 1 ? _buildDot(context) : Container(),
          ],
        ),
      );
    }
  }

  Widget _buildPageView(context, List<Cover> covers) {
    return PageView.builder(
      controller: _pageController,
      pageSnapping: true,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        return _buildBanner(context, covers[index]);
      },
      itemCount: length,
    );
  }

  Widget _buildDot(context) {
    List listIndex = List.generate(length, (index) => index);
    return Positioned(
      right: 30,
      bottom: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: listIndex.map((index) {
          return Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.white : Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBanner(context, Cover item) {
    return InkWell(
      onTap: () {
        AppAction.instance
            .onHandleAction(context, item.action, item.actionValue, item.name);
      },
      child: ClipRRect(
//        borderRadius: BorderRadius.circular(5),
        child: AppImage(
          item.image,
          fit: BoxFit.cover,
          showLoading: true,
        ),
      ),
    );
  }
}
