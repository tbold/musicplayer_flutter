import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatelessWidget {
  final String html;
  WebView({required this.html, super.key});

  @override
  Widget build(BuildContext context) {
    final WebViewController webViewController;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.dataFromString('''<html>
            <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
            <body>$html</body></html>''', mimeType: 'text/html'),
      );

    return Container(
      height: 300,
      child: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}
