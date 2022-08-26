import 'package:flutter/material.dart';

import 'app_barcode_scanner_widget.dart';

///
/// CustomSizeScannerPage
class CustomSizeScannerPage extends StatefulWidget {
  @override
  _CustomSizeScannerPageState createState() => _CustomSizeScannerPageState();
}

class _CustomSizeScannerPageState extends State<CustomSizeScannerPage> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_code),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) {
                setState(() {
                  _code = code;
                });
              },
              openManual: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
