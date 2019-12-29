import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/view/inapp/inapp_view.dart';
import 'package:ann_shop_flutter/view/home_view/account_page.dart';
import 'package:ann_shop_flutter/view/home_view/category_page.dart';
import 'package:ann_shop_flutter/view/home_view/home_page.dart';
import 'package:ann_shop_flutter/view/home_view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);
    bool bigScreen = MediaQuery.of(context).size.width >= 320;
    return WillPopScope(
      onWillPop: () async {
        if (navigation.index != 0) {
          _onItemTapped(0);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, _) {
        if (navigationProvider.index != 0) {
          tabController.animateTo(navigationProvider.index);
        }

        return Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[
              HomePage(),
              CategoryPage(),
              SearchPage(
                showIcon: true,
              ),
              InAppView(),
              AccountPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: bigScreen,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: bigScreen
                ? BottomNavigationBarType.fixed
                : BottomNavigationBarType.shifting,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIcon(
                  AppIcons.home_outline,
                  size: 20,
                ),
                activeIcon: _buildIcon(
                  AppIcons.home,
                  size: 20,
                ),
                title: Text('Trang chủ'),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(
                  AppIcons.th_large_outline,
                  size: 20,
                ),
                activeIcon: _buildIcon(
                  AppIcons.th_large_1,
                  size: 20,
                ),
                title: Text('Danh mục'),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(
                  AppIcons.search,
                  size: 20,
                ),
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
    tabController.animateTo(_index);
  }
}
