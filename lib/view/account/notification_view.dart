import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/utility/in_app.dart';
import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/repository/cover_repository.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/empty_list_ui.dart';
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
    final List<InApp> data = provider.inApp.data;

    if (Utility.isNullOrEmpty(data) == false) {
      return RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: CustomScrollView(physics: ClampingScrollPhysics(), slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, i) {
              return _buildNotification(context, data[i]);
            },
            childCount: data.length,
          )),
        ]),
      );
    } else {
      return EmptyListUI(
        image: Icon(Icons.style, size: 30),
        body: 'Không có tin mới.',
      );
    }
  }

  Widget _buildNotification(BuildContext context, InApp item) {
    print(item.toJson().toString());
    bool isNew = Provider.of<InAppProvider>(context).checkOpen(item.id);
    return InkWell(
      onTap: () {
        if (item.type.trim().toLowerCase() == ActionType.openPopup) {
          AppPopup.showCustomDialog(context,
              title: item.name,
              message: item.message,
              btnNormal: ButtonData(title: 'Đóng'));
        } else {
          AppAction.instance
              .onHandleAction(context, item.type, item.value, item.name);
        }
        if (isNew) _readNotification(item.id);
      },
      child: Container(
        color: isNew ? Colors.blue[50] : Colors.white,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CoverRepository.instance
                            .getColorInApp(item.category),
                      ),
                      child: Icon(
                          CoverRepository.instance.getIconInApp(item.category)),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              textAlign: TextAlign.start,
                              maxLines: 10,
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              Utility.fixFormatDate(item.createdDate),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 10),
                child: Text(
                  item.message,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              Container(
                height: 1,
                color: AppStyles.dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _readNotification(int notificationID) {
    Provider.of<InAppProvider>(context).openNotification(notificationID);
  }
}
