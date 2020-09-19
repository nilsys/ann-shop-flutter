import 'package:ping9/ping9.dart';
import 'package:ann_shop_flutter/provider/favorite/favorite_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  FavoriteButton({this.color});

  final color;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider provider = Provider.of(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'user/favorite');
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite,
              color: color,
            ),
            isNullOrEmpty(provider.products)
                ? Container()
                : Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    child: Container(
                      width: provider.products.length < 10 ? 14 : 18,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        provider.products.length < 10
                            ? provider.products.length.toString()
                            : '9+',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
