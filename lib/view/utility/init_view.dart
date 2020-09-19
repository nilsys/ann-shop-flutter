import 'package:ann_shop_flutter/model/account/ac.dart';
import 'package:ann_shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:ann_shop_flutter/provider/utility/cover_provider.dart';
import 'package:flutter/material.dart';
import 'package:ping9/ping9.dart';
import 'package:provider/provider.dart';

class InitView extends StatefulWidget {
  @override
  _InitViewState createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Container(
              height: 70,
              width: 200,
              child: Image.asset(
                'assets/images/ui/ann.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Indicator(),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAccountInfo();
    CopyController.instance.loadCopySetting();
  }

  Future checkAccountInfo() async {
    await AC.instance.loadFormLocale();
    if (AC.instance.isLogin == false) {
      goToLogin();
      return;
    }
    CoverProvider provider = Provider.of(context, listen: false);
    await provider.loadPostHome();
    if (provider.postsHome.isCompleted) {
      goToHome();
    } else {
      goToLogin();
    }
  }

  void goToLogin() {
    Navigator.pushReplacementNamed(context, 'user/login');
  }

  void goToHome() {
    Navigator.pushReplacementNamed(context, 'home');
  }
}
