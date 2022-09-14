import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'blue_connect.dart';

class BluePlusPage extends StatefulWidget {
  BluePlusPage({Key? key}) : super(key: key);

  @override
  BluePlusState createState() => BluePlusState();
}

class BluePlusState extends State<BluePlusPage> {
  bool isDebug = false;
  bool isBleOn = false;
  bool isConnecting = false;
  final List<ScanResult> _blueDevice = [];

  @override
  void initState() {
    super.initState();

    reuestBlue();

    requestLocation();

    //只监听一次
    scanLister();
  }

  reuestBlue() async {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

    if (await Permission.bluetooth.request().isGranted) {
      AddMsg('蓝牙权限已开启');
    } else {
      AddMsg('蓝牙权限请求失败');
    }

    flutterBlue.isAvailable.then((value) {
      AddMsg('蓝牙是否可用,${value}');
    });

    flutterBlue.isOn.then((value) {
      AddMsg('蓝牙状态已经开启,${value}');
      isBleOn = value;
    });

    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        AddMsg('蓝牙状态为开启');
        isBleOn = true;
      } else if (state == BluetoothState.off) {
        AddMsg('蓝牙状态为关闭');
        isBleOn = false;
      }
    });
  }

  requestLocation() async {
    if (await Permission.location.isGranted) {
      AddMsg('位置权限已开启');
    } else {
      AddMsg('蓝牙搜索需要开启位置权限');
      if (await Permission.location.request().isGranted) {
        AddMsg('位置权限已开启');
      } else {
        AddMsg('位置权限请求失败');
      }
    }
  }

  Widget _buildBlueDevice(BuildContext context, int index) {
    ScanResult model = _blueDevice[index];
    return Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Row(
          children: <Widget>[
            Text(model.rssi.toString()),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.device.id.toString()),
                Text("name: " + model.device.name),
                Text("connectable: " + model.advertisementData.connectable.toString()),
              ],
            ),
            Expanded(
              child: Text(''),
            ),
            model.device.state != BluetoothDeviceState.connected
                ? RaisedButton(
                    child: Text('connect'),
                    onPressed: () => connectToBlueDevice(model),
                  )
                : RaisedButton(child: Text('disConnect'), onPressed: () => model.device.disconnect())
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blue Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isDebug
                  ? ListView.separated(
                      itemBuilder: _buildMsg,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: msgLst.length,
                      separatorBuilder: (BuildContext context, int index) => Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Divider(
                            height: 1,
                            color: Colors.black,
                          )),
                    )
                  : Container(),
              ListView.separated(
                itemBuilder: _buildBlueDevice,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _blueDevice.length,
                separatorBuilder: (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Divider(
                      height: 1,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchBlue,
        tooltip: '扫描蓝牙设备',
        child: Icon(Icons.search),
      ),
    );
  }

  //扫描蓝牙设备
  void searchBlue() {
    if (!isBleOn) {
      AddMsg("手机蓝牙未打开，请打开后再扫描设备");
      return;
    }
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    flutterBlue.stopScan().then((value) {
      AddMsg('blue is stop');
      AddMsg('start scan');
      setState(() {
        _blueDevice.clear();
      });
      // Listen to scan results

      flutterBlue.startScan(timeout: Duration(seconds: 4));
    });
  }

  void scanLister() {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    List<String> blueId = [];
    flutterBlue.scanResults.listen((results) {
      AddMsg('scan device ...${results} , ${results.length}');
      // do something with scan results
      for (ScanResult r in results) {
        if (!blueId.contains(r.device.id.id)) {
          blueId.add(r.device.id.id);
          AddMsg('${r.device.name} found! rssi: ${r.rssi}');

          setState(() {
            this._blueDevice.add(r);
          });
        }
      }
    });
  }

  //链接蓝牙设备
  void connectToBlueDevice(ScanResult model) async {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    AddMsg('connect');
    flutterBlue.stopScan();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlueConnectPage(model)));
    return;

    await model.device.connect(autoConnect: false, timeout: Duration(seconds: 20));
    showMsg();
    AddMsg('connected...');
    BluetoothCharacteristic mCharacteristic;
    List<BluetoothService> services = await model.device.discoverServices();
    services.forEach((service) async {
      var value = service.uuid.toString();
      AddMsg("${value}");
      AddMsg("所有服务值 --- $value");
      var characteristics = service.characteristics;

      for (BluetoothCharacteristic c in characteristics) {
        // List<int> rv = await c.read();
        // AddMsg("收到消息：${rv}");
        // AddMsg("收到消息：${rv}");
        AddMsg("BluetoothCharacteristic uuid：${c.uuid}");

        // await c.setNotifyValue(true);
        // c.value.listen((v) {
        //   AddMsg("收到心跳消息：${v}");
        //   AddMsg("收到消息：${v}");
        // });
      }
      BluetoothCharacteristic c = characteristics[0];
      List<int> rv = await c.read();
      AddMsg("收到消息：${rv}");
      AddMsg("收到消息：${rv}");

      await c.setNotifyValue(true);
      c.value.listen((v) {
        AddMsg("收到心跳消息：${v}");
        AddMsg("收到消息：${v}");
      });
    });
  }

  List<String> msgLst = [];

  void AddMsg(String msg) {
    setState(() {
      this.msgLst.add(msg);
    });
  }

  Widget _buildMsg(BuildContext context, int index) {
    String msg = this.msgLst[index];
    return Text(msg);
  }

  Widget MsgPanel() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.separated(
            itemBuilder: _buildMsg,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: msgLst.length,
            separatorBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.only(top: 2, bottom: 2),
                child: Divider(
                  height: 1,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }

  void showMsg() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(height: 400, child: MsgPanel());
      },
    );
  }
}
