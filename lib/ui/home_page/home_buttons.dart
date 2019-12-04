import 'package:ann_shop_flutter/ui/home_page/rounded_button.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: ListView(
          scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: 15,),
          RoundedButton(title: 'Hàng\nmới về',icon: Icons.local_offer,onTap: (){

          },),
          RoundedButton(title: 'Hàng sale',icon: Icons.loyalty,onTap: (){

          },),
          RoundedButton(title: 'Quần áo\nnữ',icon: Icons.people_outline,onTap: (){

          },),
          RoundedButton(title: 'Quần áo\nnam',icon: Icons.people,onTap: (){

          },),
          RoundedButton(title: 'Nước hoa',icon: Icons.toys,onTap: (){

          },),
          RoundedButton(title: 'Bao\nlì xì',icon: Icons.style,onTap: (){

          },),
          SizedBox(width: 15,),
        ],
      ),
    );
  }

}
