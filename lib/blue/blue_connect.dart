import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class BlueConnectPage extends StatefulWidget {

  BlueConnectPage(ScanResult this.scan);

  ScanResult scan;

  @override
  BlueConnectState createState() => BlueConnectState();
}

class BlueConnectState extends State<BlueConnectPage> {

  List<BluetoothService> _services = [];

  //发送框的控制器
  TextEditingController sendController = TextEditingController();

  List<String> receiveData = [];

  @override
  void initState() {
    super.initState();
    connect();
  }

  connect() async {
    print('开始连接');
    await widget.scan.device.connect();
    print('连接成功');
    BluetoothCharacteristic mCharacteristic;
    widget.scan.device.discoverServices().then((services) {
      setState(() {
        this._services = services;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              widget.scan.device.disconnect();
              Navigator.of(context).pop();
            },
          ),
          title: Text("Blue Page"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListView.separated(
                  itemBuilder: _buildUUId,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._services.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Padding(
                          padding: EdgeInsets.only(
                              top: 20,
                              bottom: 20),
                          child: Divider(
                            height: 1,
                            color: Colors.black,
                          )),
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }

  Widget _buildUUId(BuildContext context, int index) {
    BluetoothService service = this._services[index];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("service uuid :${service.uuid.toString().split('-')[0]}",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return _buildChar(context, service.characteristics[index]);
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: service.characteristics.length,
            separatorBuilder: (BuildContext context, int index) =>
                Padding(
                    padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20),
                    child: Divider(
                      height: 1,
                      color: Colors.black,
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildChar(BuildContext context, BluetoothCharacteristic char) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: GestureDetector(
        child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${char.uuid}", style: TextStyle(),),
                Text("read:${char.properties.read}, write:${char.properties
                    .write}, notify:${char.properties.notify} ",
                  style: TextStyle(),),
              ],
            )
        ),
        onTap: () {
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => testBlueSendPage(char)));
        },
      ),
    );
  }
}