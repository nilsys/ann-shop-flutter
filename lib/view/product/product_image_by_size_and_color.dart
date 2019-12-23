import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:flutter/material.dart';

class ProductImageBySizeAndColor extends StatefulWidget {
  ProductImageBySizeAndColor(this.data);

  final Map data;

  @override
  _ProductImageBySizeAndColorState createState() =>
      _ProductImageBySizeAndColorState();
}

class _ProductImageBySizeAndColorState
    extends State<ProductImageBySizeAndColor> {
  int indexImage = 0;
  List<String> images;
  ProductDetail detail;
  PageController controller;
  int currentSize;
  int currentColor;

  bool isLoading;

  loadingAPI() async {
    print('($currentColor, $currentSize)');
    if (currentSize > 0 || currentColor > 0) {
      setState(() {
        isLoading = true;
      });
      String image = await ProductRepository.instance
          .loadProductImageSize(detail.productID, currentColor, currentSize);
      setState(() {
        isLoading = false;
        if (Utility.isNullOrEmpty(image) == false) {
          int index = images.indexOf(image);
          print('indexOf: $index');
          if (index >= 0) {
            animationToPage(index);
          }
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  animationToPage(index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexImage = widget.data['index'];
    detail = widget.data['data'];
    images = detail.images;
    currentSize = 0;
    currentColor = 0;
    controller = new PageController(initialPage: indexImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildPage(),
            Positioned(
              right: 15,
              top: 15,
              child: UIManager.btnClose(onPressed: () {
                Navigator.pop(context, indexImage);
              }),
            ),
          ],
        ),
      ),
    );
  }

  _buildPage() {
    return ListView(
      children: <Widget>[
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2,
          child: PageView.builder(
              itemCount: images.length,
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  indexImage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: images[0] + index.toString() + detail.sku,
                    child: AppImage(
                      Core.domain + images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }),
        ),
        _buildImageSelect(images),
        _buildSizesSelect(),
        _buildColorsSelect(),
      ],
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
          color: Theme
              .of(context)
              .primaryColor,
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
          animationToPage(index);
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

  Widget _buildColorsSelect() {
    if (Utility.isNullOrEmpty(detail.colors)) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle('Chọn màu:'),
            Wrap(
              children:
              detail.colors.map((item) => _buildChipColor(item)).toList(),
            )
          ],
        ),
      );
    }
  }

  Widget _buildSizesSelect() {
    if (Utility.isNullOrEmpty(detail.sizes)) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle('Chọn size:'),
            Wrap(
              children:
              detail.sizes.map((item) => _buildChipSize(item)).toList(),
            )
          ],
        ),
      );
    }
  }

  Widget _buildTitle(name) {
    return Text(
      name,
      style: Theme
          .of(context)
          .textTheme
          .subtitle,
    );
  }

  Widget _buildChipSize(ProductSize item) {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: ChoiceChip(
          label: Text(item.name),
          selected: item.id == currentSize,
          onSelected: (value) {
            currentSize = value ? item.id : 0;
            loadingAPI();
          },
        ));
  }

  Widget _buildChipColor(ProductColor item) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: ChoiceChip(
        label: Text(item.name),
        selected: item.id == currentColor,
        onSelected: (value) {
          currentColor = value ? item.id : 0;
          loadingAPI();
        },
      ),
    );
  }
}
