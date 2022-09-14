import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试入口"),
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
                    child: Text("扫码测试"),
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
                        "/BluePlusPage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("蓝牙测试"),
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
                        "/UsbQuickPage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("USB输入/输出测试"),
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
                      getId();
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Android Id 测试"),
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
                        "/FloatWindowView",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("悬浮窗测试"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getId() async {
    const androidIdPlugin = AndroidId();
    final String? androidId = await androidIdPlugin.getId();
    print(androidId!);
    final snackBar = GetSnackBar(
      messageText: Text(androidId),
    );
    Get.showSnackbar(snackBar);
  }
}
