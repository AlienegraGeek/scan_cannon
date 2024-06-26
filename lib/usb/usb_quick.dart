import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:quick_usb/quick_usb.dart';

class UsbQuick extends StatefulWidget {
  UsbQuick({Key? key}) : super(key: key);

  @override
  _UsbQuickState createState() => _UsbQuickState();
}

class _UsbQuickState extends State<UsbQuick> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildColumn(),
    );
  }

  void log(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info)));
  }

  Widget _buildColumn() {
    return Column(
      children: [
        _init_exit(),
        _getDeviceList(),
        // _getDevicesWithDescription(),
        // _getDeviceDescription(),
        // _has_request(),
        // _open_close(),
        // _get_set_configuration(),
        // _claim_release_interface(),
        _bulk_transfer(),
      ],
    );
  }

  Widget _init_exit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('init'),
          onPressed: () async {
            var init = await QuickUsb.init();
            log('init $init');
          },
        ),
        ElevatedButton(
          child: const Text('exit'),
          onPressed: () async {
            await QuickUsb.exit();
            log('exit');
          },
        ),
      ],
    );
  }

  List<UsbDevice>? _deviceList;

  Widget _getDeviceList() {
    return ElevatedButton(
      child: const Text('getDeviceList'),
      onPressed: () async {
        _deviceList = await QuickUsb.getDeviceList();
        log('deviceList $_deviceList');
      },
    );
  }

  Widget _has_request() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('hasPermission'),
          onPressed: () async {
            var hasPermission = await QuickUsb.hasPermission(_deviceList!.first);
            log('hasPermission $hasPermission');
          },
        ),
        ElevatedButton(
          child: const Text('requestPermission'),
          onPressed: () async {
            await QuickUsb.requestPermission(_deviceList!.first);
            log('requestPermission');
          },
        ),
      ],
    );
  }

  Widget _open_close() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('openDevice'),
          onPressed: () async {
            var openDevice = await QuickUsb.openDevice(_deviceList!.first);
            log('openDevice $openDevice');
          },
        ),
        ElevatedButton(
          child: const Text('closeDevice'),
          onPressed: () async {
            await QuickUsb.closeDevice();
            log('closeDevice');
          },
        ),
      ],
    );
  }

  UsbConfiguration? _configuration;

  Widget _get_set_configuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('getConfiguration'),
          onPressed: () async {
            _configuration = await QuickUsb.getConfiguration(0);
            log('getConfiguration $_configuration');
          },
        ),
        ElevatedButton(
          child: const Text('setConfiguration'),
          onPressed: () async {
            var setConfiguration = await QuickUsb.setConfiguration(_configuration!);
            log('setConfiguration $setConfiguration');
          },
        ),
      ],
    );
  }

  Widget _claim_release_interface() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('claimInterface'),
          onPressed: () async {
            var claimInterface = await QuickUsb.claimInterface(_configuration!.interfaces[0]);
            log('claimInterface $claimInterface');
          },
        ),
        ElevatedButton(
          child: const Text('releaseInterface'),
          onPressed: () async {
            var releaseInterface = await QuickUsb.releaseInterface(_configuration!.interfaces[0]);
            log('releaseInterface $releaseInterface');
          },
        ),
      ],
    );
  }

  Widget _bulk_transfer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  // child: const Text('bulkTransferIn'),
                  child: const Text('输入'),
                  onPressed: () async {
                    var endpoint = _configuration!.interfaces[0].endpoints.firstWhere((e) => e.direction == UsbEndpoint.DIRECTION_IN);
                    var bulkTransferIn = await QuickUsb.bulkTransferIn(endpoint, 1024);
                    log('bulkTransferIn ${hex.encode(bulkTransferIn)}');
                    textController.text = hex.encode(bulkTransferIn).toString();
                  },
                ),
                ElevatedButton(
                  // child: const Text('bulkTransferOut'),
                  child: const Text('输出'),
                  onPressed: () async {
                    var data = Uint8List.fromList(utf8.encode(''));
                    var endpoint = _configuration!.interfaces[0].endpoints.firstWhere((e) => e.direction == UsbEndpoint.DIRECTION_OUT);
                    var bulkTransferOut = await QuickUsb.bulkTransferOut(endpoint, data);
                    log('bulkTransferOut $bulkTransferOut');
                  },
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _getDevicesWithDescription() {
    return ElevatedButton(
      child: const Text('getDevicesWithDescription'),
      onPressed: () async {
        var descriptions = await QuickUsb.getDevicesWithDescription();
        _deviceList = descriptions.map((e) => e.device).toList();
        log('descriptions $descriptions');
      },
    );
  }

  Widget _getDeviceDescription() {
    return ElevatedButton(
      child: const Text('getDeviceDescription'),
      onPressed: () async {
        var description = await QuickUsb.getDeviceDescription(_deviceList!.first);
        log('description ${description.toMap()}');
      },
    );
  }
}
