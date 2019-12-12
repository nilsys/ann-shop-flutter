import 'dart:io';
import 'package:ann_shop_flutter/repository/load_more_product_repository.dart';
import 'package:ann_shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CustomLoadMoreIndicator extends StatelessWidget {

  final LoadMoreProductRepository listSourceRepository;
  final IndicatorStatus status;

  CustomLoadMoreIndicator(this.listSourceRepository, this.status);

  @override
  Widget build(BuildContext context) {

    bool isSliver = true;

    Widget widget;
    switch (status) {
      case IndicatorStatus.None:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.LoadingMoreBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7.0),
              height: 15.0,
              width: 15.0,
              child: getIndicator(context),
            ),
            Text('Đang tải..') // load more item when scroll position at bottom
          ],
        );
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.FullScreenBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7.0),
              height: 30.0,
              width: 30.0,
              child: getIndicator(context),
            ),
            Text('Đang tải..') // load more item when scroll position at bottom
          ],
        );
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.Error:
        widget = Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error, size: 25),
              Text("Có lỗi xảy ra, chạm để thử lại...")
            ],
          ),
        );
        widget = _setbackground(false, widget, 35.0);

        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.FullScreenError:
        widget = SomethingWentWrong();
        widget = _setbackground(true, widget, double.infinity);
        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = Text("Đã hiển thị tất cả sản phẩm.");
        widget = _setbackground(false, widget, 25.0);
        break;
      case IndicatorStatus.Empty:

        widget =  EmptyListUI();
        widget = _setbackground(true, widget, double.infinity, context:context);

        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }

  Widget _setbackground(bool full, Widget widget, double height, {BuildContext context}) {
    widget = ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity, minHeight:context!=null? MediaQuery.of(context).size.height - 140 : height),
      child: Container(
        /*width: double.infinity,
        height: height,*/
        child: widget,
        color: Colors.transparent,
        alignment: Alignment.center,
      ),
    );
    return widget;
  }

  Widget getIndicator(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
      animating: true,
      radius: 16.0,
    )
        : CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
    );
  }
}

class CommonSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  CommonSliverPersistentHeaderDelegate(this.child, this.height);

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(CommonSliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}