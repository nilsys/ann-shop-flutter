import 'package:ann_shop_flutter/provider/utility/inapp_provider.dart';
import 'package:ann_shop_flutter/repository/inapp_repository.dart';
import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InAppCategoryUI extends StatefulWidget {
  @override
  _InAppCategoryUIState createState() => _InAppCategoryUIState();
}

class _InAppCategoryUIState extends State<InAppCategoryUI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildCategoryItem('all'),
        _buildCategoryItem('promotion'),
        _buildCategoryItem('notification'),
        _buildCategoryItem('news'),
      ],
    );
  }

  Widget _buildCategoryItem(String name) {
    InAppProvider provider = Provider.of<InAppProvider>(context);

    bool hasNew = false;

    bool isChoose = name == provider.currentCategory;
    Color chooseColor = Colors.white;
    Color unChooseColor = Colors.grey[300];
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isChoose ? chooseColor : unChooseColor,
        border: Border(
            left: isChoose
                ? BorderSide(width: 3, color: Theme.of(context).primaryColor)
                : BorderSide(width: 1, color: unChooseColor),
            bottom: BorderSide(width: 1, color: Colors.grey[600])),
      ),
      child: Stack(
        children: <Widget>[
          hasNew
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        )),
                  ),
                )
              : Container(),
          IconButton(
            onPressed: () {
              setState(() {
                provider.currentCategory = name;
              });
            },
            icon: Icon(
              InAppRepository.instance.getIconInApp(name),
              color: AppStyles.dartIcon,
            ),
          ),
        ],
      ),
    );
  }
}
