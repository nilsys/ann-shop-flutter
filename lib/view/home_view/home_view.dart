import 'package:ann_shop_flutter/core/app_dynamic_links.dart';
import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/app_onesignal.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/view/inapp/inapp_view.dart';
import 'package:ann_shop_flutter/view/home_view/account_page.dart';
import 'package:ann_shop_flutter/view/home_view/category_page.dart';
import 'package:ann_shop_flutter/view/home_view/home_page.dart';
import 'package:ann_shop_flutter/view/home_view/search_page.dart';
import 'package:ann_shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final children = <Widget>[
    HomePage(),
    CategoryPage(),
    SearchPage(),
    InAppView(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);
    bool bigScreen = MediaQuery.of(context).size.width >= 320;
    return WillPopScope(
      onWillPop: () async {
        _onItemTapped(0);
        return Future.value(false);
      },
      child: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, _) {
        return Scaffold(
          body: children.elementAt(navigationProvider.index),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: bigScreen,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: bigScreen
                ? BottomNavigationBarType.fixed
                : BottomNavigationBarType.shifting,
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
      }),
    );
  }

  Widget _buildIcon(IconData icon, {double size}) {
    return Container(
        height: 30,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: size,
        ));
  }

  _onItemTapped(_index) {
    Provider.of<NavigationProvider>(context).switchTo(_index);
//      tabController.animateTo(_index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppDynamicLinks.instance.checkAndInit();
//    AppOneSignal.instance.checkAndInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
    print('App resume call back');
    print(MediaQuery.of(context).viewInsets.bottom);
    if (MediaQuery.of(context).viewInsets.bottom > 100) {
      showDialog(context: context, child: FixViewInsetsBottom());
    }
  }
}
