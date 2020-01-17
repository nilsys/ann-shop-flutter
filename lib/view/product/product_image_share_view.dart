import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ProductImageShareView extends StatefulWidget {
  ProductImageShareView(this.data);

  final Map data;

  @override
  _ProductImageShareViewState createState() => _ProductImageShareViewState(
      data['images'], data['message'], data['title']);
}

class _ProductImageShareViewState extends State<ProductImageShareView> {
  _ProductImageShareViewState(this.images, this.message, this.title);

  final limit = 30;
  final List<String> images;
  final String message;
  final String title;
  var maxImage = 30;
  List<String> imagesSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagesSelected = new List();
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
        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text('Đăng Facebook', style: Theme.of(context).textTheme.button.merge(TextStyle(color: Colors.white)),),
                      onPressed: _onShareFacebook,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text('Đăng Zalo', style: Theme.of(context).textTheme.button.merge(TextStyle(color: Colors.white))),
                      onPressed: _onShareZalo,
                    ),
                  ),
                ],
              ),
            )),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        height: 60,
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
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
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                        onPressed: () {
                          if (MediaQuery.of(context).viewInsets.bottom > 100) {
                            Navigator.pop(context);
                            showDialog(
                                context: context, child: FixViewInsetsBottom());
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Đã chọn ${imagesSelected.length}/$maxImage hình',
                            style: Theme.of(context).textTheme.title,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Bỏ chọn',
                          style: Theme.of(context).textTheme.button.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        onPressed: (){
                          setState(() {
                            imagesSelected = [];
                          });
                        },
                      )
                    ],
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
    bool isSelect = imagesSelected.contains(url);
    var imageWidget = InkWell(
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
      margin: EdgeInsets.only(top: 5),
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
                        border: new Border.all(
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

  _onShareFacebook(){
    _onShare(message: message);
  }
  _onShareZalo() {
    final maxForZalo = 9;
    if (imagesSelected.length > maxForZalo) {
      AppPopup.showImageDialog(context,
          image: Icon(
            Icons.share,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          title:
              'Nếu bạn muốn chia sẽ lên ZALO thì chỉ được chọn tối đa $maxForZalo hình',
          btnHighlight: ButtonData(
              title: 'Chọn $maxForZalo hình',
              callback: () {
                setState(() {
                  imagesSelected.removeRange(8, (imagesSelected.length - 1));
                });
              }),
          btnNormal: ButtonData(title: 'Đóng', callback: null));
    } else {
      if(imagesSelected.length == 1){
        _onShare(message: message);
      }else{
        _onShare();
      }
    }
  }

  _onShare({message}) async {
    try {
      var images = imagesSelected;
      if (Utility.isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Bạn chưa chọn hình nào',
            duration: Duration(seconds: 1));
        return;
      }
      showLoading(context, message: 'Download...');
      List<String> files = [];
      Map<String, List<int>> mapByte = {};
      for (int i = 0; i < images.length; i++) {
        try {
          var file = await DefaultCacheManager()
              .getSingleFile(Core.domain + images[i])
              .timeout(Duration(seconds: 5));
          files.add(file.path);
          Uint8List bytes = file.readAsBytesSync();
          mapByte['image_$i.png'] = bytes;
          print(file.path);
          updateLoading('Download ${i + 1}/${images.length} images');
        } catch (e) {
          // fail 1
        }
      }
      hideLoading(context);
      if (Utility.isNullOrEmpty(files) == false) {
//        ShareExtend.shareMultiple(files, "image");
        Share.files(title, mapByte, '*/*', text: message);
      } else {
        throw ('Data empty');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: Duration(seconds: 1));
      return;
    }
  }
}
