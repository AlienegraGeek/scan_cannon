import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
/// SelectScannerStylePage
class SelectScannerStylePage extends StatefulWidget {
  const SelectScannerStylePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectScannerStyleState();
  }
}

///
/// _SelectScannerStyleState
class _SelectScannerStyleState extends State<SelectScannerStylePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Scanner Style"),
      ),
      body: Row(
        children: <Widget>[
          Spacer(),
          Column(
            children: <Widget>[
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/FullScreenScannerPage");
                },
                child: Text("FullScreen Style"),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/CustomSizeScannerPage");
                },
                child: Text("CustomSize Style"),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
