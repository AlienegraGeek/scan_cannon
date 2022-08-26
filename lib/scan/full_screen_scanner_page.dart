import 'package:flutter/material.dart';

import 'app_barcode_scanner_widget.dart';

///
/// FullScreenScannerPage
class FullScreenScannerPage extends StatefulWidget {
  @override
  _FullScreenScannerPageState createState() => _FullScreenScannerPageState();
}

class _FullScreenScannerPageState extends State<FullScreenScannerPage> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_code"),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) {
                setState(() {
                  _code = code;
                });
              },
              openManual: false,
            ),
          ),
        ],
      ),
    );
  }
}
