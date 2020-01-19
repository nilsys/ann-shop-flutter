import 'package:ann_shop_flutter/core/core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformBeforeRate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 30,
                ),
                Text(
                  'Đánh giá ứng dụng',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.title,
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Nhận ưu đãi khi đánh giá ANN app trên store',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Đánh giá ngay',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .merge(TextStyle(color: Colors.white)),
                ),
                onPressed: () {
                  _onRateApp(context);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  'Bạn đã đánh giá ',
                  style: Theme.of(context).textTheme.body1,
                ),
                InkWell(
                  onTap: () {
                    _onUpload(context);
                  },
                  child: Text(
                    'Đăng hình chụp đánh giá của bạn.',
                    style: Theme.of(context).textTheme.button.merge(
                          TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor),
                        ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _onUpload(context) {
    Navigator.popAndPushNamed(context, '/upload_photo');
  }

  _onRateApp(context) {
    launch(Core.urlStoreReview);
  }
}
