import 'dart:async';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/router.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/repository/list_product_repository.dart';
import 'package:ann_shop_flutter/ui/utility/app_snackbar.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => new _ScanViewState();
}

class _ScanViewState extends State<ScanView>
    with SingleTickerProviderStateMixin {
  List<CameraDescription> cameras;
  QRReaderController controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AnimationController animationController;
  Animation<double> animation;

  final _barcodeTextController = TextEditingController();
  var bottomSheetController;

  bool flashOn = false;
  bool bottomSheetIsOpen = true;
  double redLineTop = 150;
  int offset = 50;
  double squareSize = 270;

  Future<Null> loadCamera() async {
    try {
      cameras = await availableCameras();
    } on QRReaderException catch (e) {}
    initCameraView();
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController.dispose();
    super.dispose();
  }

  WidgetsBindingObserver tempResumeCallback;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      bottomSheetIsOpen = false;
      loadCamera();
    });

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation =
        Tween<double>(begin: (-squareSize / 2 + 20), end: squareSize / 2 - 20)
            .animate(animationController)
              ..addListener(() {
                setState(() {});
              });

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  _openResultView(dynamic value) async {
    if (controller != null) {
      flashOn = false;
      controller.dispose();
    }
    var products = await ListProductRepository.instance.loadBySku(value);
    if (Utility.isNullOrEmpty(products) == false) {
      if (products.length == 1) {
        await Router.showProductDetail(context, product: products[0]);
      } else {
        await ListProduct.showByCategory(context,
            Category(name: value, filter: ProductFilter(productSKU: value)),
            initData: products, showSearch: true);
      }
    } else {
      AppSnackBar.showFlushbar(context, 'Không tìm thấy sản phẩm $value');
      await Future.delayed(Duration(milliseconds: 500));
    }
    bottomSheetIsOpen = false;
    initCameraView();
  }

  initCameraView() {
    if (bottomSheetIsOpen == false) {
      controller = new QRReaderController(cameras[0], ResolutionPreset.high, [
        CodeFormat.code128,
//      CodeFormat.code39,
//      CodeFormat.codabar,
//      CodeFormat.upca,
//      CodeFormat.ean13,
//      CodeFormat.upce,
//      CodeFormat.ean8
      ], (dynamic value) {
        print('Show camera.Then $value');
        flashOn = false;
        controller.stopScanning();
        if (!bottomSheetIsOpen) {
          _openResultView(value);
        }
      });

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        controller.startScanning();

        setState(() {
          redLineTop = 320;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / (size.height);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        overflow: Overflow.clip,
        fit: StackFit.loose,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Transform.scale(
                      scale:
                          (controller != null && controller.value.isInitialized)
                              ? deviceRatio > controller.value.aspectRatio
                                  ? deviceRatio / controller.value.aspectRatio
                                  : controller.value.aspectRatio / deviceRatio
                              : 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: _cameraPreviewWidget(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 38,
            left: 10,
            child: UIManager.btnClose(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () => _turnFlash(),
                icon: Icon(
                  flashOn ? Icons.flash_off : Icons.flash_on,
                  size: 30,
                  color: Colors.white,
                )),
          ),
          // Change Store
          Positioned(
            top: 37,
            width: size.width,
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: _showInputCode,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  decoration: BoxDecoration(
                    border: new Border.all(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.keyboard,
                        color: Colors.white,
                      ),
                      Text(
                        '  Nhập mã bằng tay',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                squareSize / 2 -
                offset +
                50,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  height: squareSize,
                  width: squareSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.white, width: 2.0),
                  )),
            ),
          ),

          Align(
              alignment: Alignment.center,
              child: Container(
                child: AnimatedBuilder(
                  animation: animationController,
                  child: SizedBox(
                    width: 170,
                    child: Container(
                      height: 1,
                      color: controller != null
                          ? controller.value != null
                              ? controller.value.isScanning
                                  ? Colors.redAccent
                                  : Colors.transparent
                              : Colors.transparent
                          : Colors.transparent,
                    ),
                  ),
                  builder: (BuildContext context, Widget _widget) {
                    return new Transform.translate(
                      offset: Offset(0, animation.value),
                      // animationController.value * -0.5,
                      child: _widget,
                    );
                  },
                ),
              )),
        ],
      ),
    );
    // );
  }

  _showInputCode() {
    setState(() {
      bottomSheetIsOpen = true;
    });
    persistentBottomSheetController();
    bottomSheetController.closed.then((value) {
      setState(() {
        bottomSheetIsOpen = false;
      });

      if (controller != null && controller.value.isInitialized)
        controller.startScanning();
    });
  }

  PersistentBottomSheetController persistentBottomSheetController() {
    _barcodeTextController.text = "";
    return bottomSheetController = _scaffoldKey.currentState.showBottomSheet(
      (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 24),
                    Text(
                      'Nhập mã sản phẩm',
                      style: Theme.of(context).textTheme.title,
                    ),
                    CloseButton(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeTextController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã sản phẩm',
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                  style: BorderStyle.solid)),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          controller.dispose();
                          controller = null;
                          Navigator.pop(context);
                          _openResultView(_barcodeTextController.text);
                        },
                        icon: Icon(
                          Icons.keyboard_backspace,
                          textDirection: TextDirection.rtl,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    } else {
      return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new QRReaderPreview(controller),
      );
    }
  }

  _turnFlash() async {
    controller.toggleFlash();
    controller.startScanning();
    setState(() {
      flashOn = !flashOn;
    });
  }
}
