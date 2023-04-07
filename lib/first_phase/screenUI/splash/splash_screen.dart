import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/view_share_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/video/splash_1.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    gotoNext();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _controller!.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size?.width ?? 0,
                height: _controller!.value.size?.height ?? 0,
                child: _controller!.value.isInitialized
                    ? VisibilityDetector(
                        key: const Key("keyfile"),
                        onVisibilityChanged: (VisibilityInfo info) {
                          debugPrint("${info.visibleFraction} of my widget is visible");
                          if (info.visibleFraction == 0) {
                            _controller!.pause();
                          } else {
                            _controller!.play();
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ),
          //FURTHER IMPLEMENTATION
        ],
      ),
    ));
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

  gotoNext() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        if (_controller!.value.isPlaying) {
          //video is currently playing
          _controller!.pause();
          print("playing stop");
        }
      });
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 700),
          child: const FirstHomeScreen(),
          // child: ViewShareScreen(),
        ),
      );

      //  Navigator.pushReplacement(context,
      //    MaterialPageRoute(builder: (context) => const FirstHomeScreen()));
      //   Navigator.pushNamed(context, FirstHomeScreen.routeName);
      // Navigator.pushNamed(context, HomeScreen.routeName);
    });
  }
}
