import 'package:flutter/material.dart';

class ButtonFavorite extends StatelessWidget {
  ButtonFavorite({this.color});
  final color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite, color: color,),
    );
  }
}
