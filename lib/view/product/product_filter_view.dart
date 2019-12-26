import 'dart:math';

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
                TextSpan(
                  text: getTextMinMax((provider.filter.priceMin / 1000).round(),
                      (provider.filter.priceMax / 1000).round()),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                )
              ]),
            ),
            SizedBox(height: 10),
            _buildPriceRecommendWrap(),
            _buildSliderRangePrice(),
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

  /// Price
  String getTextMinMax(int _min, int _max) {
    String _text = _min <= 0 && _max <= 0
        ? ''
        : _min <= 0
            ? 'Dưới ${_max}k'
            : _max == 0 ? 'Trên ${_min}k' : 'Từ ${_min}k - ${_max}k';
    return _text;
  }

  _buildPriceRecommendWrap() {
    return Wrap(
      children: <Widget>[
        _buildPriceRecommendItem(0, 50),
        SizedBox(width: 5),
        _buildPriceRecommendItem(50, 80),
        SizedBox(width: 5),
        _buildPriceRecommendItem(80, 100),
        SizedBox(width: 5),
        _buildPriceRecommendItem(100, 120),
        SizedBox(width: 5),
        _buildPriceRecommendItem(120, 150),
        SizedBox(width: 5),
        _buildPriceRecommendItem(150, 180),
        SizedBox(width: 5),
        _buildPriceRecommendItem(180, 0),
      ],
    );
  }

  _buildPriceRecommendItem(int min, int max) {
    ConfigProvider provider = Provider.of(context);
    int priceMin = min * 1000;
    int priceMax = max * 1000;
    bool isChoose = provider.filter.priceMin == priceMin &&
        provider.filter.priceMax == priceMax;
    Color _color = isChoose ? Theme.of(context).primaryColor : Colors.black87;
    return ActionChip(
      avatar: Icon(
        Icons.attach_money,
        color: _color,
      ),
      label: Text(
        getTextMinMax(min, max),
        style: TextStyle(color: _color),
      ),
      onPressed: () {
        setState(() {
          provider.priceMin = priceMin;
          provider.priceMax = priceMax;
        });
      },
    );
  }

  Widget _buildSliderRangePrice() {
    ConfigProvider provider = Provider.of(context);
    double _min = (provider.filter.priceMin / 1000).round().toDouble();
    double _max = (provider.filter.priceMax / 1000).round().toDouble();
    if (_max <= 0 || _max > 201) {
      _max = 201;
    }
    return SliderTheme(
      data: SliderThemeData(showValueIndicator: ShowValueIndicator.always),
      child: RangeSlider(
        min: 0,
        max: 201,
        values: RangeValues(_min, _max),
        onChanged: (newValue) {
          setState(() {
            int _newMin = newValue.start.round();
            int _newMax = newValue.end.round();
            if ((_newMax - _newMin) >= 2) {
              provider.priceMin = (_newMin * 1000).round();
              provider.priceMax = (_newMax > 200 ? 0 : _newMax * 1000).round();
            } else {
              if (_min == _newMin) {
                var end = _newMin + 3;
                provider.priceMax = end > 200 ? 0 : end * 1000;
              } else {
                provider.priceMin = min(0, ((_newMax - 3) * 100).round());
              }
            }
          });
        },
        onChangeStart: (newValue) {},
        onChangeEnd: (newValue) {},
      ),
    );
  }
}
