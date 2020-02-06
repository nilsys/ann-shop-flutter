import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/button/button_gradient.dart';
import 'package:ann_shop_flutter/ui/button/icon_text_button.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:ann_shop_flutter/ui/home_page/seen_block.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/ui/product_ui/info_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/option_menu_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/policy_product_block.dart';
import 'package:ann_shop_flutter/ui/product_ui/preview_image_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/product_banner.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:ann_shop_flutter/view/product/product_related_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailView extends StatefulWidget {
  ProductDetailView({@required this.slug});

  final String slug;

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  bool isFull;
  ScrollController controllerScroll;
  PageController controllerPage = PageController(initialPage: 0);
  double oldOffset = 0;
  final double pointCheck = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFull = false;
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
      Provider.of<CoverProvider>(context, listen: false)
          .refreshCoverProductPage(widget.slug);
    });
  }

  @override
  void dispose() {
    controllerScroll.dispose();
    super.dispose();
  }

  ProductDetail detail;

  bool addSeen = false;

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    ResponseProvider<ProductDetail> data = provider.getBySlug(widget.slug);
    detail = data.data;

    if (data.isCompleted) {
      return Scaffold(
        floatingActionButton: _buildFloatButton(),
        bottomNavigationBar: _buildButtonControl(),
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
                  icon: Icon(AppIcons.search, color: AppStyles.dartIcon),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                IconButton(
                    icon: Icon(Icons.home, color: AppStyles.dartIcon),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    }),
                FavoriteButton(
                  color: AppStyles.dartIcon,
                ),
                OptionMenuProduct(
                  onCopy: () {
                    ProductRepository.instance
                        .onCheckAndCopy(context, detail.productID);
                  },
                  onDownload: () {
                    if (data.isCompleted) {
                      _onAksBeforeDownload();
                    } else {
                      AppSnackBar.showFlushbar(
                          context, 'Đang tải dữ liệu. Thử lại sau');
                    }
                  },
                  onShare: () {
                    if (data.isCompleted) {
                      ProductRepository.instance.onShare(context, detail);
                    } else {
                      AppSnackBar.showFlushbar(
                          context, 'Đang tải dữ liệu. Thử lại sau');
                    }
                  },
                ),
              ],
            ),

            /// page view image
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height / 2 + 80,
                child: PreviewImageProduct(
                  detail.carousel,
                  controller: controllerPage,
                  tapExpanded: () {
                    Navigator.pushNamed(context, '/product-fancy-image',
                        arguments: {
                          'index': controllerPage.page.round(),
                          'data': data.data
                        });
                  },
                  initIndex: 0,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildProductColorSize(),
                ]),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    detail.sku + ' - ' + detail.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Giá sỉ: ' + Utility.formatPrice(detail.regularPrice),
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
                    'Giá lẻ: ' + Utility.formatPrice(detail.retailPrice),
                    style: Theme.of(context).textTheme.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ),
            ),
            PolicyProductBlock(),
            SliverToBoxAdapter(
              child: ProductBanner(
                  Provider.of<CoverProvider>(context).headerProduct.data,
                  border: Border(
                      top: BorderSide(
                          color: AppStyles.dividerColor, width: 10))),
            ),
            InfoProduct(detail),
            _buildTitle('Thông tin sản phẩm'),
            _buildContent(),

            /// List image
            _buildListImageOrLoadMore(),
            _buildRelate(),
            SeenBlock(
              exceptID: detail.productID,
            ),
            _buildByCatalog(),
            SliverToBoxAdapter(
              child: ProductBanner(
                Provider.of<CoverProvider>(context).footerProduct.data,
                border: Border(
                    top: BorderSide(color: AppStyles.dividerColor, width: 10)),
              ),
            ),
          ],
        ),
      );
    } else if (data.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppStyles.dartIcon),
        ),
        body: Container(
          child: Indicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppStyles.dartIcon),
        ),
        body: Container(
          child: SomethingWentWrong(
            onReload: () {
              provider.loadProduct(widget.slug);
            },
          ),
        ),
      );
    }
  }

  _buildTitle(title) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 10,
          color: AppStyles.dividerColor,
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.title,
          ),
        )
      ]),
    );
  }

  _buildContent() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          HtmlContent(detail.getContent()),
        ]),
      ),
    );
  }

  _buildListImageOrLoadMore() {
    if (detail != null) {
      List images = [];
      if (Utility.isNullOrEmpty(detail.contentImages) == false) {
        images.addAll(detail.contentImages);
      }
      if (Utility.isNullOrEmpty(detail.carousel) == false) {
        if ((Utility.isNullOrEmpty(detail.contentImages) == false)) {
          for (var item in detail.carousel) {
            if (images.contains(item.origin) == false) {
              images.remove(item.origin);
            }
          }
        }
        images.addAll(detail.carousel);
      }
      if (Utility.isNullOrEmpty(images)) {
        return SliverToBoxAdapter();
      } else if (isFull || images.length == 1) {
        return _buildListImage(images);
      } else {
        return _buildViewMore(images[0]);
      }
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildRelate() {
    List<ProductRelated> related = Provider.of<ProductProvider>(context)
        .getRelatedBySlug(widget.slug)
        .data;
    return ProductRelatedList(
      widget.slug,
      initData: related,
    );
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
              controllerScroll.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            },
          ),
        ],
      );
    }
  }

  Widget _buildViewMore(var image) {
    String feature = '';
    String origin = '';
    if (image is String) {
      feature = image;
      origin = image;
    } else {
      ProductCarousel carousel = image;
      feature = carousel.feature;
      origin = carousel.origin;
    }
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AppImage(feature),
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

  Widget _buildListImage(List images) {
    if (Utility.isNullOrEmpty(images)) {
      return SliverToBoxAdapter();
    } else {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var tag = 'list_content_image$index';
              String feature = '';
              String origin = '';
              if (images[index] is String) {
                feature = images[index];
                origin = images[index];
              } else {
                ProductCarousel carousel = images[index];
                feature = carousel.feature;
                origin = carousel.origin;
              }
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/image-view',
                      arguments: {'url': origin, 'tag': tag});
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Hero(
                            tag: tag,
                            child: AppImage(
                              feature,
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.zoom_out_map,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ButtonDownload(imageName: origin, cache: true),
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

  Widget _buildButtonControl() {
    if (detail == null) {
      return null;
    }

    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(detail.productID);
    Color iconColor = Theme.of(context).primaryColor;
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  favorite
                      ? _buildIconTextButton(
                          'Xoá',
                          Icons.favorite,
                          onPressed: () {
                            Provider.of<FavoriteProvider>(context,
                                    listen: false)
                                .removeProduct(detail.productID);
                          },
                        )
                      : _buildIconTextButton(
                          'Thêm',
                          Icons.favorite_border,
                          onPressed: () {
                            Provider.of<FavoriteProvider>(context,
                                    listen: false)
                                .addNewProduct(context, detail.toProduct(),
                                    count: 1);
                          },
                        ),
                  _buildIconTextButton(
                    'Tải hình',
                    Icons.cloud_download,
                    onPressed: () {
                      if (detail != null) {
                        _onAksBeforeDownload();
                      } else {
                        AppSnackBar.showFlushbar(
                            context, 'Đang tải dữ liệu. Thử lại sau');
                      }
                    },
                  ),
                  _buildIconTextButton(
                    'Chia sẻ',
                    Icons.share,
                    onPressed: () {
                      if (detail != null) {
                        ProductRepository.instance.onShare(context, detail);
                      } else {
                        AppSnackBar.showFlushbar(
                            context, 'Đang tải dữ liệu. Thử lại sau');
                      }
                    },
                  ),
                  _buildIconTextButton(
                    'Copy',
                    Icons.content_copy,
                    onPressed: () {
                      ProductRepository.instance
                          .onCheckAndCopy(context, detail.productID);
                    },
                  ),
                ],
              ),
            ),
            DownLoadBackground(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextButton(String text, IconData icon,
      {VoidCallback onPressed}) {
    return Expanded(
      flex: 1,
      child: FlatButton(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: AppStyles.dartIcon,
              ),
              Text(
                text,
                maxLines: 1,
              ),
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  _onAksBeforeDownload() {
    AppPopup.showImageDialog(context,
        image: Icon(
          Icons.cloud_download,
          size: 70,
          color: Theme.of(context).primaryColor,
        ),
        title: 'Lưu tất cả hình ảnh của sản phẩm về máy?',
        btnHighlight: ButtonData(
            title: 'Lưu',
            callback: () {
              ProductRepository.instance.onDownLoad(context, detail.productID);
            }),
        btnNormal: ButtonData(title: 'Không', callback: null));
  }

  Widget _buildProductColorSize() {
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
            arguments: {'index': controllerPage.page.round(), 'data': detail});
      },
    );
  }

  Widget _buildByCatalog() {
    if (detail != null && Utility.isNullOrEmpty(detail.categorySlug) == false) {
      var category = Category(
          name: detail.categoryName,
          filter: ProductFilter(categorySlug: detail.categorySlug));
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
