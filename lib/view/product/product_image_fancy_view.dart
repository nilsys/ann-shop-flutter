import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:flutter/material.dart';

class ProductImageFancyView extends StatefulWidget {
  ProductImageFancyView(this.data);

  final Map data;

  @override
  _ProductImageFancyViewState createState() => _ProductImageFancyViewState();
}

class _ProductImageFancyViewState extends State<ProductImageFancyView> {
  int indexImage = 0;
  List<String> images;
  ProductDetail detail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexImage = widget.data['index'];
    detail = widget.data['data'];
    images = detail.images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Hero(
                tag: images[0] + detail.productID.toString(),
                child: AppImage(
                  Core.domain + images[indexImage],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 15,
              child: UIManager.btnClose(onPressed: () {
                Navigator.pop(context, [indexImage]);
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: _buildImageSelect(images),
      ),
    );
  }

  Widget _buildImageSelect(images) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 2,
        itemBuilder: (context, index) {
          if (index == (images.length + 1) || index == 0) {
            return SizedBox(
              width: defaultPadding,
            );
          } else {
            return _imageButton(images[index - 1], index: index - 1);
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
                width: 2,
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
          setState(() {
            indexImage = index;
          });
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
