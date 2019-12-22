import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
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

  String _textMin;
  String _textMax;

  Widget _buildBody() {
    ConfigProvider provider = Provider.of(context);
    _textMin = provider.priceMin < 0
        ? '0'
        : Utility.formatPrice(provider.priceMin.round() * 10000);
    _textMax = provider.priceMax > 50
        ? 'không giới hạn'
        : Utility.formatPrice((provider.priceMax.round() * 10000));

    int _count = provider.filter.countSet;
    return Container(
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
          _buildPriceCheckBoxList(),
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
    );
  }

  _buildCurrentPriceText() {
    return TextSpan(
      text: '$_textMin -> $_textMax',
      style: Theme.of(context)
          .textTheme
          .subtitle
          .merge(TextStyle(color: Theme.of(context).primaryColor)),
    );
  }

  _buildPriceRecommendWrap() {
    return Wrap(
      children: <Widget>[
        _buildPriceRecommendItem(0, 5),
        SizedBox(
          width: 5,
        ),
        _buildPriceRecommendItem(5, 10),
        SizedBox(
          width: 5,
        ),
        _buildPriceRecommendItem(10, 20),
        SizedBox(
          width: 5,
        ),
        _buildPriceRecommendItem(20, 30),
        SizedBox(
          width: 5,
        ),
        _buildPriceRecommendItem(30, 40),
        SizedBox(
          width: 5,
        ),
        _buildPriceRecommendItem(40, 51),
      ],
    );
  }

  _buildPriceRecommendItem(int min, int max) {
    ConfigProvider provider = Provider.of(context);
    String _text = min <= 0
        ? 'Dưới ${max * 10}k'
        : max > 50 ? 'Trên ${min * 10}k' : 'Từ ${min * 10}k - ${max * 10}k';
    bool isChoose = provider.priceMin == min && provider.priceMax == max;
    Color _color = isChoose ? Theme.of(context).primaryColor : Colors.black87;
    return ActionChip(
      avatar: Icon(
        Icons.attach_money,
        color: _color,
      ),
      label: Text(
        _text,
        style: TextStyle(color: _color),
      ),
      onPressed: () {
        setState(() {
          provider.priceMin = min.toDouble();
          provider.priceMax = max.toDouble();
        });
      },
    );
  }

  Widget _buildPriceCheckBoxList() {
    return Column(
      children: <Widget>[
        _buildCheckBoxPriceItem(0, 5),
        _buildCheckBoxPriceItem(5, 8),
        _buildCheckBoxPriceItem(8, 10),
        _buildCheckBoxPriceItem(10, 12),
        _buildCheckBoxPriceItem(12, 15),
        _buildCheckBoxPriceItem(15, 18),
        _buildCheckBoxPriceItem(18, 51),
      ],
    );
  }

  Widget _buildCheckBoxPriceItem(int min, int max) {
    ConfigProvider provider = Provider.of(context);
    String _text = min <= 0
        ? 'Dưới ${max * 10}k'
        : max > 50 ? 'Trên ${min * 10}k' : 'Từ ${min * 10}k - ${max * 10}k';
    bool isChoose = provider.priceMin == min && provider.priceMax == max;
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Radio(
            value: isChoose,
            groupValue: true,
            onChanged: (value) {
              print(value);
              setState(() {
                  provider.priceMin = min.toDouble();
                  provider.priceMax = max.toDouble();
              });
            },
          ),
          Text(_text),
        ],
      ),
    );
  }

  Widget _buildSliderRangePrice() {
    ConfigProvider provider = Provider.of(context);
    return SliderTheme(
      data: SliderThemeData(showValueIndicator: ShowValueIndicator.always),
      child: RangeSlider(
        min: -1,
        max: 51,
        values: RangeValues(provider.priceMin, provider.priceMax),
        onChanged: (newValue) {
          setState(() {
            if ((newValue.end - newValue.start) >= 3) {
              provider.priceMin = newValue.start;
              provider.priceMax = newValue.end;
            } else {
              if (provider.priceMin == newValue.start) {
                provider.priceMax = newValue.start + 3;
              } else {
                provider.priceMin = newValue.end - 3;
              }
            }
          });
        },
        onChangeStart: (newValue) {},
        onChangeEnd: (newValue) {},
        labels: RangeLabels('Min: $_textMin', 'Max: $_textMax'),
      ),
    );
  }

  Widget _buildInputPrice(bool isMin) {
    String labelText = isMin ? 'Min' : 'Max';
    ConfigProvider provider = Provider.of(context);
    double price = isMin ? provider.priceMin : provider.priceMax;
    String value = price < 0 ? null : price.toString();
    final TextEditingController controller = TextEditingController(text: value);
    return Container(
      width: 80,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onEditingComplete: () {
          print(controller.text);
          int result = Utility.isNullOrEmpty(controller.text)
              ? -1
              : int.parse(controller.text);
          if (isMin) {
            provider.priceMin = result.toDouble();
          } else {
            provider.priceMax = result.toDouble();
          }
        },
      ),
    );
  }

  Widget _buildCheckBoxBadge(ProductBadge badge) {
    ConfigProvider provider = Provider.of(context);

    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Checkbox(
            value: provider.filter.badge.contains(badge.id),
            onChanged: (value) {
              if (value ?? false) {
                provider.addBadge(badge.id);
              } else {
                provider.removeBadge(badge.id);
              }
            },
          ),
          Text(badge.title),
        ],
      ),
    );
  }
}
