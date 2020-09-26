import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRouter extends StatefulWidget {
  final WebViewQueryParameterModel queryParameters;

  const WebViewRouter({Key key, this.queryParameters}) : super(key: key);

  @override
  _WebViewRouterState createState() => _WebViewRouterState();
}

class _WebViewRouterState extends State<WebViewRouter> {
  WebViewController _webViewController;
  String _title;

  @override
  void initState() {

    super.initState();

    _title = 'Đang tải...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushNamed(context, 'page/browser',
                  arguments: widget.queryParameters.toJson());
            },
          ),
        ],
      ),
      body: initWebView(context),
    );
  }

  WebView initWebView(BuildContext context) {
    return new WebView(
      initialUrl: widget.queryParameters.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _webViewController.clearCache();
      },
      javascriptChannels: <JavascriptChannel>[
        _toasterJavascriptChannel(context),
      ].toSet(),
      onPageFinished: (url) {
        setState(() {
          _webViewController.getTitle().then((String value) => _title = value);
        });
      },
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}

class WebViewQueryParameterModel {
  final String url;

  const WebViewQueryParameterModel(this.url);

  WebViewQueryParameterModel.fromJson(Map<String, dynamic> json)
      : url = json['url'];

  Map<String, dynamic> toJson() => {'url': url};
}
