import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:flutube/src/models/my_video.dart';
import 'package:ann_shop_flutter/provider/product/product_utility.dart';
import 'package:ann_shop_flutter/src/controllers/utils/ann_download.dart';
import 'package:flutube/flutube.dart';
import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:ann_shop_flutter/ui/home_page/seen_block.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/ui/product_ui/info_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/option_menu_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/policy_product_block.dart';
import 'package:ann_shop_flutter/ui/product_ui/preview_image_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/product_banner.dart';

import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';

import 'package:ann_shop_flutter/view/product/product_related_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({@required this.slug});

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
    super.initState();
    isFull = false;
    controllerScroll = ScrollController();
    controllerScroll.addListener(() {
      if (controllerScroll.hasClients && isFull) {
        final offset = controllerScroll.offset;
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
    // VideoHelper.instance.dispose();
    super.dispose();
  }

  ProductDetail detail;

  bool addSeen = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final data = provider.getBySlug(widget.slug);
    detail = data.data;

    if (data.isCompleted) {
      final isFull = isFullScreen(context);
      return Scaffold(
        floatingActionButton: _buildFloatButton(),
        bottomNavigationBar: isFull ? null : _buildButtonControl(),
        body: CustomScrollView(
          controller: controllerScroll,
          slivers: <Widget>[
            /// app bar
            if (isFull == false)
              SliverAppBar(
                floating: true,
                pinned: false,
                iconTheme: IconThemeData(color: AppStyles.dartIcon),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(AppIcons.search,
                        size: 20, color: AppStyles.dartIcon),
                    onPressed: () {
                      Navigator.pushNamed(context, 'search');
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.home, color: AppStyles.dartIcon),
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('home'));
                      }),
                  FavoriteButton(
                    color: AppStyles.dartIcon,
                  ),
                  OptionMenuProduct(
                    onCopy: () {
                      ProductUtility.instance
                          .onCheckAndCopy(context, detail.productId);
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
                        ProductUtility.instance
                            .onCheckAndShare(context, detail);
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
                height: isFull ?  MediaQuery.of(context).size.height : 350,
                child: PreviewImageProduct(
                  detail?.carousel,
                  controller: controllerPage,
                  showFullButton: false,
                  tapExpanded: () {
                    Navigator.pushNamed(context, 'product/detail/fancy-image',
                        arguments: {
                          'index': controllerPage.page.round(),
                          'data': data.data
                        });
                  },
                  videos: detail.videos,
                  initIndex: 0,
                  productID: detail.productId,
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
                    '${detail.sku} - ${detail.name}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Giá sỉ: ${detail.regularDisplay}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .merge(detail.regularDisplayStyle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Giá lẻ: ${Utility.formatPrice(detail.retailPrice)}',
                    style: Theme.of(context).textTheme.headline6,
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
            _buildByCatalog(),
            SeenBlock(
              exceptId: detail.productId,
            ),
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
        body: Indicator(),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppStyles.dartIcon),
        ),
        body: SomethingWentWrong(
          onReload: () async {
            provider.loadProduct(widget.slug);
          },
        ),
      );
    }
  }

  Widget _buildTitle(title) {
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
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ]),
    );
  }

  Widget _buildContent() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          HtmlContent(detail.getContent()),
        ]),
      ),
    );
  }

  Widget _buildListImageOrLoadMore() {
    if (detail != null) {
      final images = [];
      if (isNullOrEmpty(detail.contentImages) == false) {
        images.addAll(detail.contentImages);
      }
      if (isNullOrEmpty(detail.carousel) == false) {
        if ((isNullOrEmpty(detail.contentImages) == false)) {
          for (final item in detail.carousel) {
            if (images.contains(item.origin) == false) {
              images.remove(item.origin);
            }
          }
        }
        images.addAll(detail.carousel);
      }
      if (isNullOrEmpty(images)) {
        return const SliverToBoxAdapter();
      } else {
        return SliverToBoxAdapter(
          child: AnimatedCrossFade(
            firstChild: _buildListImage(images),
            secondChild: _buildViewMore(images[0]),
            duration: const Duration(milliseconds: 300),
            crossFadeState: (isFull || images.length == 1)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        );
      }
    } else {
      return const SliverToBoxAdapter();
    }
  }

  Widget _buildRelate() {
    final related = Provider.of<ProductProvider>(context)
        .getRelatedBySlug(widget.slug)
        .data;
    return ProductRelatedList(
      widget.slug,
      initData: related,
    );
  }

  Widget _buildFloatButton() {
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
            onPressed: () {
              controllerScroll.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
            child: const Icon(Icons.arrow_upward, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'floating_unfold_less',
            onPressed: () {
              setState(() {
                isFull = false;
              });
              controllerScroll.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
            child: const Icon(
              Icons.unfold_less,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildViewMore(var image) {
    var feature = '';
    if (image is String) {
      feature = image;
    } else {
      final ProductCarousel carousel = image;
      feature = carousel.feature;
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width, child: AppImage(feature)),
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
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Xem thêm',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListImage(List images) {
    return Column(
      children: List.generate(images.length, (index) => index)
          .map((index) => _buildImage(images[index], index))
          .toList(),
    );
  }

  Widget _buildImage(item, index) {
    final tag = 'list_content_image$index';
    var feature = '';
    var origin = '';
    if (item is String) {
      feature = item;
      origin = item;
    } else {
      final ProductCarousel carousel = item;
      feature = carousel.feature;
      origin = carousel.origin;
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'product/detail/image',
            arguments: {'url': origin, 'tag': tag});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
  }

  Widget _buildButtonControl() {
    if (detail == null) {
      return null;
    }

    final favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(detail.productId);
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (favorite)
                  Expanded(
                    child: ButtonIconText(
                      'Xoá',
                      Icons.favorite,
                      onPressed: () {
                        Provider.of<FavoriteProvider>(context, listen: false)
                            .removeProduct(detail.productId);
                      },
                    ),
                  )
                else
                  Expanded(
                    child: ButtonIconText(
                      'Thích',
                      Icons.favorite_border,
                      onPressed: () {
                        Provider.of<FavoriteProvider>(context, listen: false)
                            .addNewProduct(context, detail.toProduct(),
                                count: 1);
                      },
                    ),
                  ),
                if (isNullOrEmpty(detail.videos) == false)
                  Expanded(
                    child: ButtonIconText(
                      'Tải video',
                      Icons.video_library,
                      onPressed: () => ANNDownload.instance.onDownLoadVideoProduct(
                          context, detail.productId),
                    ),
                  ),
                Expanded(
                  child: ButtonIconText(
                    'Tải hình',
                    MaterialCommunityIcons.image_multiple,
                    onPressed: () {
                      if (detail != null) {
                        ANNDownload.instance
                            .onDownLoadImagesProduct(context, detail.productId);
                      } else {
                        AppSnackBar.showFlushbar(
                            context, 'Đang tải dữ liệu. Thử lại sau');
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ButtonIconText(
                    'Đăng bài',
                    Icons.share,
                    onPressed: () {
                      if (detail != null) {
                        ProductUtility.instance
                            .onCheckAndShare(context, detail);
                      } else {
                        AppSnackBar.showFlushbar(
                            context, 'Đang tải dữ liệu. Thử lại sau');
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ButtonIconText(
                    'Copy',
                    Icons.content_copy,
                    onPressed: () => ProductUtility.instance
                        .onCheckAndCopy(context, detail.productId),
                  ),
                ),
              ],
            ),
            DownLoadBackground(),
          ],
        ),
      ),
    );
  }

  void _onAksBeforeDownload() {
    AppPopup.showCustomDialog(
      context,
      content: [
        AvatarGlow(
          endRadius: 50,
          duration: const Duration(milliseconds: 1000),
          glowColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.cloud_download,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          'Lưu tất cả hình ảnh của sản phẩm về máy?',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        CenterButtonPopup(
          normal: ButtonData(
            'Không',
          ),
          highlight: ButtonData(
            'Lưu',
            onPressed: () {
              ANNDownload.instance
                  .onDownLoadImagesProduct(context, detail.productId);
            },
          ),
        )
      ],
    );
  }

  Widget _buildProductColorSize() {
    if (isNullOrEmpty(detail.colors) && isNullOrEmpty(detail.sizes)) {
      return Container();
    }
    return ButtonGradient(
      onTap: () {
        Navigator.pushNamed(context, 'product/detail/select-size-color',
            arguments: {
              'index':
                  controllerPage.page.round() - (detail.videos?.length ?? 0),
              'data': detail
            });
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
                text: 'Chọn màu / Chọn size',
                style: Theme.of(context).textTheme.bodyText1)
          ],
        ),
      ),
    );
  }

  Widget _buildByCatalog() {
    if (detail != null && isNullOrEmpty(detail.categorySlug) == false) {
      final category = Category(
          name: detail.categoryName,
          filter: ProductFilter(categorySlug: detail.categorySlug));
      return SliverToBoxAdapter(
          child: ProductSlide(
        category,
        customName: 'Sản phẩm cùng danh mục',
      ));
    } else {
      return const SliverToBoxAdapter();
    }
  }
}
