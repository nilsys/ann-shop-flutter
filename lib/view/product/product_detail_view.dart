import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/product/option_menu_product.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class ProductDetailView extends StatefulWidget {
  ProductDetailView({@required this.info});

  final Product info;

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  bool isFull;
  ScrollController controller;

  double oldOffset = 0;
  final double pointCheck = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFull = false;
    controller = new ScrollController();
    controller.addListener(() {
      if (controller.hasClients && isFull) {
        var offset = controller.offset;
        if ((offset >= pointCheck && oldOffset < pointCheck) ||
            (oldOffset >= pointCheck && offset < pointCheck)) {
          setState(() {
            oldOffset = offset;
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      Provider.of<SeenProvider>(context).addNewProduct(widget.info);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of(context);
    var data = provider.getBySlug(widget.info.slug);

    List images = data.isCompleted ? data.data.images : [widget.info.getCover];

    return Scaffold(
      floatingActionButton: _buildFloatButton(),
      bottomNavigationBar: _buildButtonControl(data.data),
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          /// app bar
          SliverAppBar(
            floating: true,
            pinned: false,
            iconTheme: IconThemeData(color: AppStyles.dartIcon),
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: AppStyles.dartIcon),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              IconButton(
                  icon: Icon(Icons.home, color: AppStyles.dartIcon),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }),
              FavoriteButton(
                color: AppStyles.dartIcon,
              ),
              OptionMenuProduct(
                onCopy: () {
                  Clipboard.setData(
                      new ClipboardData(text: widget.info.getTextCopy()));
                  AppSnackBar.showFlushbar(context, 'Copy',
                      duration: Duration(seconds: 1));
                },
                onDownload: () {
                  if (data.isCompleted) {
                    _onAksBeforeDownload(data.data);
                  }
                },
                onShare: () {
                  if (data.isCompleted) {
                    _onShare(data.data);
                  }
                },
              ),
            ],
          ),

          /// page view image
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: InkWell(
                  onTap: () {
                    if (data.isCompleted) {
                      Navigator.pushNamed(context, '/product-fancy-image',
                          arguments: {
                            'index': indexImage,
                            'data': data.data
                          }).then((value) {
                        List param = value;
                        setState(() {
                          indexImage = param[0];
                        });
                      });
                    }
                  },
                  child: Hero(
                    tag: images[0] + widget.info.productID.toString(),
                    child: AppImage(
                      Core.domain + images[indexImage],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildImageSelect(images),
            ]),
          ),
          data.isCompleted
              ? SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildProductColor(data.data),
                      _buildProductSize(data.data),
                    ]),
                  ),
                )
              : SliverToBoxAdapter(),
          SliverPadding(
            padding:
                EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 15),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Hero(
                  tag: widget.info.name + widget.info.productID.toString(),
                  child: Text(
                    widget.info.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                _buildMaterials(),
                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 10),
                ),
                _buildOtherInfo(data.data),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Giá sỉ: ' + Utility.formatPrice(widget.info.regularPrice),
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
                  'Giá lẻ: ' + Utility.formatPrice(widget.info.retailPrice),
                  style: Theme.of(context).textTheme.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                _buildTags(data.data),
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
                HtmlContent(widget.info.getContent()),
              ]),
            ),
          ),

          /// List image
          _buildFillRemaining(data),
          isFull && data.isCompleted
              ? _buildListImage(data.data.contentImages)
              : SliverToBoxAdapter(),
        ],
      ),
    );
  }

  _buildFillRemaining(data) {
    if (data.isCompleted) {
      return isFull
          ? _buildListImage(data.data.images)
          : _buildViewMore(data.data);
    } else if (data.isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Indicator(),
        ),
      );
    } else {
      return SliverFillRemaining(
        child: Center(
          child: SomethingWentWrong(
            onReload: () {
              Provider.of<ProductProvider>(context)
                  .loadProduct(widget.info.slug);
            },
          ),
        ),
      );
    }
  }

  _buildFloatButton() {
    if (controller.hasClients == false ||
        controller.offset < pointCheck ||
        isFull == false) {
      return null;
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () {
              controller.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(
              Icons.unfold_less,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFull = false;
              });
            },
          ),
        ],
      );
    }
  }

  int indexImage = 0;

  Widget _buildImageSelect(images) {
    return Container(
      height: 70,
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

  Widget _buildViewMore(ProductDetail detail) {
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AppImage(Core.domain + detail.images[0]),
          InkWell(
            onTap: () {
              setState(() {
                isFull = true;
              });
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withAlpha(0),
                  ],
                ),
              ),
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                'Xem thêm >',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListImage(List<String> images) {
    if (Utility.isNullOrEmpty(images)) {
      return SliverToBoxAdapter();
    } else {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                child: AppImage(Core.domain + images[index]),
              );
            },
            childCount: images.length,
          ),
        ),
      );
    }
  }

  Widget _buildMaterials() {
    if (Utility.stringIsNullOrEmpty(widget.info.materials)) {
      return SizedBox(
        height: 5,
      );
    } else {
      return Padding(
        child: Text(widget.info.materials),
        padding: EdgeInsets.only(top: 5),
      );
    }
  }

  Widget _buildTags(ProductDetail detail) {
    var tags = detail != null ? detail.tags : null;
    if (Utility.isNullOrEmpty(tags)) {
      return Container();
    } else {
      List<Widget> children = [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text('TAG: '),
        ),
      ];
      for (var _tag in tags) {
        children.add(
          InkWell(
            onTap: () {
              ListProduct.showByTag(context, _tag);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                _tag.name,
                style: Theme.of(context).textTheme.body2.merge(
                      TextStyle(color: Colors.blue),
                    ),
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Wrap(
          children: children,
        ),
      );
    }
  }

  Widget _buildOtherInfo(ProductDetail detail) {
    List<TextSpan> children = [
      TextSpan(text: 'Trạng thái: '),
      widget.info.availability
          ? TextSpan(text: 'Có sẵn', style: TextStyle(color: Colors.green))
          : TextSpan(text: 'Hết hàng', style: TextStyle(color: Colors.red)),
    ];
    if (detail != null) {
      children.addAll([
        TextSpan(text: '\t\t\tDanh mục: '),
        TextSpan(
            text: '${detail.categoryName}',
            style: TextStyle(color: Colors.blue)),
      ]);
    }
    children.addAll([
      TextSpan(text: '\t\t\tMã: '),
      TextSpan(
          text: '${widget.info.sku}', style: TextStyle(color: Colors.grey)),
    ]);

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey),
        children: children,
      ),
    );
  }

  Widget _buildButtonControl(ProductDetail detail) {
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(widget.info.productID);
    Color iconColor = Theme.of(context).primaryColor;
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            favorite
                ? IconButton(
                    color: iconColor,
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      Provider.of<FavoriteProvider>(context)
                          .removeProduct(widget.info.productID);
                    },
                  )
                : IconButton(
                    color: iconColor,
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {
                      Provider.of<FavoriteProvider>(context)
                          .addNewProduct(context, widget.info, count: 1);
                    },
                  ),
            IconButton(
              icon: Icon(
                Icons.cloud_download,
                color: iconColor,
              ),
              onPressed: () {
                if (detail != null) {
                  _onAksBeforeDownload(detail);
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: iconColor,
              ),
              onPressed: () {
                if (detail != null) {
                  _onShare(detail);
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.content_copy,
                color: iconColor,
              ),
              onPressed: () {
                Clipboard.setData(
                    new ClipboardData(text: detail.getTextCopy()));
                AppSnackBar.showFlushbar(context, 'Copy',
                    duration: Duration(seconds: 1));
              },
            ),
          ],
        ),
      ),
    );
  }

  _onAksBeforeDownload(ProductDetail detail) {
    AppPopup.showImageDialog(context,
        image: Icon(
          Icons.cloud_download,
          size: 70,
          color: Theme.of(context).primaryColor,
        ),
        title: 'Lưu hình ảnh vào Gallery?',
        btnHighlight: ButtonData(
            title: 'Lưu',
            callback: () {
              _onDownLoad(detail);
            }),
        btnNormal: ButtonData(title: 'Không', callback: null));
  }

  _onDownLoad(ProductDetail detail) async {
    ProgressDialog loading = ProgressDialog(context,
        message: 'Download ${detail.images.length} images')
      ..show();
    for (int i = 0; i < detail.images.length; i++) {
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + detail.images[i]);
      await ImageGallerySaver.saveFile(file.path);
    }
    loading.hide(contextHide: context);
    AppSnackBar.showFlushbar(context, 'Lưu hình thành công.');
  }

  _onShare(ProductDetail detail) async {
    ProgressDialog loading = ProgressDialog(context,
        message: 'Download ${detail.images.length} images')
      ..show();
    var imageList = List<String>();
    for (int i = 0; i < detail.images.length; i++) {
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + detail.images[i]);
      imageList.add(file.path);
    }
    loading.hide(contextHide: context);
    Clipboard.setData(new ClipboardData(text: detail.getTextCopy()));
    ShareExtend.shareMultiple(imageList, "image");
  }

  ProductColor _currentColor;

  Widget _buildProductColor(ProductDetail detail) {
    if (Utility.isNullOrEmpty(detail.colors)) {
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

  Widget _buildProductSize(ProductDetail detail) {
    if (Utility.isNullOrEmpty(detail.sizes)) {
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
