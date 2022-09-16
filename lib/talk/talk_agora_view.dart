import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';

// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:permission_handler/permission_handler.dart';

/// 定义 App ID 和 Token
const appId = "3cef07566b93496798f9de5da63bcc8d";
const token = "007eJxTYGBzC9smcv9CR4znxQDxi7M2WpRWPy18biTs8tTqplnHjE4FBuPk1DQDc1MzsyRLYxNLM3NLizTLlFTTlEQz46TkZIuUTb4qyYbzVZNr7/IxMTJAIIjPzFCVmsrAAAAa9h+e";
const channel = "zee";

class TalkAgoraPage extends StatefulWidget {
  TalkAgoraPage({Key? key}) : super(key: key);

  @override
  TalkAgoraState createState() => TalkAgoraState();
}

class TalkAgoraState extends State<TalkAgoraPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool isJoined = false, openMicrophone = true, enableSpeakerphone = true, playEffect = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 100, _playbackVolume = 100, _inEarMonitoringVolume = 100;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        warning: (warningCode) {
          print('warning $warningCode');
        },
        error: (errorCode) {
          print('error $errorCode');
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        leaveChannel: (stats) async {
          print('leaveChannel ${stats.toJson()}');
          setState(() {
            isJoined = false;
          });
        },
      ),
    );

    await _engine.joinChannel(token, channel, null, 0);
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine.joinChannel(token, _controller.text, null, 708).catchError((onError) {
      print('error ${onError.toString()}');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      isJoined = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
      _enableInEarMonitoring = false;
      _recordingVolume = 100;
      _playbackVolume = 100;
      _inEarMonitoringVolume = 100;
    });
  }

  _switchMicrophone() async {
    // await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      print('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      print('setEnableSpeakerphone $err');
    });
  }

  _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  _toggleInEarMonitoring(value) async {
    _enableInEarMonitoring = value;
    await _engine.enableInEarMonitoring(_enableInEarMonitoring);
    setState(() {});
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('语音测试'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Channel ID'),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _joinChannel,
                      child: Text('Join channel'),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _leaveChannel,
                      child: Text('Leave channel'),
                    ),
                  )
                ],
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _switchMicrophone,
                      child: Text('Microphone ${openMicrophone ? 'on' : 'off'}'),
                    ),
                    ElevatedButton(
                      // onPressed: isJoined ? _switchSpeakerphone : null,
                      onPressed: _switchSpeakerphone,
                      child: Text(enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
                    ),
                    // if (!kIsWeb)
                    //   ElevatedButton(
                    //     onPressed: isJoined ? _switchEffect : null,
                    //     child: Text('${playEffect ? 'Stop' : 'Play'} effect'),
                    //   ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('RecordingVolume:'),
                        Slider(
                          value: _recordingVolume,
                          min: 0,
                          max: 400,
                          divisions: 5,
                          label: 'RecordingVolume',
                          onChanged: isJoined
                              ? (double value) {
                                  setState(() {
                                    _recordingVolume = value;
                                  });
                                  _engine.adjustRecordingSignalVolume(value.toInt());
                                }
                              : null,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('PlaybackVolume:'),
                        Slider(
                          value: _playbackVolume,
                          min: 0,
                          max: 400,
                          divisions: 5,
                          label: 'PlaybackVolume',
                          onChanged: isJoined
                              ? (double value) {
                                  setState(() {
                                    _playbackVolume = value;
                                  });
                                  _engine.adjustPlaybackSignalVolume(value.toInt());
                                }
                              : null,
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          const Text('InEar Monitoring Volume:'),
                          Switch(
                            value: _enableInEarMonitoring,
                            onChanged: isJoined ? _toggleInEarMonitoring : null,
                            activeTrackColor: Colors.grey[350],
                            activeColor: Colors.white,
                          )
                        ]),
                        if (_enableInEarMonitoring)
                          SizedBox(
                              width: 300,
                              child: Slider(
                                value: _inEarMonitoringVolume,
                                min: 0,
                                max: 100,
                                divisions: 5,
                                label: 'InEar Monitoring Volume $_inEarMonitoringVolume',
                                onChanged: isJoined ? _onChangeInEarMonitoringVolume : null,
                              ))
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: channel,
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
