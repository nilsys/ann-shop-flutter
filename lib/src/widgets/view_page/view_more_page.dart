import 'dart:async';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/src/models/views/view_model.dart';
import 'package:ann_shop_flutter/src/models/views/view_navigation_bar.dart';
import 'package:ann_shop_flutter/src/services/views/view_service.dart';
import 'package:ann_shop_flutter/src/themes/ann_color.dart';
import 'package:ann_shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';

class ViewMorePage extends StatefulWidget {
  // region Parameters
  final slug;

  // endregion

  ViewMorePage(this.slug);

  @override
  _ViewMorePageState createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> {
  // region Parameters
  ViewService _service;
  Future<ViewModel> _fetchData;

  int _selectedIndex;

  // endregion

  @override
  void initState() {
    super.initState();

    _service = ViewService.instance;
    _fetchData = _service.getViewBySlug(widget.slug);

    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ViewModel>(
      future: _fetchData,
      builder: (BuildContext context, AsyncSnapshot<ViewModel> snapshot) {
        if (snapshot.hasData) {
          return _buildSuccess(context, snapshot.data);
        } else if (snapshot.hasError) {
          return _buildError(context);
        }

        // By default, show a loading spinner.
        return _buildLoading(context);
      },
    );
  }

  // region build
  // build the page when it is loading
  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đang tải...'),
      ),
      body: Container(child: Indicator()),
    );
  }

  //build the page when it is loaded
  Widget _buildSuccess(BuildContext context, ViewModel data) {
    String title = isEmpty(data.title) ? 'Thông báo' : data.title;
    String content = data.content;
    Widget child;

    if (Utility.isNullOrEmpty(content))
      child = new Center(
        child: Text('Không có nội dung'),
      );
    else
      child = new ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          HtmlContent(content),
        ],
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: child,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, data),
    );
  }

  // build the page when it has exception
  Widget _buildError(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đang tải...'),
      ),
      body: Container(
          child: SomethingWentWrong(
        onReload: () => setState(() {
          _fetchData = _service.getViewBySlug(widget.slug);
        }),
      )),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, ViewModel data) {
    return new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(
          Icon(Icons.cloud_download),
          'Tải hình',
        ),
        _buildBottomNavigationBarItem(
          Icon(Icons.share),
          'Đăng bài',
        ),
        _buildBottomNavigationBarItem(
          Icon(Icons.content_copy),
          'Copy',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: ANNColor.bottomNavigationBarColor,
      unselectedItemColor: ANNColor.bottomNavigationBarColor,
      onTap: (int index) => _onItemTapped(context, index, data),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      Widget icon, String title) {
    return new BottomNavigationBarItem(
      icon: icon,
      title: Text(
        title,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  // endregion

  void _onItemTapped(BuildContext context, int index, ViewModel data) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case ViewNavigationBar.download:
        _onClickDownload(context, data.images);
        break;
      case ViewNavigationBar.share:
        _onClickShare(context, data);
        break;
      case ViewNavigationBar.copy:
        _onClickCopy(context, data.postContent);
        break;
      default:
        break;
    }
  }

  void _onClickDownload(BuildContext context, List<String> images) async {
    if (images == null || images.length == 0) return;

    final loadingDialog = LoadingDialog(context, message: 'Đang tải...');

    loadingDialog.show();
    _service.downloadImage(context, images);
    loadingDialog.close();
  }

  void _onClickShare(BuildContext context, ViewModel data) async {
    final loadingDialog = LoadingDialog(context, message: 'Đang xử lý...');

    loadingDialog.show();
    Navigator.pushNamed(context, 'product/detail/share-social', arguments: {
      'images': data.images,
      'title': data.title,
      'message': data.postContent
    }).then((_) => loadingDialog.close());
  }

  void _onClickCopy(BuildContext context, String content) async {
    if (isEmpty(content)) return;

    final loadingDialog = LoadingDialog(context, message: 'Đang copy...');

    loadingDialog.show();
    await Future.delayed(const Duration(milliseconds: 500));
    await Clipboard.setData(new ClipboardData(text: content));
    loadingDialog.message = 'Đã xong';
    await Future.delayed(const Duration(milliseconds: 500));
    loadingDialog.close();
  }
}
