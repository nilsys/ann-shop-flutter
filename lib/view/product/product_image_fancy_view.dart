import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

class ProductImageFancyView extends StatefulWidget {
  ProductImageFancyView(this.data);

  final Map data;

  @override
  _ProductImageFancyViewState createState() => _ProductImageFancyViewState();
}

class _ProductImageFancyViewState extends State<ProductImageFancyView> {
  List<ProductCarousel> carousel;
  ProductDetail detail;
  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexImage = widget.data['index'];
    detail = widget.data['data'];
    carousel = detail.carousel;
    controller = new PageController(initialPage: indexImage);
    thumbnailController =  ScrollController(initialScrollOffset: getOffsetByIndex(_indexImage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
                itemCount: carousel.length,
                controller: controller,
                onPageChanged: (index) {
                  indexImage = index;
                },
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: GestureZoomBox(
                      child: AppImage(
                        Core.domain + carousel[index].origin,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }),
            Positioned(
              right: 15,
              top: 15,
              child: UIManager.btnClose(onPressed: () {
                Navigator.pop(context, indexImage);
              }),
            ),
            ButtonDownload(
              imageName: carousel[indexImage].origin,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: _buildImageSelect(carousel),
      ),
    );
  }

  int _indexImage = 0;

  int get indexImage => _indexImage;

  set indexImage(int indexImage) {
    thumbnailController.animateTo(getOffsetByIndex(indexImage),
        duration: Duration(milliseconds: 500), curve: Curves.linear);
    setState(() {
      _indexImage = indexImage;
    });
  }
  double getOffsetByIndex(indexImage){
    double _offset = 0;
    if (indexImage >= 4) {
      _offset = (indexImage - 3) * 75.0;
    }
    return _offset;
  }

  ScrollController thumbnailController;

  Widget _buildImageSelect(List<ProductCarousel> images) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        controller: thumbnailController,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 2,
        itemBuilder: (context, index) {
          if (index == (images.length + 1) || index == 0) {
            return SizedBox(
              width: defaultPadding,
            );
          } else {
            return _imageButton(images[index - 1].thumbnail, index: index - 1);
          }
        },
      ),
    );
  }

  Widget _imageButton(String url, {index = 0}) {
    bool isSelect = indexImage == index;
    return Container(
      width: 60,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isSelect
            ? new Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
                style: BorderStyle.solid,
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          controller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Opacity(
          opacity: isSelect ? 1 : 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AppImage(
              Core.domain + url,
              showLoading: false,
            ),
          ),
        ),
      ),
    );
  }
}
