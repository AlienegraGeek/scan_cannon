import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ZeeDialog {
  //getBackNum 执行次数
  Future show(titleText, middleText, confirmText,int getBackNum,content) {
    return Get.defaultDialog(
      backgroundColor: Color(0xFF262626),
      // title: '设备离线',
      title: titleText,
      titleStyle: TextStyle(color: Color(0xFFDBDBDB), fontSize: 16, fontWeight: FontWeight.w500),
      titlePadding: EdgeInsets.only(top: 20),
      middleText: '设备离线中，请检查设备情况/上线情况',
      // middleText: middleText,
      middleTextStyle: TextStyle(color: Color(0xFFDBDBDB), fontSize: 14),
      barrierDismissible: false,
      radius: 10,
      content: content,
      confirm: GestureDetector(
        onTap: () {
          int i = 0;
          while(i < getBackNum){
            Get.back();
            i++;
          }
          // Get.back();
        }, //关闭弹框
        child: Container(
          height: 44,
          width: Get.width * 0.7,
          margin: EdgeInsets.only(right: 20, bottom: 16, left: 20),
          decoration: BoxDecoration(
            color: Color(0xFFFFD001),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Center(
            // child: Text('好的', style: TextStyle(color: Color(0xFF333333), fontSize: 16)),
            child: Text(confirmText, style: TextStyle(color: Color(0xFF333333), fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Future call(titleText, middleText, confirmText) {
    return Get.defaultDialog(
      backgroundColor: Color(0xFF262626),
      title: titleText,
      titleStyle: TextStyle(color: Color(0xFFDBDBDB), fontSize: 16, fontWeight: FontWeight.w500),
      titlePadding: EdgeInsets.only(top: 20),
      middleText: middleText,
      middleTextStyle: TextStyle(color: Color(0xFFBFBFBF), fontSize: 14),
      radius: 10,
      confirm: GestureDetector(
        onTap: () async {
          // 拨打电话
          await launchUrl(Uri(scheme: 'tel', path: middleText));
        }, //关闭弹框
        child: Container(
          height: 44,
          width: Get.width * 0.7,
          margin: EdgeInsets.only(right: 20, bottom: 16, left: 20),
          decoration: BoxDecoration(
            color: Color(0xFFFFD001),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Center(
            child: Text(confirmText, style: TextStyle(color: Color(0xFF333333), fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
