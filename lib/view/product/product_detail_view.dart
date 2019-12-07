import 'package:ann_shop_flutter/core/config.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/model/product_detail.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ProductDetailView extends StatefulWidget {
  ProductDetailView({@required this.product});

  final Product product;

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductDetail productDetail;

  @override
  void initState() {
    super.initState();
    _loadDetailVoucher();
  }

  _loadDetailVoucher() async {
    productDetail =
        await ProductRepository.instance.loadProductDetail(widget.product.slug);
    print(productDetail.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var cover = domain + widget.product.getCover;
    if (productDetail != null) {
      cover = productDetail.images[indexImage];
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          /// page view image
          SliverList(
            delegate: SliverChildListDelegate([
              ExtendedImage.network(
                domain + cover,
                fit: BoxFit.cover,
                cache: true,
              ),
              SizedBox(
                height: 10,
              ),
              _buildImageSelect(),
            ]),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  widget.product.name,
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
                  'Giá sỉ: ' + Utility.formatPrice(widget.product.regularPrice),
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
                  'Giá lẻ: ' + Utility.formatPrice(widget.product.retailPrice),
                  style: Theme.of(context).textTheme.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildButtonControl(),
              ]),
            ),
          ),

          SliverToBoxAdapter(
              child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(15),
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
                HtmlContent(widget.product.content),
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
                      domain +
                          productDetail.images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
                childCount:
                    productDetail == null ? 0 : productDetail.images.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int indexImage = 0;

  Widget _buildImageSelect() {
    if (productDetail == null || Utility.isNullOrEmpty(productDetail.images)) {
      return Row(children: [_imageButton(widget.product.getCover)]);
    } else {
      return Container(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productDetail.images.length + 1,
          itemBuilder: (context, index) {
            if (index == productDetail.images.length) {
              return SizedBox(
                width: 5,
              );
            } else {
              return _imageButton(productDetail.images[index], index: index);
            }
          },
        ),
      );
    }
  }

  Widget _imageButton(String url, {index = 0}) {
    return Container(
      width: 75,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: new Border.all(
          color: indexImage == index
              ? Theme.of(context).primaryColor
              : Colors.grey,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5),
      child: InkWell(
        onTap: () {
          setState(() {
            indexImage = index;
          });
        },
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
    if (productDetail == null ||
        Utility.stringIsNullOrEmpty(productDetail.materials)) {
      return SizedBox(
        height: 5,
      );
    } else {
      return Padding(
        child: Text(productDetail.materials),
        padding: EdgeInsets.only(top: 5),
      );
    }
  }

  Widget _buildOtherInfo() {
    List<TextSpan> children = [
      TextSpan(text: 'Trạng thái: '),
      widget.product.availability
          ? TextSpan(text: 'Có sẵn', style: TextStyle(color: Colors.green))
          : TextSpan(text: 'Hết hàng', style: TextStyle(color: Colors.red)),
    ];
    if (productDetail != null) {
      children.addAll([
        TextSpan(text: '\t\t\tDanh mục: '),
        TextSpan(
            text: '${productDetail.categoryName}',
            style: TextStyle(color: Colors.blue)),
      ]);
    }
    children.addAll([
      TextSpan(text: '\t\t\tMã: '),
      TextSpan(
          text: '${widget.product.sku}', style: TextStyle(color: Colors.grey)),
    ]);

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey),
        children: children,
      ),
    );
  }

  Widget _buildButtonControl() {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.orange,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.content_copy,
                  size: 20,
                ),
                Text(
                  'Copy',
                  style: Theme.of(context).textTheme.button,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.orange,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.file_download,
                  size: 20,
                ),
                Text(
                  'Download',
                  style: Theme.of(context).textTheme.button,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.orange,
            child: Icon(
              Icons.favorite,
              size: 20,
            ),
          ),
        )
      ],
    );
  }
}
