import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/product.dart';
import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupProductFilter extends StatefulWidget {
  @override
  _PopupProductFilterState createState() => _PopupProductFilterState();
}

class _PopupProductFilterState extends State<PopupProductFilter> {
  @override
  Widget build(BuildContext context) {
    ConfigProvider provider = Provider.of(context);
    _textMin = provider.priceMin < 0
        ? '0'
        : Utility.formatPrice(provider.priceMin.round() * 10000);
    _textMax = provider.priceMax > 50
        ? 'không giới hạn'
        : Utility.formatPrice((provider.priceMax.round() * 10000));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            'Giá sản phẩm: $_textMin -> $_textMax',
            style: Theme.of(context).textTheme.subtitle,
          ),
          SizedBox(height: 10),
          _buildSliderRangePrice(context),
          SizedBox(height: 10),
          Text(
            'Sản phẩm:',
            style: Theme.of(context).textTheme.subtitle,
          ),
          Column(
            children: ProductRepository.instance.productBadge
                .map((item) => _buildCheckBoxBadge(context, item))
                .toList(),
          ),
        ],
      ),
    );
  }

  String _textMin;
  String _textMax;

  Widget _buildSliderRangePrice(BuildContext context) {
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

  Widget _buildInputPrice(BuildContext context, bool isMin) {
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
          int result = Utility.stringIsNullOrEmpty(controller.text)
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

  Widget _buildCheckBoxBadge(BuildContext context, ProductBadge badge) {
    ConfigProvider provider = Provider.of(context);

    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Checkbox(
            value: provider.badge.contains(badge.id),
            tristate: true,
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
