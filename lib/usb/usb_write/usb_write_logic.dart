import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_write/flutter_usb_write.dart';
import 'package:get/get.dart';

class UsbWriteLogic extends GetxController {
  final FlutterUsbWrite flutterUsbWrite = FlutterUsbWrite();
  UsbEvent lastEvent = UsbEvent();
  late StreamSubscription<UsbEvent> usbStateSubscription;
  List<UsbDevice> devices = [];
  final connectedDeviceId = 0.obs;
  final textController = TextEditingController(text: "Hello world");

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool didInit = false;

  @override
  void onInit() {
    super.onInit();
    createUsbListener();
  }

  @override
  void onClose() {
    super.onClose();
    usbStateSubscription.cancel();
  }

  Future didChangeDependencies() async {
    if (!didInit) {
      didInit = true;
      await _getPorts();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> createUsbListener() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    usbStateSubscription = flutterUsbWrite.usbEventStream.listen((UsbEvent event) async {
      lastEvent = event;
      update();
      await _getPorts();
      if (event.event.endsWith("USB_DEVICE_DETACHED")) {
        //check if connected device was detached
        if (event.device.deviceId == connectedDeviceId.value) {
          unawaited(disconnect());
        }
      }
    });
    update();
  }

  Future _getPorts() async {
    try {
      List<UsbDevice> deviceList = await flutterUsbWrite.listDevices();
      devices = deviceList;
      update();
    } on PlatformException catch (e) {
      showSnackBar(e.message.toString());
    }
  }

  Future<UsbDevice?> connect(UsbDevice device) async {
    try {
      var result = await flutterUsbWrite.open(
        vendorId: device.vid,
        productId: device.pid,
      );
      connectedDeviceId.value = result.deviceId;
      return result;
    } on PermissionException {
      showSnackBar("Not allowed to do that");
      return null;
    } on PlatformException catch (e) {
      showSnackBar(e.message.toString());
      return null;
    }
  }

  Future disconnect() async {
    try {
      await flutterUsbWrite.close();
      connectedDeviceId.value = 0;
    } on PlatformException catch (e) {
      showSnackBar(e.message.toString());
    }
  }

  void showSnackBar(String message) {
    final snackBar = GetSnackBar(
      messageText: Text(message),
    );
    // _scaffoldKey.currentState?.showSnackBar(snackBar);
    Get.showSnackbar(snackBar);
  }
}
