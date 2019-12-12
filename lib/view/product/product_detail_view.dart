import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailView extends StatefulWidget {
  ProductDetailView({@required this.info});

  final Product info;

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductDetail product;

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of(context);
    var data = provider.getBySlug(widget.info.slug);
    product = data.data;

    if (data.isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(
          child: UIManager.defaultIndicator(),
        ),
      );
    } else if (data.isCompleted) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
            ),
            IconButton(
              icon: Icon(Icons.home),
            ),
            FavoriteButton(color: Colors.grey,),
            IconButton(
              icon: Icon(Icons.sort),
            )
          ],
        ),
        bottomNavigationBar: _buildButtonControl(),
        body: CustomScrollView(
          slivers: <Widget>[
            /// page view image
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ExtendedImage.network(
                    Core.domain + product.images[indexImage],
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildImageSelect(),
              ]),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildProductColor(),
                  _buildProductSize(),
                ]),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  _buildMaterials(),
                  Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  _buildOtherInfo(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Giá sỉ: ' + Utility.formatPrice(product.regularPrice),
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(color: Colors.red)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Giá lẻ: ' + Utility.formatPrice(product.retailPrice),
                    style: Theme.of(context).textTheme.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildTags(),
                ]),
              ),
            ),

            SliverToBoxAdapter(
                child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(defaultPadding),
              child: Text(
                'Thông tin sản phẩm',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
            )),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  HtmlContent(product.content),
                ]),
              ),
            ),

            /// List image (button download)
//            _buildListImage(),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: SomethingWentWrong(
            onReload: () {
              provider.loadProduct(widget.info.slug);
            },
          ),
        ),
      );
    }
  }

  int indexImage = 0;

  Widget _buildImageSelect() {
    int length = product.images.length;
    return Container(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: length + 2,
        itemBuilder: (context, index) {
          if (index == (length + 1) || index == 0) {
            return SizedBox(
              width: defaultPadding,
            );
          } else {
            return _imageButton(product.images[index - 1], index: index - 1);
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
            child: ExtendedImage.network(
              Core.domain + url,
              fit: BoxFit.cover,
              cache: true,
              loadStateChanged: (ExtendedImageState state) {
                if (state.extendedImageLoadState == LoadState.loading) {
                  return Container();
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListImage() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              child: ExtendedImage.network(
                Core.domain + product.images[index],
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: product.images.length,
        ),
      ),
    );
  }

  Widget _buildMaterials() {
    if (Utility.stringIsNullOrEmpty(product.materials)) {
      return SizedBox(
        height: 5,
      );
    } else {
      return Padding(
        child: Text(product.materials),
        padding: EdgeInsets.only(top: 5),
      );
    }
  }

  Widget _buildTags() {
    if (Utility.isNullOrEmpty(product.tags)) {
      return Container();
    } else {
      List<Widget> children = [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text('TAG: '),
        ),
      ];
      for (var _tag in product.tags) {
        children.add(_buildTag(_tag));
      }

      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Wrap(
          children: children,
        ),
      );
    }
  }

  Widget _buildTag(ProductTag _tag) {
    return InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            _tag.name,
            style: Theme.of(context)
                .textTheme
                .body2
                .merge(TextStyle(color: Colors.blue)),
          ),
        ));
  }

  Widget _buildOtherInfo() {
    List<TextSpan> children = [
      TextSpan(text: 'Trạng thái: '),
      widget.info.availability
          ? TextSpan(text: 'Có sẵn', style: TextStyle(color: Colors.green))
          : TextSpan(text: 'Hết hàng', style: TextStyle(color: Colors.red)),
    ];
    children.addAll([
      TextSpan(text: '\t\t\tDanh mục: '),
      TextSpan(
          text: '${product.categoryName}',
          style: TextStyle(color: Colors.blue)),
    ]);
    children.addAll([
      TextSpan(text: '\t\t\tMã: '),
      TextSpan(text: '${product.sku}', style: TextStyle(color: Colors.grey)),
    ]);

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey),
        children: children,
      ),
    );
  }

  Widget _buildButtonControl() {
    var textTheme =
        Theme.of(context).textTheme.body2.merge(TextStyle(color: Colors.white));
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(widget.info.productID);
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: favorite
                  ? IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        Provider.of<FavoriteProvider>(context)
                            .removeProduct(widget.info.productID);
                      },
                    )
                  : IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        Provider.of<FavoriteProvider>(context)
                            .addNewProduct(widget.info, count: 1);
                      },
                    ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Download',
                    style: textTheme,
                  ),
                  onPressed: () {},
                )),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Copy',
                    style: textTheme,
                  ),
                  onPressed: () {},
                )),
          ],
        ),
      ),
    );
  }

  ProductColor _currentColor;

  Widget _buildProductColor() {
    if (Utility.isNullOrEmpty(product.colors)) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white10,
            Color(0xfff4f4f4),
            Color(0xffeaeaea),
            Color(0xfff4f4f4)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: new Border.all(
          color: Colors.grey,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(text: 'Màu: '),
                TextSpan(
                    text: _currentColor == null
                        ? 'Chưa chọn'
                        : _currentColor.name,
                    style: Theme.of(context).textTheme.body2)
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  ProductSize _currentSize;

  Widget _buildProductSize() {
    if (Utility.isNullOrEmpty(product.sizes)) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white10,
            Color(0xfff4f4f4),
            Color(0xffeaeaea),
            Color(0xfff4f4f4)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: new Border.all(
          color: Colors.grey,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(text: 'Kích cỡ: '),
                TextSpan(
                    text:
                        _currentSize == null ? 'Chưa chọn' : _currentSize.name,
                    style: Theme.of(context).textTheme.body2)
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }
}
