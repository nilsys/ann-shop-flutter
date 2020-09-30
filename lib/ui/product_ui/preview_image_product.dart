import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_download.dart';
import 'package:ann_shop_flutter/src/widgets/common/gesture_zoom_box.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';
import 'package:ping9/ping9.dart';

class PreviewImageProduct extends StatefulWidget {
  PreviewImageProduct(this.carousel,
      {this.initIndex = 0, this.controller, this.tapExpanded, this.videoUrl});

  final List<ProductCarousel> carousel;
  final int initIndex;
  final PageController controller;
  final VoidCallback tapExpanded;
  final String videoUrl;

  @override
  _PreviewImageProductState createState() => _PreviewImageProductState();
}

class _PreviewImageProductState extends State<PreviewImageProduct> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    _indexImage = isNullOrEmpty(widget.videoUrl)
        ? widget.initIndex
        : widget.initIndex - 1;
    printTrack(_indexImage);
    controller = widget.controller ??
        new PageController(initialPage: indexPageAt(_indexImage));
    thumbnailController = ScrollController(
        initialScrollOffset: getOffsetByIndex(indexPageAt(_indexImage)));
  }

  int get maxCountPage {
    if (isNullOrEmpty(widget.videoUrl) == false) {
      return widget.carousel.length + 1;
    }
    return widget.carousel.length;
  }

  int indexPageAt(int index) {
    if (isNullOrEmpty(widget.videoUrl) == false) {
      return index + 1;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: widget.tapExpanded,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                PageView.builder(
                  itemCount: maxCountPage,
                  controller: controller,
                  onPageChanged: (index) {
                    if (isNullOrEmpty(widget.videoUrl) == false) {
                      indexImage = index - 1;
                    } else {
                      indexImage = index;
                    }
                  },
                  itemBuilder: (context, fakeIndex) {
                    int index = isNullOrEmpty(widget.videoUrl)
                        ? fakeIndex
                        : fakeIndex - 1;
                    if (index == -1) {
                      return _buildVideo();
                    }
                    return Container(
                      alignment: Alignment.center,
                      child: GestureZoomBox(
                        child: AppImage(
                          AppImage.imageDomain +
                              (widget.tapExpanded != null
                                  ? widget.carousel[index].feature
                                  : widget.carousel[index].origin),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                widget.tapExpanded == null
                    ? Positioned(
                        right: 15,
                        top: 15,
                        child: ButtonClose(onPressed: () {
                          Navigator.pop(context, indexImage);
                        }),
                      )
                    : Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.zoom_out_map,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                if (indexImage < 0)
                  ButtonDownLoadVideo(widget.videoUrl)
                else
                  ButtonDownload(
                    imageName: widget.carousel[indexImage].origin,
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildImageSelect(widget.carousel)
      ],
    );
  }

  Widget _buildVideo() {
    return MyChewie(widget.videoUrl);
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

  double getOffsetByIndex(indexImage) {
    double _offset = 0;
    if (indexImage >= 4) {
      _offset = (indexImage - 3) * 75.0;
    }
    return _offset;
  }

  ScrollController thumbnailController;

  Widget _buildImageSelect(List<ProductCarousel> images) {
    return Container(
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 5),
        controller: thumbnailController,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: maxCountPage,
        itemBuilder: (context, fakeIndex) {
          int index =
              isNullOrEmpty(widget.videoUrl) ? fakeIndex : fakeIndex - 1;
          if (index == -1) {
            return _videoButton();
          }
          return _imageButton(images[index].thumbnail, index: index);
        },
      ),
    );
  }

  Widget _imageButton(String url, {index = 0}) {
    bool isSelect = indexImage == index;
    return Container(
      width: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isSelect
            ? new Border.all(
                color: Theme.of(context).primaryColor,
                width: 1.5,
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
          controller.animateToPage(indexPageAt(index),
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Opacity(
          opacity: isSelect ? 1 : 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AppImage(
              AppImage.imageDomain + url,
              showLoading: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoButton() {
    bool isSelect = indexImage == -1;
    return Container(
      width: 55,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: isSelect
            ? new Border.all(
                color: Theme.of(context).primaryColor,
                width: 1.5,
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
          controller.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Icon(MaterialCommunityIcons.video),
      ),
    );
  }
}
