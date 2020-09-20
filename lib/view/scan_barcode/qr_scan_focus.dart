import 'package:ann_shop_flutter/view/scan_barcode/qr_scanner_overlay_shape.dart';
import 'package:flutter/material.dart';

class QRScanFocus extends StatefulWidget {
  const QRScanFocus({this.size});

  final double size;

  @override
  _QRScanFocusState createState() => _QRScanFocusState();
}

class _QRScanFocusState extends State<QRScanFocus>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0.1, end: 0.9).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.addStatusListener((status) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.white,
                cutOutSize: widget.size,
              ),
            ),
          ),
          Container(
            child: AnimatedBuilder(
              animation: animationController,
              child: SizedBox(
                width: widget.size,
                child: Container(
                  height: 1,
                  color: Colors.redAccent,
                ),
              ),
              builder: (BuildContext context, Widget _widget) {
                return Transform.translate(
                  offset: Offset(0, animation.value * widget.size),
                  child: _widget,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
