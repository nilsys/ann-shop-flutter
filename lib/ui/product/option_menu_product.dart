import 'package:ann_shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';

class OptionMenuProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      icon: Icon(
        Icons.sort,
        color: AppStyles.dartIcon,
      ),
      onSelected: _onClickItem,
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.home,
          child: _buildMenuItem(Icons.home, 'Trở về trang chủ'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.category,
          child: _buildMenuItem(Icons.view_module, 'Danh mục sản phẩm'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.account,
          child: _buildMenuItem(Icons.account_box, 'Cá nhân'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.favorite,
          child: _buildMenuItem(Icons.favorite, 'Yêu thích'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.share,
          child: _buildMenuItem(Icons.share, 'Chia sẻ'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.download,
          child: _buildMenuItem(Icons.cloud_download, 'Tải hình về máy'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.copy,
          child: _buildMenuItem(Icons.content_copy, 'Copy thông tin SP'),
        ),
      ],
    );
  }

  _buildMenuItem(icon, name) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: AppStyles.dartIcon,
        ),
        SizedBox(width: 10,),
        Text(name),
      ],
    );
  }

  _onClickItem(value) {
    switch (value) {
      case MenuOptions.home:
        break;
      case MenuOptions.category:
        break;
      case MenuOptions.account:
        break;
      case MenuOptions.favorite:
        break;
      case MenuOptions.share:
        break;
      case MenuOptions.download:
        break;
      case MenuOptions.download:
        break;
      case MenuOptions.copy:
        break;
    }
  }
}

enum MenuOptions {
  home,
  category,
  account,
  favorite,
  share,
  download,
  copy,
}
