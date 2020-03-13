import 'dart:async';

import 'package:ann_shop_flutter/core/app_dynamic_links.dart';
import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/app_onesignal.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/src/themes/ann_color.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/view/home_view/account_page.dart';
import 'package:ann_shop_flutter/view/home_view/category_page.dart';
import 'package:ann_shop_flutter/view/home_view/home_page.dart';
import 'package:ann_shop_flutter/view/home_view/search_page.dart';
import 'package:ann_shop_flutter/view/inapp/inapp_view.dart';
import 'package:ann_shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // region Parameters
  Timer _timer;

  // endregion

  // region Widgets
  final children = <Widget>[
    HomePage(),
    CategoryPage(),
    SearchPage(),
    NotificationPage(),
    AccountPage(),
  ];

  // endregion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppDynamicLinks.instance.checkAndInit();

    WidgetsBinding.instance.addObserver(this);

    _timer = new Timer(const Duration(seconds: 5), () {
      try {
        Core.instance.versionCheck(context);
      } catch (e) {}
      AppOneSignal.instance.checkAndInit();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onItemTapped(0);
        return Future.value(false);
      },
      child: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, _) {
        return Scaffold(
            body: _buildBody(context, navigationProvider),
            bottomNavigationBar: _buildBottomNavigationBar(context));
      }),
    );
  }

  // region build the page
  // Create body
  Widget _buildBody(BuildContext context, NavigationProvider navigation) {
    return children.elementAt(navigation.index);
  }

  // Create bottom navigation bar
  Container _buildBottomNavigationBar(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);
    final textStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    final bigScreen = MediaQuery.of(context).size.width >= 320;
    final btNavBarType = bigScreen
        ? BottomNavigationBarType.fixed
        : BottomNavigationBarType.shifting;

    return new Container(
      color: const Color(0xFF000000),
      child: BottomNavigationBar(
        showUnselectedLabels: bigScreen,
        backgroundColor: ANNColor.white,
        selectedLabelStyle: textStyle,
        unselectedLabelStyle: textStyle,
        type: btNavBarType,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(AppIcons.home_outline, size: 20),
            activeIcon: _buildIcon(AppIcons.home, size: 20),
            title: Text('Trang chủ'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppIcons.th_large_outline, size: 18),
            activeIcon: _buildIcon(AppIcons.th_large_1, size: 20),
            title: Text('Danh mục'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppIcons.search, size: 20),
            title: Text('Tìm kiếm'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications_none),
            activeIcon: _buildIcon(Icons.notifications),
            title: Text('Thông báo'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.perm_identity),
            activeIcon: _buildIcon(Icons.person),
            title: Text('Cá nhân'),
          ),
        ],
        currentIndex: navigation.index,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: AppStyles.dartIcon,
        onTap: _onItemTapped,
      ),
    );
  }

  // Create Icon
  Widget _buildIcon(IconData icon, {double size}) {
    return Container(
        height: 30,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: size,
        ));
  }

  // endregion

  // region handle the page
  _onItemTapped(_index) {
    Provider.of<NavigationProvider>(context, listen: false).switchTo(_index);
  }

  // endregion

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState _state) async {
    switch (_state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      default:
        break;
    }
  }

  resumeCallBack() {
    if (MediaQuery.of(context).viewInsets.bottom > 100) {
      showDialog(context: context, child: FixViewInsetsBottom());
    }
  }
}
