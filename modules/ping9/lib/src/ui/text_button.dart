import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  MyTextButton(this.title, {this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 0),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
            color: Theme
                .of(context)
                .primaryColor,
            decoration: TextDecoration.underline),
      ),
    );
  }
}
