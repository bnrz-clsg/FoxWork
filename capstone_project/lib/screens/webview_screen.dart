import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForecastScrreen extends StatefulWidget {
  @override
  _ForecastScrreenState createState() => _ForecastScrreenState();
}

class _ForecastScrreenState extends State<ForecastScrreen> {
  set controller(WebViewController controller) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: WebView(
      initialUrl: 'https://monitoring-dashboard.ndrrmc.gov.ph/',
      onWebViewCreated: (controller) {
        this.controller = controller;
      },
    )));
  }
}
