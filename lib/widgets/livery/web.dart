import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:transportia/api/bt_livery.dart';

class LiveryView extends StatefulWidget {
  final ApiBtLivery livery;
  final double size;

  const LiveryView({super.key, required this.livery, this.size = 24});

  @override
  State<LiveryView> createState() => _LiveryViewState();
}

class _LiveryViewState extends State<LiveryView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  @override
  void didUpdateWidget(covariant LiveryView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.livery.leftCss != widget.livery.leftCss ||
        oldWidget.size != widget.size) {
      _loadHtml();
    }
  }

  void _loadHtml() {
    final width = widget.size;
    final height = width * 16 / 24;

    controller = WebViewController()
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport"
                  content="width=device-width, initial-scale=1">
            <style>
              html, body {
                margin: 0;
                padding: 0;
                width: ${width}px;
                height: ${height}px;
                overflow: hidden;
              }
            </style>
          </head>
          <body>
            <div style="
              width: ${width}px;
              height: ${height}px;
              background: ${widget.livery.leftCss};
            "></div>
          </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.size;
    final height = width * 16 / 24;

    return SizedBox(
      width: width,
      height: height,
      child: IgnorePointer(child: WebViewWidget(controller: controller)),
    );
  }
}
