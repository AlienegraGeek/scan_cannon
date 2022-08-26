import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cannon/scan/spec/scan_spec.dart';

import '../common/zee_dIalog.dart';
import 'custom_scan/custom_scan_logic.dart';

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
  final logic = Get.put(CustomScanLogic());

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
              ElevatedButton(
                onPressed: () async {
                  await logic.httpGetScanGood('6928804010114');
                  ZeeDialog().show('商品信息', '是的', '好的', 2, content(logic.goodData.value));
                },
                child: Text('点我测试'),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget content(GoodItem good) {
    return Column(
      children: [
        Text(good.goodsName!, style: TextStyle(color: Colors.white)),
        Text(good.price!, style: TextStyle(color: Colors.white)),
        Text(good.barcode, style: TextStyle(color: Colors.white)),
        Text(good.brand!, style: TextStyle(color: Colors.white)),
        Text(good.standard!, style: TextStyle(color: Colors.white)),
        Text(good.supplier!, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
