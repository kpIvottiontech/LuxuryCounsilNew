import 'package:flutter/material.dart';
import 'package:webview_flutter/src/webview_flutter_legacy.dart';
class WebViewContainer extends StatefulWidget {
  final url;
  WebViewContainer(this.url);
  @override
  createState() => _WebViewContainerState(this.url);
}
class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  _WebViewContainerState(this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child:WebView(
    initialUrl: 'https://medium.com'
))
          ],
        ));
  }
}
