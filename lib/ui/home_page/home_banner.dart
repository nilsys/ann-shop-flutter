import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: Stack(children: [
        Container(color: Colors.white,margin: EdgeInsets.only(top: 80),),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            border: new Border.all(
              color: Color(0xFFEDEDED),
              width: 1,
              style: BorderStyle.solid,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withAlpha(70),
                offset: Offset(1.0, 4.0),
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
      ]),
    );
  }
}
