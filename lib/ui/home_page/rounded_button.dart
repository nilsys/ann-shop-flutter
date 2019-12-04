import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  RoundedButton({this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    var _color = Theme.of(context).primaryColor.withAlpha(150);
    return Container(
      height: 100,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: _color),
                color: _color,
              ),
              child: Icon(
                this.icon,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          Text(
            this.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
