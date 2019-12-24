import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:ann_shop_flutter/provider/utility/download_image_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/ui/product_ui/badge_tag_product_ui.dart';
import 'package:ann_shop_flutter/ui/utility/app_image.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class ProductFull extends StatefulWidget {
  ProductFull(this.product);

  final Product product;

  @override
  _ProductFullState createState() => _ProductFullState();
}

class _ProductFullState extends State<ProductFull> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - (defaultPadding * 2);
    double height = width * 4 / 3;
    return Container(
      margin: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(70),
            offset: Offset(1.0, 4.0),
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product-detail',
              arguments: widget.product);
        },
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: height,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemCount: widget.product.images.length + 1,
                    itemBuilder: (context, index) {
                      if (index == widget.product.images.length) {
                        return Container(
                          color: Colors.grey,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              AppImage(
                                Core.domain + widget.product.avatar,
                                fit: BoxFit.contain,
                              ),
                              Container(
                                color: Colors.black.withAlpha(100),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.filter,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Xem thêm',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return AppImage(
                          Core.domain + widget.product.images[index],
                          fit: BoxFit.contain,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: BadgeTagProductUI(widget.product.badge),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Mã: ' + widget.product.sku,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .merge(TextStyle(color: Colors.grey)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Giá sỉ: ' +
                              Utility.formatPrice(widget.product.regularPrice),
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .merge(TextStyle(color: Colors.red)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Giá lẻ: ' +
                              Utility.formatPrice(widget.product.retailPrice),
                          style: Theme.of(context).textTheme.body2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildButtonControl(context),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildButtonControl(context) {
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(widget.product.productID);
    Color iconColor = Theme.of(context).primaryColor;

    return Container(
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
                        .removeProduct(widget.product.productID);
                  },
                )
              : IconButton(
                  color: iconColor,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context)
                        .addNewProduct(context, widget.product, count: 1);
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.cloud_download,
              color: iconColor,
            ),
            onPressed: () {
              _onDownLoad(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: iconColor,
            ),
            onPressed: () {
              _onShare(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: iconColor,
            ),
            onPressed: () {
              _onCheckAndCopy(context);
            },
          ),
        ],
      ),
    );
  }

  _buildListDot(length) {
    List listIndex = List.generate(length, (index) => index);
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: listIndex
            .map(
              (index) => Padding(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.fiber_manual_record,
                  size: 16,
                  color: index == currentPage ? Colors.white : Colors.grey,
                ),
              ),
            )
            .toList());
  }

  _onCheckAndCopy(context) {
    print(Core.copySetting.showed);
    if (Core.copySetting.showed) {
      _onCopy(context);
      AppSnackBar.showFlushbar(context, 'Copy', duration: Duration(seconds: 1));
    } else {
      Navigator.pushNamed(context, '/setting');
    }
  }

  _onCopy(context) {
    var _text = widget.product.getTextCopy(hasContent: true);
    _text += '\n';
    _text += Core.copySetting.getUserInfo();
    Clipboard.setData(new ClipboardData(text: _text));
  }

  _onDownLoad(context) async {
    try {
      var images = await ProductRepository.instance
          .loadProductAdvertisementImage(widget.product.productID);
      if (Utility.isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
            duration: Duration(seconds: 1));
      } else {
        Provider.of<DownloadImageProvider>(context).images = images;
      }
    } catch (e) {
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: Duration(seconds: 1));
    }
  }

  _onShare(context) async {
    try {
      ProgressDialog loading =
          ProgressDialog(context, message: 'Download images')..show();
      var images = await ProductRepository.instance
          .loadProductAdvertisementImage(widget.product.productID);
      List<String> files = [];
      for (int i = 0; i < images.length; i++) {
        try {
          var file = await DefaultCacheManager()
              .getSingleFile(Core.domain + widget.product.getCover)
              .timeout(Duration(seconds: 5));
          files.add(file.path);
          loading.update('Download ${i + 1}/${images.length} images');
        } catch (e) {
          // fail 1
        }
      }
      loading.hide(contextHide: context);
      if (Utility.isNullOrEmpty(files) == false) {
        _onCopy(context);
        ShareExtend.shareMultiple(files, "image");
      } else {
        throw ('Data empty');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: Duration(seconds: 1));
      return;
    }
  }
}
