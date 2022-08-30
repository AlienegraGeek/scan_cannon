import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("1D barcode/QR code"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      //跳转页面=扫描二维码
                      Get.toNamed(
                        "/SelectScannerStylePage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Scan 1D barcode/QR code"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      //跳转页面=生成二维码
                      Get.toNamed(
                        "/CreatorPage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Create QR code"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Get.toNamed(
                        "/UsbSerialPage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("USB Test"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
