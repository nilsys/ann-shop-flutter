import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/repository/inapp_repository.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:ann_shop_flutter/ui/utility/inapp_item.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  _refreshData() {
    currentCategory = 'all';
    Provider.of<InAppProvider>(context).loadCoverInApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: _refreshData,
          )
        ],
      ),
      body: Consumer<InAppProvider>(
        builder: (context, provider, child) {
          if (provider.inApp.isLoading) {
            return Center(
              child: Indicator(),
            );
          } else if (provider.inApp.isError) {
            return SomethingWentWrong(
              onReload: () {
                _refreshData();
              },
            );
          } else {
            return _buildPageData(context);
          }
        },
      ),
    );
  }

  Widget _buildPageData(BuildContext context) {
    InAppProvider provider = Provider.of(context);
    final List<InApp> allData = provider.inApp.data;

    if (Utility.isNullOrEmpty(allData) == false) {
      final List<InApp> data = provider.getByCategory(currentCategory);

      return Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1, color: AppStyles.dividerColor)),
              ),
              child: _buildCategories(),
            ),
            Expanded(
              flex: 1,
              child: Utility.isNullOrEmpty(data)
                  ? Container()
                  : RefreshIndicator(
                      onRefresh: () async {
                        _refreshData();
                      },
                      child: CustomScrollView(
                        physics: ClampingScrollPhysics(),
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                return InAppItem(data[i]);
                              },
                              childCount: data.length,
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      );
    } else {
      return EmptyListUI(
        image: Icon(Icons.style, size: 30),
        body: 'Không có tin mới.',
      );
    }
  }

  String currentCategory = 'all';

  Widget _buildCategories() {
    return Column(
      children: <Widget>[
        _buildCategoryItem('all'),
        _buildCategoryItem('promotion'),
        _buildCategoryItem('news'),
        _buildCategoryItem('message'),
        _buildCategoryItem('other'),
      ],
    );
  }

  Widget _buildCategoryItem(String name) {
    InAppProvider provider = Provider.of<InAppProvider>(context);
    final List<InApp> data = provider.getByCategory(name);
    if (Utility.isNullOrEmpty(data) && name != 'all') {
      return Container();
    }

    bool hasNew = false;
    for (var item in data) {
      if (provider.checkOpen(item.id)) {
        hasNew = true;
        break;
      }
    }

    bool isChoose = name == currentCategory;
    Color chooseColor = Colors.white;
    Color unChooseColor = Colors.grey[300];
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isChoose ? chooseColor : unChooseColor,
        border: Border(
            left: isChoose
                ? BorderSide(width: 3, color: Theme.of(context).primaryColor)
                : BorderSide(width: 1, color: unChooseColor),
            bottom: BorderSide(width: 1, color: Colors.grey[600])),
      ),
      child: Stack(
        children: <Widget>[
          hasNew
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        )),
                  ),
                )
              : Container(),
          IconButton(
            onPressed: () {
              setState(() {
                currentCategory = name;
              });
            },
            icon: Icon(
              InAppRepository.instance.getIconInApp(name),
              color: AppStyles.dartIcon,
            ),
          ),
        ],
      ),
    );
  }
}
