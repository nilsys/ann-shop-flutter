import 'dart:io';
import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/repository/coupon_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_popup.dart';
import 'package:ann_shop_flutter/ui/utility/progress_dialog.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đăng hình'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 10),
          child: RaisedButton(
            onPressed: latestCaptureFile != null ? sendFeedBack : null,
            child: Text('Gửi hình', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(15),
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
        Image.file(
          latestCaptureFile,
          fit: BoxFit.cover,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 15),
          child: _captureAnotherPhotoButton(),
        )
      ],
    );
  }

  Widget _captureButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(7),
      onPressed: _getImage,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.camera_enhance,
            size: 50,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 10),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      textColor: Theme.of(context).primaryColor,
      color: Colors.white,
      onPressed: _getImage,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.camera_enhance),
          const SizedBox(width: 5),
          Text(
            'Chọn hình ảnh khác',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  Future _getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      latestCaptureFile = image;
    });
  }

  Future sendFeedBack() async {
    if (latestCaptureFile == null) {
      /// null
      return;
    }
    showLoading(context, message: 'Upload Image...');
    final bool resultFeedback = await CouponRepository.instance
        .uploadRetailerDetail(
            base64Image: latestBase64Image, picture: latestCaptureFile);
    hideLoading(context);
    if (resultFeedback) {
      await AppPopup.showCustomDialog(
        context,
        content: [
          AvatarGlow(
            endRadius: 50,
            duration: const Duration(milliseconds: 1000),
            glowColor: Colors.green,
            child: Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
          ),
          Text(
            'Đăng hình thành công',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(height: 5),
          Text(
            'Chúng tôi sẽ kiểm trả và thông báo cho bạn, Cảm ơn bạn đã ủng hộ ANN!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1,
          ),
          const SizedBox(height: 15),
          CenterButtonPopup(
            highlight: ButtonData('Hoàng thành', onPressed: () {
              Navigator.popAndPushNamed(context, '/promotion');
            }),
          )
        ],
      );
    } else {
      await AppPopup.showCustomDialog(context, content: [
        AvatarGlow(
          endRadius: 50,
          duration: const Duration(milliseconds: 1000),
          glowColor: Colors.red,
          child: Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red,
          ),
        ),
        Text(
          'Đăng hình thất bại. Thử lại ngay?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
        CenterButtonPopup(
          normal: ButtonData('Để sau'),
          highlight: ButtonData('Thử lại', onPressed: sendFeedBack),
        )
      ]);
    }
  }
}
