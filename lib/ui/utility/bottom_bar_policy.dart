import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class BottomBarPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: TextButton(
          'Chính sách và điều khoản của ANN',
          onPressed: () {
            Navigator.pushNamed(context, 'shop/policy');
          },
        ),
      ),
    );
  }
}
