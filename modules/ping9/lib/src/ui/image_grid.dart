
import 'package:flutter/material.dart';

import '../../ping9.dart';

class ImageGrid extends StatelessWidget {

  const ImageGrid(this.images);

  final List<String> images;
  final double heightImage = 300;

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (images.length) {
      case 1:
        return Container(
          child: AppImage(images[0]),
        );
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
