import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRouter extends StatefulWidget {
  WebViewRouter(var data) {
    if (data is Map) {
      Map map = data;
      url = map['url'];
      title = map['title'] ?? url;
    } else {
      String text = data as String;
      url = text;
      title = text;
    }
  }

  String url;
  String title;

  @override
  _WebViewRouterState createState() => _WebViewRouterState();
}

class _WebViewRouterState extends State<WebViewRouter> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/web-view',
                  arguments: widget.url);
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
      ),
    );
  }

  _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'xuongann',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}
