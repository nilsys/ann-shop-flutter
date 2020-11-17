import 'dart:async';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/utility/my_video.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_download.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:flutube/flutube.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/src/controllers/views/view_controller.dart';
import 'package:ann_shop_flutter/src/models/views/view_model.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';

class ViewMorePage extends StatefulWidget {
  final slug;

  ViewMorePage(this.slug);

  @override
  _ViewMorePageState createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> {
  Future<ViewModel> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = ViewController.instance.getViewBySlug(widget.slug);
  }

  @override
  void dispose() {
    // VideoHelper.instance.dispose();
    super.dispose();
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
        return _buildLoading(context);
      },
    );
  }

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
    final isFull = isFullScreen(context);
    if (isNullOrEmpty(content))
      child = EmptyListUI(
        body: "Không có nội dung",
      );
    else {
      if (isNullOrEmpty(data.video))
        child = SingleChildScrollView(child: HtmlContent(content));
      else
        child = ANNPlayer(
          data.video.url,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 16),
            child: HtmlContent(content),
          ),
        );
    }
    return Scaffold(
      appBar: isFull
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: AppStyles.dartIcon),
              actionsIconTheme: IconThemeData(color: AppStyles.dartIcon),
              title: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            ),
      body: SafeArea(child: child),
      bottomNavigationBar:
          isFull ? null : _buildBottomNavigationBar(context, data),
    );
  }

  // build the page when it has exception
  Widget _buildError(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đang tải...'),
      ),
      body: SomethingWentWrong(
        onReload: () async {
          setState(() {
            _fetchData = ViewController.instance.getViewBySlug(widget.slug);
          });
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, ViewModel data) {
    return BottomAppBar(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isNullOrEmpty(data?.video) == false)
                ButtonIconText(
                  'Tải Video',
                  Icons.video_library,
                  onPressed: () => ANNDownload.instance
                      .onDownLoadVideo(context, [data.video.url]),
                ),
              if (isNullOrEmpty(data.images) == false)
                ButtonIconText(
                  'Tải hình',
                  MaterialCommunityIcons.image_multiple,
                  onPressed: () => ANNDownload.instance
                      .onDownLoadImages(context, data.images),
                ),
              ButtonIconText(
                'Đăng bài',
                Icons.share,
                onPressed: () => _onClickShare(context, data),
              ),
              ButtonIconText(
                "Copy",
                Icons.content_copy,
                onPressed: () => _onClickCopy(context, data.postContent),
              )
            ],
          ),
          DownLoadBackground(),
        ],
      ),
    );
  }

  Future<void> _onClickShare(BuildContext context, ViewModel data) async {
    if (AC.instance.canPostBloc == false) {
      AppSnackBar.askLogin(context);
      return;
    }

    showLoading(context, message: 'Đang xử lý...');
    List<MyVideo> videos =
        await ViewController.instance.getViewMoreVideo(data.id);
    hideLoading(context);

    await Navigator.pushNamed(
      context,
      'product/detail/share-social',
      arguments: {
        'images': data.images,
        'videos': videos,
        'title': data.title,
        'message': data.postContent
      },
    );
  }

  void _onClickCopy(BuildContext context, String content) async {
    if (AC.instance.canCopyBloc == false) {
      AppSnackBar.askLogin(context);
      return;
    }

    if (isEmpty(content)) return;

    showLoading(context, message: 'Đang copy...');

    await Future.delayed(const Duration(milliseconds: 500));
    await Clipboard.setData(new ClipboardData(text: content));
    updateLoading('Đã copy xong');
    await Future.delayed(const Duration(milliseconds: 500));
    hideLoading(context);
  }
}
