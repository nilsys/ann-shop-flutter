import 'package:flutter/material.dart';
import '../flutube.dart';
import 'fluture_utility.dart';
import 'models/my_video.dart';

class PreviewVideos extends StatefulWidget {
  PreviewVideos({this.videos, this.showFullButton = true});

  final List<MyVideo> videos;
  final bool showFullButton;

  @override
  _PreviewVideosState createState() => _PreviewVideosState();
}

class _PreviewVideosState extends State<PreviewVideos> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    controller = PageController(initialPage: _currentIndex);
    thumbnailController =
        ScrollController(initialScrollOffset: getOffsetByIndex(_currentIndex));
  }

  int get countVideo {
    return widget.videos?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isFull = size.width > size.height;
    if (countVideo == 0) {
      return SizedBox();
    }
    final double height = isFull
        ? size.height - padding.top - padding.left
        : size.width / kRatioVideo;
    return Column(
      children: [
        Container(
          height: height,
          child: PageView.builder(
            itemCount: countVideo,
            controller: controller,
            onPageChanged: (index) {
              currentIndex = index;
            },
            itemBuilder: (context, index) {
              return _buildVideo(index);
            },
          ),
        ),
        if (isFull == false) _buildImageSelect(),
      ],
    );
  }

  Widget _buildVideo(int index) {
    final MyVideo video = widget.videos[index];
    return MyYoutube(
      video.url,
      showFullButton: widget.showFullButton,
      key: Key("MyChewie-$index-${video.url}"),
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
    return Container(
      height: 48.0 + 24.0,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          controller: thumbnailController,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: countVideo,
          itemBuilder: (context, index) {
            return _videoButton(widget.videos[index], index: index);
          }),
    );
  }

  Widget _videoButton(MyVideo video, {int index}) {
    bool isSelect = currentIndex == index;
    return Container(
      width: 50,
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
        child: Icon(Icons.videocam_outlined),
      ),
    );
  }
}
