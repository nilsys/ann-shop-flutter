import 'package:ann_shop_flutter/provider/utility/config_provider.dart';
import 'package:ann_shop_flutter/repository/product_repository.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigProductUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 2, color: AppStyles.dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: _buildSort(context),
            ),
          ),
          _buildIconButton(context, Icons.view_module, ViewType.grid),
          _buildIconButton(context, Icons.view_stream, ViewType.list),
          _buildIconButton(context, Icons.view_day, ViewType.big),
          _buildFilter(context),
        ],
      ),
    );
  }

  _buildIconButton(context, IconData icon, int index) {
    ConfigProvider config = Provider.of(context);

    bool highlight = index == config.view;
    return InkWell(
      onTap: () {
        if (highlight == false) {
          config.view = index;
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: highlight ? Theme.of(context).primaryColor : Colors.white,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: highlight ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    int _count = Provider.of<ConfigProvider>(context).filter.countSet;
    return InkWell(
      onTap: () {
        showFilterPage(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 2, color: AppStyles.dividerColor),
          ),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Icon(Icons.sort),
            ),
            Text(' Lọc'),
            _count == 0?Container(): Text(' ($_count)', style: TextStyle(color: Theme.of(context).primaryColor),),
          ],
        ),
      ),
    );
  }

  Widget _buildSort(BuildContext context) {
    ConfigProvider config = Provider.of(context);
    return DropdownButton<int>(
      value: config.sort,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 24,
      underline: Container(),
      onChanged: (newValue) {
        config.sort = newValue;
      },
      items: ProductRepository.instance.productSorts
          .map<DropdownMenuItem<int>>((sort) {
        return DropdownMenuItem<int>(
          value: sort.id,
          child: Text(sort.title),
        );
      }).toList(),
    );
  }

  showFilterPage(BuildContext context) {
    Navigator.pushNamed(context, '/filter-product');
  }
}
