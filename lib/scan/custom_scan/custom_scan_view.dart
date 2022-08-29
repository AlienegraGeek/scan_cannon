import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/zee_dIalog.dart';
import '../app_barcode_scanner_widget.dart';
import '../spec/scan_spec.dart';
import 'custom_scan_logic.dart';

class CustomScanPage extends StatelessWidget {
  final logic = Get.put(CustomScanLogic());

  CustomScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描条形码'),
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () {
          //     logic.httpGetScanGood('6928804010114');
          //   },
          //   child: Text('点我测试'),
          // ),
          Expanded(
            flex: 4,
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) async {
                if(code.length == 13){
                  await logic.httpGetScanGood(code);
                  ZeeDialog().show('条形码', '是的', '好的', 2, content(logic.goodData.value));
                }else{
                  ZeeDialog().show('二维码', '是的', '好的', 2, Text(code));
                }
                // setState(() {
                //   _code = code;
                // });
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
