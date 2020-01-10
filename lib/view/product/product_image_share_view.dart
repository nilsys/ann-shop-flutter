import 'dart:math';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_extend/share_extend.dart';

class ProductImageShareView extends StatefulWidget {
  ProductImageShareView(this.data);

  final List<String> data;

  @override
  _ProductImageShareViewState createState() =>
      _ProductImageShareViewState(data);
}

class _ProductImageShareViewState extends State<ProductImageShareView> {
  _ProductImageShareViewState(this.images);

  final List<String> images;
  var maxImage = 6;
  List<String> imagesSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagesSelected = new List();
    for (int i = 0; i < images.length && i < 6; i++) {
      imagesSelected.add(images[i]);
    }
    maxImage = min(6, images.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn hình ảnh'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: GridView.builder(
            itemCount: images.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return _buildImageSelect(images[index]);
            }),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Đã chọn ${imagesSelected.length}/6 hình',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _onShare();
                },
              )
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
              AppSnackBar.showFlushbar(context, 'Chỉ được chọn tối đa 6 hình');
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
            showLoading: false,
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

  _onShare() async {
    try {
      var images = imagesSelected;
      if (Utility.isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Bạn chưa chọn hình nào',
            duration: Duration(seconds: 1));
        return;
      }
      showLoading(context, message: 'Download...');
      List<String> files = [];
      for (int i = 0; i < images.length; i++) {
        try {
          var file = await DefaultCacheManager()
              .getSingleFile(Core.domain + images[i])
              .timeout(Duration(seconds: 5));
          files.add(file.path);
          updateLoading('Download ${i + 1}/${images.length} images');
        } catch (e) {
          // fail 1
        }
      }
      hideLoading(context);
      if (Utility.isNullOrEmpty(files) == false) {
        ShareExtend.shareMultiple(files, "image");
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
