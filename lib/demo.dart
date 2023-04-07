import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/view_share_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utils/constants.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: TextButton(
      onPressed: () async {
        String message = "This is a test message!";
        List<String> recipents = ["+91 1245451245", "1452624515"];

        // try {
        //   String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true).catchError((onError) {
        //     print(onError);
        //   });
        //   print(_result);
        // } catch (e) {}
        _sendSMS(recipents);
      },
      child: Text('OK SMS'),
    )));
    //   Scaffold(
    //   body: _controller!.value.isInitialized
    //       ? VisibilityDetector(
    //           key: const Key("keyfile"),
    //           onVisibilityChanged: (VisibilityInfo info) {
    //             debugPrint(
    //                 "${info.visibleFraction} of my widget is visible");
    //             if (info.visibleFraction == 0) {
    //               _controller!.pause();
    //             } else {
    //               _controller!.play();
    //             }
    //           },
    //           child: AspectRatio(
    //             aspectRatio: _controller!.value.aspectRatio,
    //             child: VideoPlayer(_controller!),
    //           ),
    //         )
    //       : const SizedBox(),
    // );
  }

  String? _message, body;
  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: '_controllerMessage.text',
        recipients: recipients,
        sendDirect: false,
      );
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }
}
