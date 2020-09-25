import 'dart:async';

import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';

import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    time = Timer.periodic(Duration(seconds: 8), _autoChangePage);
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
    CoverProvider provider = Provider.of(context);
    final width = MediaQuery.of(context).size.width - (defaultPadding * 2);
    final height = width * ratio;
    if (provider.coversHome.data != null) {
      length = provider.coversHome.data.length;
    } else {
      length = -1;
    }
    return Container(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(bottom: height / 2),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: provider.coversHome.isCompleted
                ? _buildPageView(context)
                : Center(
                    child: Indicator(),
                  ),
          ),
          (provider.coversHome.isCompleted &&
                  provider.coversHome.data.length > 1)
              ? _buildDot(context)
              : Container(),
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
        return _buildBanner(context, provider.coversHome.data[index]);
      },
      itemCount: provider.coversHome.data.length,
    );
  }

  Widget _buildDot(context) {
    CoverProvider provider = Provider.of(context);
    List listIndex =
        List.generate(provider.coversHome.data.length, (index) => index);
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
              color: _currentPage == index ? Colors.white : AppStyles.grey,
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
