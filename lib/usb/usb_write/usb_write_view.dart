import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'usb_write_logic.dart';

class UsbWritePage extends StatelessWidget {
  final logic = Get.put(UsbWriteLogic());

  UsbWritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('USB Device Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(logic.devices.isNotEmpty ? "Available USB Devices" : "No USB devices available", style: Theme.of(context).textTheme.titleMedium),
              ),
              ...portList(),
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

  Widget getInputTextBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: ListTile(
        title: TextField(
          controller: logic.textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Text To Send',
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            String data = "${logic.textController.text}\r\n";
            await logic.flutterUsbWrite.write(Uint8List.fromList(data.codeUnits));
          },
          child: Text("Send"),
        ),
      ),
    );
  }

  Widget getEventInfo() {
    if (logic.lastEvent.event == '' || logic.lastEvent.event == null) return SizedBox.shrink();
    if (logic.lastEvent.event.endsWith('USB_DEVICE_ATTACHED')) {
      return Text(
        '${logic.lastEvent.device.manufacturerName} ATTACHED',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Text(
      '${logic.lastEvent.device.manufacturerName} DETACHED',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> portList() {
    List<Widget> ports = [];
    for (var device in logic.devices) {
      ports.add(
        ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: ElevatedButton(
            child: Text(logic.connectedDeviceId.value == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () async {
              if (logic.connectedDeviceId.value == device.deviceId) {
                await logic.disconnect();
              } else {
                await logic.connect(device);
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
}
