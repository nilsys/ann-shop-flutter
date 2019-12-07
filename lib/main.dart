import 'package:ann_shop_flutter/core/router.dart';
import 'package:ann_shop_flutter/provider/product/category_product_provider.dart';
import 'package:ann_shop_flutter/provider/product/product_provider.dart';
import 'package:ann_shop_flutter/provider/utility/navigation_provider.dart';
import 'package:ann_shop_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
      .copyWith(statusBarIconBrightness: Brightness.light));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

//  ErrorWidget.builder = (FlutterErrorDetails details) => Container(
//    alignment: Alignment.center,
//    child: Icon(Icons.error),
//  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: NavigationProvider()),
        ChangeNotifierProvider.value(value: CategoryProductProvider()),
        ChangeNotifierProvider.value(value: ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: MyApp.navKey,
        title: 'ANN App',
        theme: primaryTheme(),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
