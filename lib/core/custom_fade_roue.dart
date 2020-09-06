import 'package:flutter/material.dart';

class CustomFadeRoute<T> extends MaterialPageRoute<T> {
  CustomFadeRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}