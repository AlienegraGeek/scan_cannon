import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_write/flutter_usb_write.dart';
import 'package:get/get.dart';

class UsbWriteLogic extends GetxController {
  final FlutterUsbWrite _flutterUsbWrite = FlutterUsbWrite();
  UsbEvent _lastEvent = UsbEvent();
  late StreamSubscription<UsbEvent> _usbStateSubscription;
  List<UsbDevice> _devices = [];
  final _connectedDeviceId = 0.obs;
  final _textController = TextEditingController(text: "Hello world");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool didInit = false;

  @override
  void onInit() {
    super.onInit();
    createUsbListener();
  }

  @override
  void onClose() {
    super.onClose();
    _usbStateSubscription.cancel();
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

    _usbStateSubscription = _flutterUsbWrite.usbEventStream.listen((UsbEvent event) async {
      _lastEvent = event;
      update();
      await _getPorts();
      if (event.event.endsWith("USB_DEVICE_DETACHED")) {
        //check if connected device was detached
        if (event.device.deviceId == _connectedDeviceId.value) {
          unawaited(_disconnect());
        }
      }
    });
    update();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('USB Device Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(_devices.isNotEmpty ? "Available USB Devices" : "No USB devices available", style: Theme.of(context).textTheme.titleMedium),
              ),
              ..._portList(),
              getInputTextBox(),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: getEventInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getEventInfo() {
    if (_lastEvent.event == '' || _lastEvent.event == null) return SizedBox.shrink();
    if (_lastEvent.event.endsWith('USB_DEVICE_ATTACHED')) {
      return Text(
        '${_lastEvent.device.manufacturerName} ATTACHED',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Text(
      '${_lastEvent.device.manufacturerName} DETACHED',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getInputTextBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: ListTile(
        title: TextField(
          controller: _textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Text To Send',
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            String data = "${_textController.text}\r\n";
            await _flutterUsbWrite.write(Uint8List.fromList(data.codeUnits));
          },
          child: Text("Send"),
        ),
      ),
    );
  }

  Future _getPorts() async {
    try {
      List<UsbDevice> devices = await _flutterUsbWrite.listDevices();
      _devices = devices;
      update();
    } on PlatformException catch (e) {
      showSnackBar(e.message.toString());
    }
  }

  List<Widget> _portList() {
    List<Widget> ports = [];
    for (var device in _devices) {
      ports.add(
        ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: ElevatedButton(
            child: Text(_connectedDeviceId.value == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () async {
              if (_connectedDeviceId.value == device.deviceId) {
                await _disconnect();
              } else {
                await _connect(device);
              }
            },
          ),
        ),
      );
    }
    if (ports.isEmpty) {
      ports.add(SizedBox.shrink());
    }
    return ports;
  }

  Future<UsbDevice?> _connect(UsbDevice device) async {
    try {
      var result = await _flutterUsbWrite.open(
        vendorId: device.vid,
        productId: device.pid,
      );
      _connectedDeviceId.value = result.deviceId;
      return result;
    } on PermissionException {
      showSnackBar("Not allowed to do that");
      return null;
    } on PlatformException catch (e) {
      showSnackBar(e.message.toString());
      return null;
    }
  }

  Future _disconnect() async {
    try {
      await _flutterUsbWrite.close();
      _connectedDeviceId.value = 0;
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
