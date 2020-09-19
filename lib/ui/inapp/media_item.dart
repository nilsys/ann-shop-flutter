import 'package:ann_shop_flutter/core/app_action.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/utility/cover.dart';

import 'package:flutter/material.dart';

class MediaItem extends StatelessWidget {
  MediaItem(this.item);

  final Cover item;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        color: AppStyles.cardColor,
        child: InkWell(
          onTap: () {
            AppAction.instance.onHandleAction(
                context, item.action, item.actionValue, item.name);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: RichText(
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(
                        text: item.message + '...',
                        style: Theme.of(context).textTheme.body1),
                    TextSpan(
                      text: 'xem thêm >',
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(color: Colors.blue),
                          ),
                    )
                  ]),
                ),
              ),
              if (isNullOrEmpty(item.images) == false)
                _buildImages(context, item.images),
            ],
          ),
        ),
      ),
    );
  }

  final double heightImage = 300;

  Widget _buildImages(BuildContext context, List<String> images) {
    // todo: mock data, remove later
    Widget child;
    switch (images.length) {
      case 1:
        child = _buildImage1(images);
        break;
      case 2:
        child = _buildImage2(images);
        break;
      case 3:
        child = _buildImage3(images);
        break;
      case 4:
        child = _buildImage4(images);
        break;
      case 5:
        child = _buildImage5(images);
        break;
      default:
        child = _buildImage6(images);
        break;
    }
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: heightImage,
      child: child,
    );
  }

  Widget _image(String image) {
    return AppImage(
      image,
      fit: BoxFit.cover,
    );
  }

  Widget dividerHorizontal() {
    return Container(height: 3, color: Colors.white);
  }

  Widget dividerVertical() {
    return Container(width: 3, color: Colors.white);
  }

  Widget _buildImage1(List<String> images) {
    return _image(images[0]);
  }

  Widget _buildImage2(List<String> images) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _image(images[0]),
        ),
        dividerVertical(),
        Expanded(
          child: _image(images[1]),
        )
      ],
    );
  }

  Widget _buildImage3(List<String> images) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: _image(images[0]),
        ),
        dividerVertical(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _image(images[1]),
              ),
              dividerHorizontal(),
              Expanded(
                child: _image(images[2]),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImage4(List<String> images) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: _image(images[0]),
        ),
        dividerVertical(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _image(images[1]),
              ),
              dividerHorizontal(),
              Expanded(
                child: _image(images[2]),
              ),
              dividerHorizontal(),
              Expanded(
                child: _image(images[3]),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImage5(List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: _image(images[0]),
              ),
              dividerVertical(),
              Expanded(
                child: _image(images[1]),
              ),
            ],
          ),
        ),
        dividerHorizontal(),
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _image(images[2]),
              ),
              dividerVertical(),
              Expanded(
                child: _image(images[3]),
              ),
              dividerVertical(),
              Expanded(
                child: _image(images[4]),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImage6(List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: _image(images[0]),
              ),
              dividerVertical(),
              Expanded(
                child: _image(images[1]),
              ),
            ],
          ),
        ),
        dividerHorizontal(),
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _image(images[2]),
              ),
              dividerVertical(),
              Expanded(
                child: _image(images[3]),
              ),
              dividerVertical(),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _image(images[4]),
                    Container(
                      color: Colors.black.withAlpha(100),
                      alignment: Alignment.center,
                      child: Text(
                        "+${images.length - 5}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 28),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
