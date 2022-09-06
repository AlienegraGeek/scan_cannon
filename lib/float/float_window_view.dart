import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:system_alert_window/system_alert_window.dart';

///
/// Whenever a button is clicked, this method will be invoked with a tag (As tag is unique for every button, it helps in identifying the button).
/// You can check for the tag value and perform the relevant action for the button click
///
void callBack(String tag) {
  WidgetsFlutterBinding.ensureInitialized();
  switch (tag) {
    case "stop_to_start":
      SystemWindowHeader header = SystemWindowHeader(
          title: SystemWindowText(text: "", fontSize: 10, textColor: Colors.black45),
          padding: SystemWindowPadding.setSymmetricPadding(0, 12),
          subTitle: SystemWindowText(text: "点击按钮结束对讲", fontSize: 16, fontWeight: FontWeight.BOLD, textColor: Colors.black87),
          decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
          button: SystemWindowButton(
            text: SystemWindowText(text: "正在对讲", fontSize: 12, textColor: Colors.white),
            tag: "start_to_stop",
            width: 0,
            padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
            height: 50,
            decoration: SystemWindowDecoration(
                startColor: Color.fromRGBO(118, 217, 163, 1), endColor: Color.fromRGBO(7, 179, 231, 1), borderWidth: 0, borderRadius: 30.0),
          ),
          buttonPosition: ButtonPosition.TRAILING);
      SystemAlertWindow.updateSystemWindow(
          height: 50,
          header: header,
          margin: SystemWindowMargin(left: 8, right: 8, top: 0, bottom: 0),
          gravity: SystemWindowGravity.TOP,
          prefMode: SystemWindowPrefMode.OVERLAY);
      break;
    case "start_to_stop":
      SystemWindowHeader header = SystemWindowHeader(
          title: SystemWindowText(text: "", fontSize: 10, textColor: Colors.black45),
          padding: SystemWindowPadding.setSymmetricPadding(0, 12),
          subTitle: SystemWindowText(text: "点击按钮开始对讲", fontSize: 16, fontWeight: FontWeight.BOLD, textColor: Colors.black87),
          decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
          button: SystemWindowButton(
            text: SystemWindowText(text: "打开对讲", fontSize: 12, textColor: Colors.white),
            tag: "stop_to_start",
            width: 0,
            padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
            height: 50,
            decoration: SystemWindowDecoration(
                startColor: Color.fromRGBO(250, 139, 97, 1), endColor: Color.fromRGBO(247, 28, 88, 1), borderWidth: 0, borderRadius: 30.0),
          ),
          buttonPosition: ButtonPosition.TRAILING);
      SystemAlertWindow.updateSystemWindow(
          height: 50,
          header: header,
          margin: SystemWindowMargin(left: 8, right: 8, top: 200, bottom: 0),
          gravity: SystemWindowGravity.TOP,
          prefMode: SystemWindowPrefMode.OVERLAY);
      break;
    default:
      print("OnClick event of $tag");
  }
}

class FloatWindowView extends StatefulWidget {
  const FloatWindowView({Key? key}) : super(key: key);

  @override
  FloatWindowViewState createState() => FloatWindowViewState();
}

class FloatWindowViewState extends State<FloatWindowView> {
  String _platformVersion = 'Unknown';
  bool _isShowingWindow = false;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _requestPermissions();
    SystemAlertWindow.registerOnClickListener(callBack);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    await SystemAlertWindow.enableLogs(true);
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SystemAlertWindow.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion!;
    });
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow() {
    if (!_isShowingWindow) {
      SystemWindowHeader header = SystemWindowHeader(
          title: SystemWindowText(text: "", fontSize: 10, textColor: Colors.black45),
          // title: SystemWindowText(text: "Incoming Call", fontSize: 10, textColor: Colors.black45),
          padding: SystemWindowPadding.setSymmetricPadding(0, 12),
          subTitle: SystemWindowText(text: "点击按钮开始对讲", fontSize: 16, fontWeight: FontWeight.BOLD, textColor: Colors.black87),
          // decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
          decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
          // button: SystemWindowButton(text: SystemWindowText(text: "Personal", fontSize: 10, textColor: Colors.black45), tag: "personal_btn"),
          button: SystemWindowButton(
            text: SystemWindowText(text: "打开对讲", fontSize: 12, textColor: Colors.white),
            tag: "stop_to_start",
            width: 0,
            padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
            // height: SystemWindowButton.WRAP_CONTENT,
            height: 50,
            decoration: SystemWindowDecoration(
                startColor: Color.fromRGBO(250, 139, 97, 1), endColor: Color.fromRGBO(247, 28, 88, 1), borderWidth: 0, borderRadius: 30.0),
          ),
          buttonPosition: ButtonPosition.TRAILING);
      SystemAlertWindow.showSystemWindow(
          height: 50,
          header: header,
          margin: SystemWindowMargin(left: 8, right: 8, top: (MediaQuery.of(context).size.height - 50).round(), bottom: 0),
          gravity: SystemWindowGravity.TOP,
          prefMode: prefMode);
      setState(() {
        _isShowingWindow = true;
      });
    } else {
      setState(() {
        _isShowingWindow = false;
      });
      SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('悬浮窗测试'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('运行测试版本: $_platformVersion\n'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MaterialButton(
                  onPressed: _showOverlayWindow,
                  textColor: Colors.white,
                  color: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: !_isShowingWindow ? Text("显示悬浮框") : Text("关闭悬浮框"),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    String? logFilePath = await SystemAlertWindow.getLogFile;
                    if (logFilePath!.isNotEmpty) {
                      Share.shareFiles([logFilePath]);
                    } else {
                      print("Path is empty");
                    }
                  },
                  child: Text("分享日志文件"))
            ],
          ),
        ),
      ),
    );
  }
}
