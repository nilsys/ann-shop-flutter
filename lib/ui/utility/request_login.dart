import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';

class RequestLogin extends StatelessWidget {
  RequestLogin({this.message = K.needLoginToContinue});

  final message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Đăng nhập',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .merge(TextStyle(color: Colors.white)),
                  ),
                  onPressed: () {
                    _onLogIn(context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Bạn chưa có tài khoản ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  InkWell(
                    onTap: () {
                      _onLogIn(context);
                    },
                    child: Text(
                      'Đăng ký ngay.',
                      style: Theme.of(context).textTheme.button.merge(
                            TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onLogIn(context) {
    Navigator.pushNamed(context, 'user/login');
  }
}
