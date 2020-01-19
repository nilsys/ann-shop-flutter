import 'dart:io';
import 'package:ann_shop_flutter/repository/coupon_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhoto extends StatefulWidget {
  @override
  _UploadPhotoState createState() {
    return _UploadPhotoState();
  }
}

class _UploadPhotoState extends State<UploadPhoto> {
  String latestBase64Image;
  File latestCaptureFile;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Đăng hình'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80,
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(13),
              color: Theme.of(context).primaryColor,
              onPressed: () => sendFeedBack(),
              child: Text('Gửi hình',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .merge(TextStyle(color: Colors.white))),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15),
          child: ListView(children: <Widget>[
            Container(
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: latestCaptureFile != null
                    ? _buildImage()
                    : _captureButton(),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: Image.file(
            latestCaptureFile,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 15),
          child: _captureAnotherPhotoButton(),
        )
      ],
    );
  }

  Widget _captureButton() {
    return FlatButton(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
      padding: EdgeInsets.all(7),
      onPressed: () {
        _getImage();
      },
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.camera_enhance,
            size: 50,
            color: Colors.grey[500],
          ),
          SizedBox(height: 10),
          Text(
            'Chọn hình ảnh từ thư viện',
            style: Theme.of(context).textTheme.subhead.merge(
                  TextStyle(color: Colors.grey[500]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _captureAnotherPhotoButton() {
    return RaisedButton(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      textColor: Theme.of(context).primaryColor,
      color: Colors.white,
      onPressed: () {
        _getImage();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.camera_enhance),
          SizedBox(width: 5),
          Text(
            'Chọn hình ảnh khác',
            style: Theme.of(context)
                .textTheme
                .button
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      latestCaptureFile = image;
    });
  }

  sendFeedBack() async {
    if (latestCaptureFile == null) {
      /// null
      return;
    }
    showLoading(context, message: 'Upload Image...');
    bool resultFeedback = await CouponRepository.instance.uploadRetailerDetail(
        base64Image: latestBase64Image, picture: latestCaptureFile);
    hideLoading(context);
    if (resultFeedback) {
      AppPopup.showComplexDialog(
        context,
        title: 'Đăng hình thành công',
        body:
            'Chúng tôi sẽ kiểm trả và thông báo cho bạn, Cảm ơn bạn đã ủng hộ ANN!',
        image: Icon(
          Icons.check_circle,
          size: 50,
          color: Theme.of(context).primaryColor,
        ),
        btnNormal: ButtonData(
            title: 'Hoàng thành',
            callback: () {
              Navigator.pop(context);
            }),
        btnHighlight: ButtonData(
          title: 'Xem danh sách ưu đãi',
          callback: () {
            Navigator.popAndPushNamed(context, '/coupon');
          },
        ),
      );
    } else {
      AppPopup.showComplexDialog(
        context,
        title: 'Đăng hình thất bại. Thử lại ngay?',
        image: Icon(
          Icons.error_outline,
          size: 50,
          color: Theme.of(context).primaryColor,
        ),
        btnNormal: ButtonData(title: 'Thử lại sau'),
        btnHighlight: ButtonData(
          title: 'Thử lại',
          callback: () {
            sendFeedBack();
          },
        ),
      );
    }
  }
}
