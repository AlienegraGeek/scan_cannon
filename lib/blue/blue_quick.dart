import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:quick_blue/quick_blue.dart';
import 'package:logging/logging.dart';

import 'PeripheralDerailPage.dart';

class BlueQuick extends StatefulWidget {
  BlueQuick({Key? key}) : super(key: key);

  @override
  BlueQuickState createState() => BlueQuickState();
}

class BlueQuickState extends State<BlueQuick> {
  StreamSubscription<BlueScanResult>? _subscription;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      QuickBlue.setLogger(Logger('quick_blue_example'));
    }
    _subscription = QuickBlue.scanResultStream.listen((result) {
      if (!_scanResults.any((r) => r.deviceId == result.deviceId)) {
        setState(() => _scanResults.add(result));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: QuickBlue.isBluetoothAvailable(),
              builder: (context, snapshot) {
                var available = snapshot.data?.toString() ?? '...';
                return Text('Bluetooth init: $available');
              },
            ),
            _buildButtons(),
            Divider(
              color: Colors.blue,
            ),
            _buildListView(),
            _buildPermissionWarning(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          child: Text('startScan'),
          onPressed: () {
            QuickBlue.startScan();
          },
        ),
        RaisedButton(
          child: Text('stopScan'),
          onPressed: () {
            QuickBlue.stopScan();
          },
        ),
      ],
    );
  }

  var _scanResults = <BlueScanResult>[];

  Widget _buildListView() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title:
          Text('${_scanResults[index].name}(${_scanResults[index].rssi})'),
          subtitle: Text(_scanResults[index].deviceId),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PeripheralDetailPage(_scanResults[index].deviceId),
                ));
          },
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: _scanResults.length,
      ),
    );
  }

  Widget _buildPermissionWarning() {
    if (GetPlatform.isAndroid) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Text('BLUETOOTH_SCAN/ACCESS_FINE_LOCATION needed'),
      );
    }
    return Container();
  }
}