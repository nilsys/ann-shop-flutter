import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  SomethingWentWrong({this.onReload, this.image});
  final onReload;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onReload,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: image == null
                  ? SizedBox(
                width: 80,
                height: 80,
                child:
                Image.asset('assets/images/ui/bullet_error.png'),
              )
                  : image,
            ),
            Text('Có lỗi xảy ra, chạm để thử lại...')
          ],
        ),
      ),
    );
  }
}
