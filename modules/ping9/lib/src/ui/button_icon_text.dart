import 'package:flutter/material.dart';
import 'package:ping9/src/theme/app_styles.dart';

class ButtonIconText extends StatelessWidget {
  const ButtonIconText(this.title, this.icon, {this.onPressed});

  final VoidCallback onPressed;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 11.0),
            Icon(
              icon,
              color: AppStyles.dartIcon,
              size: 20,
            ),
            SizedBox(height: 5.0),
            Text(
              title,
              maxLines: 1,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.0),
          ],
        ),
      ),
    );
  }
}
