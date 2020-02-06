import 'dart:async';

import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/model/product/category.dart';
import 'package:ann_shop_flutter/model/product/product_filter.dart';
import 'package:ann_shop_flutter/provider/utility/search_provider.dart';
import 'package:ann_shop_flutter/ui/utility/ui_manager.dart';
import 'package:ann_shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarcodeScanView extends StatefulWidget {
  @override
  _BarcodeScanViewState createState() => new _BarcodeScanViewState();
}

class _BarcodeScanViewState extends State<BarcodeScanView>
    with SingleTickerProviderStateMixin {
  QRViewController controllerQR;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool flashOn = false;
  bool bottomSheetIsOpen = false;

  AnimationController animationController;
  Animation<double> animation;
  double redLineTop = 150;
  int offset = 50;
  double squareSize = 270;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation =
        Tween<double>(begin: (-squareSize / 2 + 20), end: squareSize / 2 - 20)
            .animate(animationController);

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    controllerQR?.dispose();
    super.dispose();
  }

  _openResultView(dynamic value) async {
//    var products = await ListProductRepository.instance.loadBySku(value);
//    if (Utility.isNullOrEmpty(products) == false) {
//      if (products.length == 1) {
//        await Router.showProductDetail(context, product: products[0]);
//      } else {
//        await ListProduct.showByCategory(context,
//            Category(name: value, filter: ProductFilter(productSKU: value)),
//            initData: products, showSearch: true);
//      }
//    } else {
//      AppSnackBar.showFlushbar(context, 'Không tìm thấy sản phẩm $value');
//      await Future.delayed(Duration(milliseconds: 500));
//    }
    await ListProduct.showByCategory(context,
        Category(name: value, filter: ProductFilter(productSKU: value)),
        initData: null, showSearch: true);
    print('Back to scan');
    try {
      await Future.delayed(Duration(milliseconds: 100));
      controllerQR.resumeCamera();
    } catch (e) {
      print(e);
    }
  }

  scanResponse(value) {
    print('scanResponse: $value');
    if (!bottomSheetIsOpen) {
      flashOn = false;
      controllerQR.pauseCamera();
      _openResultView(value);
      Provider.of<SearchProvider>(context, listen: false).addHistory(value);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    if (this.controllerQR == null) {
      this.controllerQR = controller;
      controller.scannedDataStream.listen(scanResponse);
    }
  }

  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool hasKeyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    List<Widget> _children = [
      QRView(
        key: _qrKey,
        onQRViewCreated: _onQRViewCreated,
      )
    ];
    if (hasKeyboard == false) {
      _children.addAll([
        Align(
          alignment: Alignment.center,
          child: Container(
            width: squareSize,
            height: squareSize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                  style: BorderStyle.solid,
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
                    color: Colors.redAccent,
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
      ]);
    }
    _children.add(Positioned(
      top: 30,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: UIManager.btnClose(
              onPressed: () {
                if(flashOn){
                  _turnFlash();
                }
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Quét mã vạch sản phẩm',
                style: TextStyle(color: Colors.white, fontSize: 18),
                maxLines: 1,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _turnFlash(),
            icon: Icon(
              flashOn ? Icons.flash_off : Icons.flash_on,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ));
    if (hasKeyboard == false) {
      _children.add(Positioned(
        bottom: (size.height - squareSize) / 4,
        width: size.width,
        child: InkWell(
          onTap: _showInputCode,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Nhập mã vạch bằng tay',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Icon(
                    Icons.keyboard_backspace,
                    textDirection: TextDirection.rtl,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        overflow: Overflow.clip,
        fit: StackFit.loose,
        children: _children,
      ),
    );
    // );
  }

  _showInputCode() {
    bottomSheetIsOpen = true;
    controllerQR.pauseCamera();
    persistentBottomSheetController().closed.then(_closeBottomSheet);
  }

  String _valueInput;

  _closeBottomSheet(value) {
    bottomSheetIsOpen = false;
    if (Utility.isNullOrEmpty(_valueInput)) {
      if (controllerQR != null) controllerQR.resumeCamera();
    } else {
      _openResultView(_valueInput);
    }
  }

  final _barcodeTextController = TextEditingController();

  PersistentBottomSheetController persistentBottomSheetController() {
    _barcodeTextController.text = "";
    _valueInput = '';
    return _scaffoldKey.currentState.showBottomSheet(
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
                        onFieldSubmitted: (value) {
                          _valueInput = _barcodeTextController.text;
                          Navigator.pop(context);
                        },
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
                          _valueInput = _barcodeTextController.text;
                          Navigator.pop(context);
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

  _turnFlash() async {
    controllerQR.toggleFlash();
    setState(() {
      flashOn = !flashOn;
    });
  }
}
