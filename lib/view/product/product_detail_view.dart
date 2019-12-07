import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/model/product_detail.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/ui/utility/button_favorite.dart';
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
//    var data = provider.getBySlug(widget.info.slug);
    var data = provider.getBySlug('ao-khoac-nu-dinh-da-vo-sac-size-60-70kg');
    product = data.data;

    if (data.isLoading) {
      return Scaffold(
        appBar: AppBar(
//          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: UIManager.defaultIndicator(),
        ),
      );
    } else if (data.isCompleted) {
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
            ),
            IconButton(
              icon: Icon(Icons.home),
            ),
            ButtonFavorite(),
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2,
                  child: ExtendedImage.network(
                    domain + product.images[indexImage],
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
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    product.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
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
                    style: Theme
                        .of(context)
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
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
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: ExtendedImage.network(
                        domain + product.images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  childCount: product.images.length,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
          color: Theme
              .of(context)
              .primaryColor,
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
              domain + url,
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

  Widget buildIconButton(icon, {onPressed}) {
    return Container(
      color: Colors.orange,
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
        ),
        onPressed: () {},
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
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(flex: 1,child: RaisedButton(color:Theme.of(context).primaryColor,child: Text('Add to cart'),onPressed: (){},)),
            SizedBox(width: 5,),
            Expanded(flex: 1,child: RaisedButton(color:Theme.of(context).primaryColor,child: Text('Download'),onPressed: (){},)),
            SizedBox(width: 5,),
            Expanded(flex: 1,child: RaisedButton(color:Theme.of(context).primaryColor,child: Text('Copy'),onPressed: (){},)),
          ],
        ),
      ),
    );
  }
}
