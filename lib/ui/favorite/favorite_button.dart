import 'package:ann_shop_flutter/core/utility.dart';
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
        Navigator.pushNamed(context, '/favorite');
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
            Utility.isNullOrEmpty(provider.products)
                ? Container()
                : Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        provider.products.length.toString(),
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
