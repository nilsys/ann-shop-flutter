import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:flutube/src/models/my_video.dart';
import 'package:ann_shop_flutter/provider/utility/gallery_saver_helper.dart';
import 'package:ann_shop_flutter/src/controllers/common/permission_controller.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:ann_shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ping9/ping9.dart';
import 'package:share/share.dart';

class SharePage extends StatefulWidget {
  final Map data;

  const SharePage(this.data);

  @override
  _SharePageState createState() => _SharePageState(
        titleShare: data['title'],
        messageShare: data['message'],
        images: data['images'] ?? [],
        videos: data['videos'] ?? [],
      );
}

class _SharePageState extends State<SharePage> {
  _SharePageState(
      {this.images, this.messageShare, this.titleShare, this.videos});

  final List<String> images;
  final List<MyVideo> videos;
  final String messageShare;
  final String titleShare;

  final int limitImage = 28;

  int maxImage;
  List<String> imagesSelected;
  List<MyVideo> videosSelected;

  // endregion

  @override
  void initState() {
    super.initState();

    // region init Parameters
    maxImage = min(limitImage, images.length);
    videosSelected = [];
    imagesSelected = [];
    for (int i = 0; i < images.length && i < maxImage; i++) {
      imagesSelected.add(images[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomAppBar(context),
      ),
    );
  }

  // region build the page
  // Create AppBar
  AppBar _buildAppBar(BuildContext context) {
    String title = "Đăng bài viết";
    if (images.isNotEmpty && videos.isEmpty) {
      title = 'Đã chọn ${imagesSelected.length}/$maxImage hình';
    }

    return new AppBar(
      leading: IconButton(
        icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        onPressed: () {
          if (MediaQuery.of(context).viewInsets.bottom > 100) {
            Navigator.pop(context);
            showDialog(context: context, child: FixViewInsetsBottom());
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(title),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Bỏ chọn',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => setState(() {
            imagesSelected = [];
            videosSelected = [];
          }),
        )
      ],
    );
  }

