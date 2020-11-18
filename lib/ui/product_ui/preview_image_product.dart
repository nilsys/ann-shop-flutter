import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/src/widgets/common/gesture_zoom_box.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/view/product/product_video.dart';
import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';
import 'package:ping9/ping9.dart';

class PreviewImageProduct extends StatefulWidget {
  PreviewImageProduct(this.carousel,
      {this.initIndex = 0,
      this.controller,
      this.tapExpanded,
      this.videos,
      this.showFullButton = true,
      this.productID});

  final List<ProductCarousel> carousel;
  final int initIndex;
  final PageController controller;
  final VoidCallback tapExpanded;
  final List<MyVideo> videos;
  final bool showFullButton;
  final int productID;

  @override
  _PreviewImageProductState createState() => _PreviewImageProductState();
}

class _PreviewImageProductState extends State<PreviewImageProduct> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initIndex < 0 ? 0 : widget.initIndex;
    controller =
        widget.controller ?? new PageController(initialPage: _currentIndex);
    thumbnailController =
        ScrollController(initialScrollOffset: getOffsetByIndex(_currentIndex));
  }

  int get countVideo {
    return widget.videos?.length ?? 0;
  }

  int get maxCountPage {
    return (widget.carousel?.length ?? 0) + countVideo;
  }

  int indexImagePageAt(int index) {
    return index - countVideo;
  }

  @override
  Widget build(BuildContext context) {
    final isFull = isFullScreen(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              PageView.builder(
                itemCount: maxCountPage,
                controller: controller,
                onPageChanged: (index) {
                  currentIndex = index;
                },
                itemBuilder: (context, index) {
                  if (index < countVideo) {
                    return _buildVideo(index);
                  }
                  return InkWell(
                    onTap:
                        currentIndex < countVideo ? null : widget.tapExpanded,
                    child: Container(
                      alignment: Alignment.center,
                      child: GestureZoomBox(
                        child: AppImage(
                          AppImage.imageDomain +
                              (widget.tapExpanded != null
                                  ? widget.carousel[index - countVideo].feature
                                  : widget.carousel[index - countVideo].origin),
                          fit: BoxFit.contain,
                        ),
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
                        if (isFull) {
                          OrientationUtility.setPortrait();
                        } else {
                          Navigator.pop(context, currentIndex);
                        }
                      }),
                    )
                  : Positioned(
                      right: 10,
                      top: 15,
                      child: IconButton(
                        icon: Icon(
                          Icons.zoom_out_map,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: widget.tapExpanded,
                      ),
                    ),
              if (currentIndex < countVideo)
                if (widget.productID != null)
                  ButtonDownLoadVideo(
                    widget.videos[currentIndex].url,
                    productID: widget.productID,
                  )
                else
                  SizedBox()
              else
                ButtonDownload(
                  imageName: widget.carousel[currentIndex - countVideo].origin,
                ),
            ],
          ),
        ),
        if (isFull == false) ...[
          SizedBox(height: 10),
          _buildImageSelect(),
          SizedBox(height: MediaQuery.of(context).padding.bottom,)
        ],
      ],
    );
  }

  Widget _buildVideo(int index) {
    final MyVideo video = widget.videos[index];
    return ProductVideo(
      video,
      index,
      key: Key("ProductVideo-$index-${video.url}"),
      showFullButton: widget.showFullButton,
    );
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int indexImage) {
    thumbnailController.animateTo(getOffsetByIndex(indexImage),
        duration: Duration(milliseconds: 500), curve: Curves.linear);
    setState(() {
      _currentIndex = indexImage;
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

  Widget _buildImageSelect() {
    List<ProductCarousel> images = widget.carousel;
    List<MyVideo> videos = widget.videos;

    return Container(
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 5),
        controller: thumbnailController,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: maxCountPage,
        itemBuilder: (context, index) {
          if (index < countVideo) {
            return _videoButton(videos[index], index: index);
          } else {
            return _imageButton(images[index - countVideo].thumbnail,
                index: index);
          }
        },
      ),
    );
  }

  Widget _imageButton(String url, {int index}) {
    bool isSelect = currentIndex == index;
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
          controller.animateToPage(index,
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

  Widget _videoButton(MyVideo video, {int index}) {
    bool isSelect = currentIndex == index;
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
          controller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Icon(MaterialCommunityIcons.video),
      ),
    );
  }
}
