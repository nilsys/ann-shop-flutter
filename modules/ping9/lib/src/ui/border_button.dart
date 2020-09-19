import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({this.child, this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: DefaultTextStyle(
          style: Theme.of(context).textTheme.button.merge(
                TextStyle(color: Theme.of(context).primaryColor),
              ),
          child: child),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor
      ),
      onPressed: onPressed,
    );
  }
}
