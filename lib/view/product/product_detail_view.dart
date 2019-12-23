import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ann_shop_flutter/provider/category/category_provider.dart';
import 'package:ann_shop_flutter/provider/product/seen_provider.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/ui/product_ui/option_menu_product.dart';
import 'package:ann_shop_flutter/ui/product/product_item.dart';
import 'package:ann_shop_flutter/ui/product/product_related_item.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/button_gradient.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/ui/utility/title_view_more.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  ScrollController controllerScroll;
  PageController controllerPage;

  double oldOffset = 0;
  final double pointCheck = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFull = false;
    controllerPage = new PageController(initialPage: 0);
    controllerScroll = new ScrollController();
    controllerScroll.addListener(() {
      if (controllerScroll.hasClients && isFull) {
        var offset = controllerScroll.offset;
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
        controller: controllerScroll,
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
                  _onCheckAndCopy(data.data);
                },
                onDownload: () {
                  if (data.isCompleted) {
                    _onAksBeforeDownload(data.data);
                  } else {
                    AppSnackBar.showFlushbar(
                        context, 'Đang tải dữ liệu. Thử lại sau');
                  }
                },
                onShare: () {
                  if (data.isCompleted) {
                    _onShare(data.data);
                  } else {
                    AppSnackBar.showFlushbar(
                        context, 'Đang tải dữ liệu. Thử lại sau');
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
                          arguments: {'index': indexImage, 'data': data.data});
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        itemCount: images.length,
                        controller: controllerPage,
                        onPageChanged: (index) {
                          setState(() {
                            indexImage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Hero(
                              tag: images[0] +
                                  index.toString() +
                                  widget.info.sku,
                              child: AppImage(
                                Core.domain + images[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                      ButtonDownload(
                        imageName: images[indexImage],
                      ),
                    ],
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
                      _buildProductColorSize(data.data),
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
          _buildRelated(),
          _buildSeen(),
          _buildByCatalog(data.data),
        ],
      ),
    );
  }

  _onCheckAndCopy(detail){
    print(Core.copySetting.showed);
    if(Core.copySetting.showed) {
      _onCopy(detail);
      AppSnackBar.showFlushbar(context, 'Copy',
          duration: Duration(seconds: 1));
    }else{
      Navigator.pushNamed(context, '/setting');
    }
  }

  _onCopy(detail) {
    var _text = detail == null
        ? widget.info.getTextCopy(hasContent: true)
        : detail.getTextCopy(hasContent: true);
    _text += '\n';
    _text += Core.copySetting.getUserInfo();
    Clipboard.setData(new ClipboardData(text: _text));
  }

  _buildFillRemaining(ResponseProvider<ProductDetail> data) {
    if (data.isCompleted) {
      List<String> images = [];
      if (Utility.isNullOrEmpty(data.data.contentImages) == false) {
        images.addAll(data.data.contentImages);
      }
      if (Utility.isNullOrEmpty(data.data.images) == false) {
        images.addAll(data.data.images);
      }
      if (Utility.isNullOrEmpty(images)) {
        return SliverToBoxAdapter();
      } else if (isFull || images.length == 1) {
        return _buildListImage(images);
      } else {
        return _buildViewMore(images[0]);
      }
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
    if (controllerScroll.hasClients == false ||
        controllerScroll.offset < pointCheck ||
        isFull == false) {
      return null;
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'floating_arrow_upward',
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () {
              controllerScroll.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'floating_unfold_less',
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
            controllerPage.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
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

  Widget _buildViewMore(String image) {
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AppImage(Core.domain + image),
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
                    Colors.white.withAlpha(180),
                    Colors.white.withAlpha(0),
                  ],
                ),
                border: new Border(
                    bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                  style: BorderStyle.solid,
                )),
              ),
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Xem thêm',
                    style: Theme.of(context).textTheme.title.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
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
              var tag = 'list_image$index';
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/image-view',
                      arguments: {'url': images[index], 'tag': tag});
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Stack(
                    children: <Widget>[
                      Hero(                    tag: images[index] + tag,
                          child: AppImage(Core.domain + images[index])),
                      ButtonDownload(
                        imageName: images[index],
                        cache: true,
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: images.length,
          ),
        ),
      );
    }
  }

  Widget _buildMaterials() {
    if (Utility.isNullOrEmpty(widget.info.materials)) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
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
                      } else {
                        AppSnackBar.showFlushbar(
                            context, 'Đang tải dữ liệu. Thử lại sau');
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
                      } else {
                        AppSnackBar.showFlushbar(
                            context, 'Đang tải dữ liệu. Thử lại sau');
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.content_copy,
                      color: iconColor,
                    ),
                    onPressed: () {
                      _onCheckAndCopy(detail);
                    },
                  ),
                ],
              ),
            ),
            _buildDownload(),
          ],
        ),
      ),
    );
  }

  Widget _buildDownload() {
    DownloadImageProvider provider = Provider.of(context);
    String message = provider.currentMessage;
    if (Utility.isNullOrEmpty(message)) {
      return Container();
    } else {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Indicator(
              radius: 8,
            ),
            SizedBox(
              width: 10,
            ),
            Text(message),
          ],
        ),
      );
    }
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
              Provider.of<DownloadImageProvider>(context).images =
                  detail.images;
            }),
        btnNormal: ButtonData(title: 'Không', callback: null));
  }

  _onShare(ProductDetail detail) async {
    ProgressDialog loading = ProgressDialog(context,
        message: 'Download ${detail.images.length} images')
      ..show();
    var imageList = List<String>();
    for (int i = 0; i < detail.images.length; i++) {
      try {
        var file = await DefaultCacheManager()
            .getSingleFile(Core.domain + detail.images[i])
            .timeout(Duration(seconds: 5));
        imageList.add(file.path);
      } catch (e) {
        // skip
      }
    }

    loading.hide(contextHide: context);
    _onCopy(detail);
    ShareExtend.shareMultiple(imageList, "image");
  }

  Widget _buildProductColorSize(ProductDetail detail) {
    if (Utility.isNullOrEmpty(detail.colors) &&
        Utility.isNullOrEmpty(detail.sizes)) {
      return Container();
    }
    return ButtonGradient(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
                text: 'Chọn màu / Chọn size',
                style: Theme.of(context).textTheme.body2)
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/product-image-by-size-and-image',
            arguments: {'index': indexImage, 'data': detail});
      },
    );
  }

  Widget _buildRelated() {
    List<ProductRelated> related = Provider.of<ProductProvider>(context)
        .getRelatedBySlug(widget.info.slug)
        .data;
    if (Utility.isNullOrEmpty(related) == false) {
      return SliverToBoxAdapter(
          child: Container(
        decoration: BoxDecoration(
          border: new Border(
            top: BorderSide(
              color: AppStyles.dividerColor,
              width: 10,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Text(
                'Sản phẩm liên quan',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: related.length > 3 ? 270 : 135,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                itemBuilder: (context, index) {
                  return ProductRelatedItem(related[index]);
                },
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.45,
                  crossAxisCount: related.length > 3 ? 2 : 1,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ));
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildSeen() {
    final imageWidth = 150.0;
    final imageHeight = 200.0;
    SeenProvider provider = Provider.of(context);
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          border: new Border(
            top: BorderSide(
              color: AppStyles.dividerColor,
              width: 10,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            TitleViewMore(
              title: 'Sản phẩm đã xem',
              onPressed: () {
                Navigator.pushNamed(context, '/seen');
              },
            ),
            Container(
              height: imageHeight + 140,
              padding: EdgeInsets.only(left: 0, right: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  if (provider.products[index].productID ==
                      widget.info.productID) {
                    return Container();
                  }
                  return ProductItem(
                    provider.products[index],
                    width: imageWidth,
                    imageHeight: imageHeight,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildByCatalog(ProductDetail detail) {
    if (detail != null && Utility.isNullOrEmpty(detail.categorySlug) == false) {
      var category = Provider.of<CategoryProvider>(context)
          .getCategory(detail.categorySlug);
      if (category == null) {
        category = Category(slug: detail.categorySlug);
      }
      return SliverToBoxAdapter(
          child: ProductSlide(
        category,
        customName: 'Sản phẩm cùng danh mục',
      ));
    } else {
      return SliverToBoxAdapter();
    }
  }
}
