import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
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
    tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);
    return MultiProvider(
      providers: [],
      child: WillPopScope(
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
                SearchPage(showIcon: true,),
                AccountPage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Trang chủ'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_module),
                  title: Text('Danh mục'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text('Tìm kiếm'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
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
      ),
    );
  }

  _onItemTapped(_index) {
    Provider.of<NavigationProvider>(context).switchTo(_index);
    tabController.animateTo(_index);
  }
}
