import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/model/product/product_related.dart';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product_detail.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:ann_shop_flutter/ui/favorite/favorite_button.dart';
import 'package:ann_shop_flutter/ui/home_page/product_slide.dart';
import 'package:ann_shop_flutter/ui/home_page/seen_block.dart';
import 'package:ann_shop_flutter/ui/product_ui/button_download.dart';
import 'package:ann_shop_flutter/ui/product_ui/info_product.dart';
import 'package:ann_shop_flutter/ui/product_ui/option_menu_product.dart';
import 'package:ann_shop_flutter/ui/product/product_related_item.dart';
import 'package:ann_shop_flutter/ui/product_ui/policy_product_block.dart';
import 'package:ann_shop_flutter/ui/product_ui/product_banner.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/button_gradient.dart';
import 'package:ann_shop_flutter/ui/utility/download_background.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

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
      Provider.of<CoverProvider>(context).refreshCoverProductPage(widget.slug);
    });
  }

  ProductDetail detail;

  bool addSeen = false;

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    ResponseProvider<ProductDetail> data = provider.getBySlug(widget.slug);
    detail = data.data;

    return Scaffold(
        floatingActionButton: _buildFloatButton(),
        bottomNavigationBar: _buildButtonControl(),
        body: _buildBody());
  }

  Widget _buildBody() {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    ResponseProvider<ProductDetail> data = provider.getBySlug(widget.slug);

    if (data.isCompleted) {
      return CustomScrollView(
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
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }),
              FavoriteButton(
                color: AppStyles.dartIcon,
              ),
              OptionMenuProduct(
                onCopy: () {
                  _onCheckAndCopy();
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
                    _onShare();
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
                    Navigator.pushNamed(context, '/product-fancy-image',
                        arguments: {'index': indexImage, 'data': data.data});
                  },
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        itemCount: detail.images.length,
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
                              tag: detail.images[0] +
                                  index.toString() +
                                  detail.sku,
                              child: AppImage(
                                Core.domain + detail.images[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                      ButtonDownload(
                        imageName: detail.images[indexImage],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildImageSelect(detail.images),
            ]),
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
            padding:
                EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 15),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  detail.name,
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
                    top: BorderSide(color: AppStyles.dividerColor, width: 10))),
          ),
          InfoProduct(detail),
          _buildTitle('Thông tin sản phẩm'),
          _buildContent(),

          /// List image
          _buildListImageOrLoadMore(),
          _buildRelated(),
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
      );
    } else if (data.isLoading) {
      return Container(
        child: Indicator(),
      );
    } else {
      return Container(
        child: SomethingWentWrong(
          onReload: () {
            provider.loadProduct(widget.slug);
          },
        ),
      );
    }
  }

  _onCheckAndCopy() async {
    print(Core.copySetting.showed);
    if (detail == null) {
      AppSnackBar.showFlushbar(context, 'Đang tải dữ liệu. Thử lại sau');
    } else if (Core.copySetting.showed) {
      await _onCopy();
      AppSnackBar.showFlushbar(context, 'Copy', duration: Duration(seconds: 1));
    } else {
      Navigator.pushNamed(context, '/setting');
    }
  }

  _onCopy() async {
    var _text = await detail.getTextCopy(hasContent: true);
    _text += '\n';
    _text += Core.copySetting.getUserInfo();
    Clipboard.setData(new ClipboardData(text: _text));
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
      List<String> images = [];
      if (Utility.isNullOrEmpty(detail.contentImages) == false) {
        images.addAll(detail.contentImages);
      }
      if (Utility.isNullOrEmpty(detail.images) == false) {
        if ((Utility.isNullOrEmpty(detail.contentImages) == false)) {
          for (var item in detail.images) {
            if (images.contains(item) == false) {
              images.remove(item);
            }
          }
        }
        images.addAll(detail.images);
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
          AppImage(image),
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
                      Hero(
                          tag: images[index] + tag,
                          child: AppImage(images[index])),
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
                                .removeProduct(detail.productID);
                          },
                        )
                      : IconButton(
                          color: iconColor,
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {
                            Provider.of<FavoriteProvider>(context)
                                .addNewProduct(context, detail, count: 1);
                          },
                        ),
                  IconButton(
                    icon: Icon(
                      Icons.cloud_download,
                      color: iconColor,
                    ),
                    onPressed: () {
                      if (detail != null) {
                        _onAksBeforeDownload();
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
                        _onShare();
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
                      _onCheckAndCopy();
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
              bool result = Provider.of<DownloadImageProvider>(context)
                  .downloadImages(detail.images);
              if (result == false) {
                AppSnackBar.showFlushbar(
                    context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
              }
            }),
        btnNormal: ButtonData(title: 'Không', callback: null));
  }

  _onShare() async {
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
        loading.update('Download ${i + 1}/${detail.images.length} images');
      } catch (e) {
        // fail 1
      }
    }

    loading.hide(contextHide: context);
    await _onCopy();
    ShareExtend.shareMultiple(imageList, "image");
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
            arguments: {'index': indexImage, 'data': detail});
      },
    );
  }

  Widget _buildRelated() {
    List<ProductRelated> related = Provider.of<ProductProvider>(context)
        .getRelatedBySlug(detail.slug)
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
                'Thuộc tính',
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

  Widget _buildByCatalog() {
    if (detail != null && Utility.isNullOrEmpty(detail.categorySlug) == false) {
      var category = Category(
          name: 'Sản phẩm cùng danh mục',
          filter: ProductFilter(categorySlug: detail.categorySlug));
      return SliverToBoxAdapter(
          child: ProductSlide(
        category,
      ));
    } else {
      return SliverToBoxAdapter();
    }
  }
}
