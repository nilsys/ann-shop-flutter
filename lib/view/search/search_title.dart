import 'package:ann_shop_flutter/core/app_icons.dart';
import 'package:flutter/material.dart';

class SearchTitle extends StatelessWidget {

  SearchTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamedAndRemoveUntil(context, '/search', ModalRoute.withName('/'));
      },
      child: Container(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(AppIcons.search, color: Colors.black87,),
            SizedBox(width: 15,),
            Text(text??'Bạn tìm gì hôm nay?', style: Theme.of(context).textTheme.body1,),
          ],
        ),
      ),
    );
  }
}