  // Create Body
  Widget _buildBody(BuildContext context) {
    if (images == null || images.length == 0) {
      var message = '';

      message += 'Bài viết hoặc sản phẩm không có hình.\n';
      message += 'Hãy chọn đăng Facebook/Zalo như bình thường.';

      return Center(child: Text(message, textAlign: TextAlign.center));
    }

    return new SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          if (videos.isNotEmpty) ...[
            _buildTitle("Video " +
                (videosSelected.isNotEmpty
                    ? "${videosSelected.length}/${videos.length}"
                    : "")),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildVideo(context, videos[index]),
                  childCount: videos.length,
                ),
              ),
            ),
            _buildTitle("Hình ảnh " +
                (imagesSelected.isNotEmpty
                    ? "${imagesSelected.length}/$maxImage"
                    : "")),
          ],
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildImage(context, images[index]),
                childCount: images.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  // Create Bottom App Bar
  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return new BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      const Text('Đăng Facebook '),
                      Icon(
                        AppIcons.facebook_official,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  onPressed: _onClickShareFacebook,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppStyles.dividerColor,
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Đăng Zalo '),
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ui/zalo-logo.png'),
                    )
                  ],
                ),
                onPressed: _onClickShareZalo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideo(BuildContext context, MyVideo video) {
    final bool isSelected = videosSelected.contains(video);
    final double opacity = isSelected ? 1.0 : 0.7;

    final imageWidget = InkWell(
      onTap: () => setState(() => _onClickVideo(isSelected, video)),
      child: Opacity(
        opacity: opacity,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                image: isNullOrEmpty(video.thumbnail)
                    ? null
                    : DecorationImage(
                        image: NetworkImage(video.thumbnail),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Center(
                child: Icon(
                  Icons.videocam_outlined,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            )),
      ),
    );

    final imageSelectedWidget = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        imageWidget,
        Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 18, color: Colors.white),
            ))
      ],
    );

    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: isSelected ? imageSelectedWidget : imageWidget,
    );
  }

  Widget _buildImage(BuildContext context, String url) {
    final bool isSelected = imagesSelected.contains(url);
    final double opacity = isSelected ? 1.0 : 0.7;

    final imageWidget = InkWell(
      onTap: () => setState(() => _onClickImage(isSelected, url)),
      child: Opacity(
        opacity: opacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AppImage(url),
        ),
      ),
    );

    final imageSelectedWidget = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        imageWidget,
        Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 18, color: Colors.white),
            ))
      ],
    );

    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: isSelected ? imageSelectedWidget : imageWidget,
    );
  }

  void _onClickVideo(bool isSelected, MyVideo video) {
    if (isSelected) {
      videosSelected.remove(video);
    } else {
      videosSelected.add(video);
    }
  }

  // Handle to select the image
  void _onClickImage(bool isSelected, String url) {
    if (isSelected) {
      imagesSelected.remove(url);
    } else {
      if (imagesSelected.length >= maxImage) {
        AppSnackBar.showFlushbar(
            context, 'Chỉ được chọn tối đa $maxImage hình');
      } else {
        imagesSelected.add(url);
      }
    }
  }

  /// Facebook chỉ hổ trợ share image and hashtag
  /// 2. Trao quyền kiểm soát cho mọi người
  /// https://developers.facebook.com/policy/#control
  void _onClickShareFacebook() {
    if (AC.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }

    if (isNullOrEmpty(images)) {
      _onShareMessageOnly();
    } else {
      _onShare();
    }
  }

  /// Zalo
  /// Android: share nội dung image và content quảng cáo
  /// 1) Nội dụng lưu trong ClipBoard
  /// 2) Hình ảnh sẽ download về "Bộ sư tập"
  ///
  /// IOS:
  /// 1) Hổ trợ share nội dung 1 image và content quảng cáo
  /// 2) Hổ trợ share tối đa 9 image
  void _onClickShareZalo() {
    if (AC.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }

    if (isNullOrEmpty(images)) {
      _onShareMessageOnly();
      return;
    }

    final int maxForZalo = -1;

    if (maxForZalo > 0 && Platform.isIOS && imagesSelected.length > maxForZalo) {
      showWarningForZalo(maxForZalo);
    } else {
      _onShare(fixZalo: true);
    }
  }

  _onShareMessageOnly() async {
    // Share.text(titleShare, messageShare, 'text/plain');
    Share.share(titleShare, subject: messageShare);
  }

  /// Logic post bài blog có video là
  /// 1) hiển thị lựa cho cùng với hình ảnh.
  /// 2) nếu user chọn video thì sẻ auto download video về photos.
  /// 3) Lấy video mới tải về tự động upload lên nội dung post.
  Future _onShare({bool fixZalo = false}) async {
    if (imagesSelected.isEmpty && videosSelected.isEmpty) {
      AppSnackBar.showFlushbar(context, 'Bạn chưa chọn hình nào',
          duration: const Duration(seconds: 1));
      return;
    }

    final permission = await PermissionController.instance
        .checkAndRequestStorageMedia(context);

    if (!permission) return;

    final List<String> videoFiles = [];
    final List<String> files = [];
    final Map<String, List<int>> mapByte = {};
    final count = imagesSelected.length + videosSelected.length;
    showLoading(context, message: 'Đang tải...');
    // At share in the product, the clipboard is double copy
    await Clipboard.setData(new ClipboardData(text: messageShare));

    for (int i = 0; i < imagesSelected.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      await DefaultCacheManager()
          .getSingleFile(AppImage.getUrl(imagesSelected[i]))
          .then((File file) {
        files.add(file.path);
        mapByte['image_$i.png'] = file.readAsBytesSync();
        if (Platform.isAndroid && fixZalo) {
          GallerySaverHelper.instance
              .saveImageByByte(mapByte['image_$i.png'])
              .catchError((e) => printTrack(e));
        }
        updateLoading('Đã tải ${i + 1}/$count hình');
      }).catchError((e) => printTrack(e));
    }
    for (int i = 0; i < videosSelected.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      await DefaultCacheManager()
          .getSingleFile(videosSelected[i].url)
          .then((File file) {
        videoFiles.add(file.path);
        if (Platform.isAndroid && fixZalo) {
          GallerySaverHelper.instance
              .saveVideoByPath(file.path)
              .catchError((e) => printTrack(e));
        }
      }).catchError((e) => printTrack(e));
      updateLoading('Đã tải ${i + 1 + imagesSelected.length}/$count hình');
    }
    hideLoading(context);

    if (files.isEmpty && videoFiles.isEmpty) {
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return;
    }

    if (Platform.isAndroid) {
      if (fixZalo) {
        _onShareMessageOnly();
      } else {
        // Share.files(titleShare, mapByte, 'image/png', text: messageShare);
        Share.shareFiles(files);
      }
    } else if (Platform.isIOS) {
      if (fixZalo) {
        if (files.length == 1) {
          final imageName = mapByte.keys.first;
          final imageByte = mapByte[imageName];
          // Share.file(titleShare, imageName, imageByte, "image/png", text: messageShare);
          Share.shareFiles([...files, ...videoFiles]);
          // Share.shareFiles(files);
        } else {
          Share.shareFiles([...files, ...videoFiles]);
          // Share.shareFiles(files);
          // ShareExtend.shareMultiple(files, "image");
        }
      } else {
        Share.shareFiles([...files, ...videoFiles]);
        // Share.files(titleShare, mapByte, 'image/png', text: messageShare);
      }
    } else {
      return;
    }
  }

  void showWarningForZalo(maxForZalo) {
    AppPopup.showCustomDialog(
      context,
      content: [
        AvatarGlow(
          endRadius: 50,
          duration: const Duration(milliseconds: 1000),
          glowColor: Colors.blue,
          child: SizedBox(
              height: 50, child: Image.asset('assets/images/ui/zalo-logo.png')),
        ),
        Text(
          'Nếu bạn muốn chia sẽ lên ZALO thì chỉ được chọn tối đa $maxForZalo hình',
          style: Theme.of(context).textTheme.subtitle2,
          textAlign: TextAlign.center,
        ),
        CenterButtonPopup(
          normal: ButtonData('Đóng'),
          highlight: ButtonData(
            'Chọn $maxForZalo hình',
            onPressed: () {
              setState(() {
                imagesSelected.removeRange(maxForZalo, imagesSelected.length);
              });
            },
          ),
        ),
      ],
    );
  }
}
