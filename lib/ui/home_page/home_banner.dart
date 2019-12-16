import 'dart:async';

import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    Timer.periodic(Duration(seconds: 5), _autoChangePage);
  }

  void _autoChangePage(timer) {
    if (_pageController == null) {
    } else {
      if (_currentPage < 1) {
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

  final height = 120.0;
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1, keepPage: false);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    CoverProvider provider = Provider.of(context);
    return Container(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: height / 2),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: provider.covers.isCompleted
                ? _buildPageView(context)
                : Center(
                    child: UIManager.defaultIndicator(),
                  ),
          ),
          provider.covers.isCompleted ? _buildDot(context) : Container(),
        ],
      ),
    );
  }

  Widget _buildPageView(context) {
    CoverProvider provider = Provider.of(context);

    return PageView.builder(
      controller: _pageController,
      pageSnapping: true,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        return _buildBanner(context, provider.covers.data[index]);
      },
      itemCount: provider.covers.data.length,
    );
  }

  Widget _buildDot(context) {
    CoverProvider provider = Provider.of(context);
    List indexs = List.generate(provider.covers.data.length, (index) => index);
    return Positioned(
      right: 30,
      bottom: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: indexs.map((index) {
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
            .onHandleAction(context, item.type, item.value, item.name);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: AppImage(
          item.image,
          fit: BoxFit.cover,
          showLoading: true,
        ),
      ),
    );
  }
}
