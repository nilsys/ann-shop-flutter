import 'package:ann_shop_flutter/model/product.dart';
import 'package:ann_shop_flutter/model/product_detail.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              /// page view image
              /// name
              /// materials
              /// info status, category, ode
              /// Gia si
              /// Gia le
              /// button control
              /// info title
              HtmlContent(widget.product.content),
              /// List image (button download)
            ],
          ),
        ),
      ),
    );
  }
}
