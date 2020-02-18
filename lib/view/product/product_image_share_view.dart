import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/account/account_controller.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/ask_login.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:ann_shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:share_extend/share_extend.dart';

class ProductImageShareView extends StatefulWidget {
  const ProductImageShareView(this.data);

  final Map data;

  @override
  _ProductImageShareViewState createState() => _ProductImageShareViewState(
      data['images'], data['message'], data['title']);
}

class _ProductImageShareViewState extends State<ProductImageShareView> {
  _ProductImageShareViewState(this.images, this.message, this.title);

  final int limit = 30;
  final List<String> images;
  final String message;
  final String title;
  int maxImage = 30;
  List<String> imagesSelected;

  @override
  void initState() {
    super.initState();
    imagesSelected = [];
    maxImage = min(limit, images.length);
    for (int i = 0; i < images.length && i < maxImage; i++) {
      imagesSelected.add(images[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = Utility.isNullOrEmpty(imagesSelected);
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              if (MediaQuery.of(context).viewInsets.bottom > 100) {
                Navigator.pop(context);
                showDialog(context: context, child: FixViewInsetsBottom());
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Đã chọn ${imagesSelected.length}/$maxImage hình',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Bỏ chọn',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  imagesSelected = [];
                });
              },
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
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
                        onPressed: _onShareFacebook,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(context).dividerColor,
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
                            child:
                                Image.asset('assets/images/ui/zalo-logo.png'),
                          )
                        ],
                      ),
                      onPressed: _onShareZalo,
                    ),
                  ),
                ],
              ),
            )),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildImageSelect(images[index]);
                    },
                    childCount: images.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelect(String url) {
    final isSelect = imagesSelected.contains(url);
    final imageWidget = InkWell(
      onTap: () {
        setState(() {
          if (isSelect) {
            imagesSelected.remove(url);
          } else {
            if (imagesSelected.length >= maxImage) {
              AppSnackBar.showFlushbar(
                  context, 'Chỉ được chọn tối đa $maxImage hình');
            } else {
              imagesSelected.add(url);
            }
          }
        });
      },
      child: Opacity(
        opacity: isSelect ? 1 : 0.7,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AppImage(
            Core.domain + url,
          ),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: isSelect
          ? Stack(
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
            )
          : imageWidget,
    );
  }

  void _onShareFacebook() {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }
    if (Platform.isAndroid) {
      _onShare(message: message, fixZalo: true);
    } else {
      _onShare(message: message);
    }
  }

  final maxForZalo = Platform.isAndroid ? 1 : 9;

  void _onShareZalo() {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }
    if (imagesSelected.length > maxForZalo) {
      AppPopup.showCustomDialog(
        context,
        content: [
          AvatarGlow(
            endRadius: 50,
            duration: const Duration(milliseconds: 1000),
            glowColor: Colors.blue,
            child: SizedBox(
                height: 50,
                child: Image.asset('assets/images/ui/zalo-logo.png')),
          ),
          Text(
            'Nếu bạn muốn chia sẽ lên ZALO thì chỉ được chọn tối đa $maxForZalo hình',
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.center,
          ),
          CenterButtonPopup(
              normal: ButtonData(
                'Đóng',
              ),
              highlight: ButtonData(
                'Chọn $maxForZalo hình',
                onPressed: () {
                  setState(() {
                    imagesSelected.removeRange(
                        maxForZalo, imagesSelected.length);
                  });
                },
              ))
        ],
      );
    } else {
      if (Platform.isAndroid) {
        _onShare(message: message, fixZalo: true);
      } else {
        if (imagesSelected.length == 1) {
          _onShare(message: message);
        } else {
          _onShare(fixZalo: true);
        }
      }
    }
  }

  Future _onShare({message, fixZalo = false}) async {
    try {
      final images = imagesSelected;
      if (Utility.isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Bạn chưa chọn hình nào',
            duration: const Duration(seconds: 1));
        return;
      }
      showLoading(context, message: 'Đang tải...');
      final List<String> files = [];
      final Map<String, List<int>> mapByte = {};
      for (int i = 0; i < images.length; i++) {
        try {
          final file = await DefaultCacheManager()
              .getSingleFile(Core.domain + images[i])
              .timeout(const Duration(seconds: 5));
          files.add(file.path);
          final Uint8List bytes = file.readAsBytesSync();
          mapByte['image_$i.png'] = bytes;
          debugPrint(file.path);
          updateLoading('Đang tải ${i + 1}/${images.length} hình');
        } catch (e) {
          debugPrint(e);
        }
      }
      hideLoading(context);
      if (Utility.isNullOrEmpty(files) == false) {
        if (fixZalo) {
          await ShareExtend.shareMultiple(files, "image");
        } else {
          await Share.files(title, mapByte, '*/*', text: message);
        }
      } else {
        throw ArgumentError('Data empty');
      }
    } catch (e) {
      debugPrint(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return;
    }
  }
}
