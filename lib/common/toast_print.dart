import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastPrint {
  static show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 12.0,
    );
  }
}
