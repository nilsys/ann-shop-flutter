import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFilterView extends StatefulWidget {
  @override
  _ProductFilterViewState createState() => _ProductFilterViewState();
}

class _ProductFilterViewState extends State<ProductFilterView> {
  void onSave(context) {
    Provider.of<ConfigProvider>(context).saveFilter();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onSave(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              onSave(context);
              Navigator.pop(context);
            },
          ),
          title: Text('Lọc sản phẩm theo?'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    ConfigProvider provider = Provider.of(context);
    int _count = provider.filter.countSet;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Giá sản phẩm: ',
                  style: Theme.of(context).textTheme.subtitle,
                ),
//                _buildCurrentPriceText()
              ]),
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                _buildCheckBoxPriceItem(0, 50),
                _buildCheckBoxPriceItem(50, 80),
                _buildCheckBoxPriceItem(80, 100),
                _buildCheckBoxPriceItem(100, 120),
                _buildCheckBoxPriceItem(120, 150),
                _buildCheckBoxPriceItem(150, 180),
                _buildCheckBoxPriceItem(180, 0),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Sản phẩm:',
              style: Theme.of(context).textTheme.subtitle,
            ),
            Column(
              children: ProductRepository.instance.productBadge
                  .map((item) => _buildCheckBoxBadge(item))
                  .toList(),
            ),
            _count == 0
                ? Container()
                : FlatButton(
                    child: Text(
                      'Xoá bộ lọc ($_count)',
                      style: Theme.of(context).textTheme.button.merge(
                            TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                    ),
                    onPressed: () {
                      setState(() {
                        provider.refreshFilter();
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBoxPriceItem(int min, int max) {
    ConfigProvider provider = Provider.of(context);
    String _text = min <= 0
        ? 'Dưới ${max}k'
        : max == 0 ? 'Trên ${min}k' : 'Từ ${min}k - ${max}k';

    int priceMin = min * 1000;
    int priceMax = max * 1000;
    bool isChoose =
        provider.filter.priceMin == priceMin && provider.filter.priceMax == priceMax;
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: isChoose
                ? Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.radio_button_unchecked),
            onPressed: () {
              setState(() {
                if (isChoose) {
                  provider.priceMin = 0;
                  provider.priceMax = 0;
                } else {
                  provider.priceMin = priceMin;
                  provider.priceMax = priceMax;
                }
              });
            },
          ),
          Text(_text),
        ],
      ),
    );
  }

  Widget _buildCheckBoxBadge(ProductBadge badge) {
    ConfigProvider provider = Provider.of(context);
    bool isChoose = badge.id == provider.filter.badge;
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: isChoose
                ? Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.radio_button_unchecked),
            onPressed: () {
              setState(() {
                if (isChoose) {
                  provider.filter.badge = 0;
                } else {
                  provider.filter.badge = badge.id;
                }
              });
            },
          ),
          Text(badge.title),
        ],
      ),
    );
  }
}
