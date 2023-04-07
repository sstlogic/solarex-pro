import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/first_phase/Server/RepNumberAPI.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:solarex/utils/video_player.dart';
import '../../../../theme/style.dart';
import 'package:solarex/first_phase/screenUI/confirmation/confirm_meeting_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../utils/colors_app.dart';
import '../../../../utils/dialog_widget.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  VideoPlayerController? _controller;
  final _repNumberController = TextEditingController();

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/video/home_clip_2.mp4',videoPlayerOptions:  VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });

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
    final _formKey = GlobalKey<FormState>();
    // var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);

    return Column(
      children: [
        const Spacer(),
        Container(
            margin: EdgeInsets.only(left: fullWidth * .10, right: fullWidth * .10),
            child: _controller!.value.isInitialized
                ? VisibilityDetector(
                    key: const Key("keyfile"),
                    onVisibilityChanged: (VisibilityInfo info) {
                      debugPrint(
                          "${info.visibleFraction} of my widget is visible");
                      // if (info.visibleFraction == 0) {
                      //   _controller!.pause();
                      // } else {
                      //   _controller!.play();
                      // }
                    },
                    child:
                    Container(
                      alignment: Alignment.center,
                      // padding: _isFullScreen
                      //     ? const EdgeInsets.all(0)
                      //     : const EdgeInsets.only(bottom: 20),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          fit: StackFit.loose,
                          children: <Widget>[
                            Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: VideoPlayer(_controller!),
                                )),
                            ClosedCaption(text: _controller!.value.caption.text),
                            VideoProgressIndicator(_controller!,
                                allowScrubbing: true,
                                padding:
                                const EdgeInsets.symmetric(vertical: 10)),
                            _ControlsOverlay(controller: _controller!),
                            // isOverlayVisible
                            //     ? VideoOverlay(controller: _controller!)
                            //     : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox()),
        Container(margin: EdgeInsets.only(left: fullWidth * .10, right: fullWidth * .10),
            child: VideoOverlay(controller: _controller!)),
        const SizedBox(
          height: 20,
        ),
        Container(
            margin:
                EdgeInsets.only(left: fullWidth * .10, right: fullWidth * .10),
            child: Image.asset(imgLogo)),
        const Spacer(),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: fullWidth * .20,
                margin: const EdgeInsets.only(
                    left: defaultPadding, right: defaultPadding),
                child: buildFirstStepFormField(),
              ),

              // buildFirstStepFormField(),
              // const SizedBox(
              //   height: defaultPadding,
              // ),

              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          if (_controller!.value.isPlaying) {
                            //video is currently playing
                            _controller!.pause();
                            // print("playing stop");
                          }
                        });
                        _waits(true);
                        // print("REP Number CONTROLLER====");
                        // print(_repNumberController.text);
                        repNumberAPI(_repNumberController.text, _sucessAPI, _error);
                      }
                    },
                    child: Text(
                      'find solarex rep'.toUpperCase(),
                      style: textBtn,
                    ),
                  ),
                ),
              )
              // Container(
              //     width: fullWidth,
              //     height: 40,
              //     margin: const EdgeInsets.only(
              //         left: defaultPadding,
              //         right: defaultPadding,
              //         bottom: defaultPadding),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: kPrimaryColor,
              //       boxShadow: const [
              //         BoxShadow(color: kPrimaryColor, spreadRadius: 3),
              //       ],
              //     ),
              //     child:

              // Center(
              //   child: Text(
              //     'find solarex req'.toUpperCase(),
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.w600),
              //   ),
              // )
              // )
            ],
          ),
        ),
      ],
    );
  }

  TextFormField buildFirstStepFormField() {
    return TextFormField(
      maxLength: 8,
controller: _repNumberController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Rep number empty';
        } else if (value.toString().length != 8) {
          return 'Invalid rep number';
        }
        return null;
      },
      textAlign: TextAlign.start,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffd0d0d2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffd0d0d2)),
        ),
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        hintText: "Enter REP Number",
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      ),
    );
    //   TextFormField(
    //   autovalidateMode: AutovalidateMode.always,
    //   // onSaved: (newValue) => strReg = newValue,
    //   onChanged: (value) {
    //     if (value.isNotEmpty) {
    //     } else if (value.length >= 8) {}
    //     return null;
    //   },
    //   validator: (value) {
    //     return null;
    //   },
    //   maxLength: 8,
    //   decoration: InputDecoration(
    //     enabledBorder: ConstantClass.outlineInputBorder,
    //     border: ConstantClass.outlineInputBorder,
    //     errorBorder: ConstantClass.outlineInputBorder,
    //     hintText: "Enter Rep Number",
    //     hintStyle:
    //         const TextStyle(color: kTextColor, fontWeight: FontWeight.w400),
    //     floatingLabelBehavior: FloatingLabelBehavior.always,
    //   ),
    // );
  }

  _waits(bool value) {
    if (value) {
      showLoaderDialog(context);
    } else {
      Navigator.pop(context);
    }
  }

  _sucessAPI(String? message, String? status) {
    _waits(false);
    setState(() {
      Navigator.pushNamed(context, ConfirmMeetingScreen.routeName);
    });
  }

  _error(String error) {
    _waits(false);
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (_) => DialogWidget(
              title: "" + error,
              button1: 'Ok',
              onButton1Clicked: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              height: 150,
            ));
  }

}
class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  // ignore: unused_field
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  Future setToolbarVisibility() async {
    setState(() {
      isOverlayVisible = !isOverlayVisible;
    });
    Future.delayed(
        const Duration(seconds: 10),
            () => {
          if (isOverlayVisible)
            {
              // setState(() {
              isOverlayVisible = false
              // })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setToolbarVisibility();
          },
        ),
      ],
    );
  }
}

// class VideoOverlay extends StatefulWidget {
//   const VideoOverlay({
//     Key? key,
//     required this.controller, //required this.setSpeed
//   }) : super(key: key);
//   final VideoPlayerController controller;
//
//   //final Function setSpeed;
//
//   @override
//   State<VideoOverlay> createState() => _VideoOverlayState();
// }
//
// class _VideoOverlayState extends State<VideoOverlay> {
//   final TextStyle _style = const TextStyle(fontSize: 16, color: Colors.white);
//   late Duration currentDuration;
//   late Duration totalDuration;
//   String startText = '';
//   double sliderPosition = 0.0;
//   double sliderTotal = 0.0;
//
//   static const List<double> playbackRates = <double>[
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//     3.0,
//     5.0,
//     10.0,
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     currentDuration = const Duration(seconds: 0);
//     totalDuration = const Duration(seconds: 0);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) => {_getData()});
//   }
//
//   Future<void> _getData() async {
//     // ignore: unnecessary_null_comparison
//     if (widget.controller != null) {
//       currentDuration =
//           await widget.controller.position ?? const Duration(seconds: 0);
//       totalDuration = widget.controller.value.duration;
//       if (widget.controller.value.isPlaying) {
//         startText =
//             ((currentDuration.inSeconds / totalDuration.inSeconds) * 100)
//                 .round()
//                 .toString() +
//                 ' %';
//       }
//       sliderPosition = currentDuration.inSeconds.toDouble();
//       sliderTotal = totalDuration.inSeconds.toDouble();
//
//       setState(() {});
//     }
//   }
//
//   Future showStatusBar() {
//     return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//   }
//
//   Future hideStatusBar() {
//     return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: []);
//   }
//
//   _prepareTime(Duration time) {
//     return '${(Duration(seconds: time.inSeconds))}'
//         .split('.')[0]
//         .padLeft(8, '0');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _getData();
//     return Positioned(
//         bottom: 0,
//         child: Container(
//           color: Colors.grey.withOpacity(0.5),
//           width: MediaQuery.of(context).size.width,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                   "${_prepareTime(currentDuration)}/${_prepareTime(totalDuration)}",
//                   style: _style),
//               IconButton(
//                 onPressed: () {
//                   if (widget.controller.value.isPlaying) {
//                     widget.controller.pause();
//                   } else {
//                     widget.controller.play();
//                   }
//                   setState(() {});
//                 },
//                 icon: (widget.controller.value.isPlaying
//                     ? const Icon(Icons.pause)
//                     : const Icon(Icons.play_arrow)),
//                 color: Colors.white,
//               ),
//               PopupMenuButton<double>(
//                   initialValue: widget.controller.value.playbackSpeed,
//                   tooltip: 'Playback speed',
//                   onSelected: (double speed) {
//                     widget.controller.setPlaybackSpeed(speed);
//                     setState(() {});
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return <PopupMenuItem<double>>[
//                       for (final double speed in playbackRates)
//                         PopupMenuItem<double>(
//                           value: speed,
//                           child: Text(
//                             '${speed}x',
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                           onTap: () {
//                             widget.controller.setPlaybackSpeed(speed);
//                             setState(() {});
//                           },
//                         )
//                     ];
//                   },
//                   child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         // Using less vertical padding as the text is also longer
//                         // horizontally, so it feels like it would need more spacing
//                         // horizontally (matching the aspect ratio of the video).
//                         vertical: 12,
//                         horizontal: 40,
//                       ),
//                       child: Row(children: [
//                         const Icon(
//                           Icons.speed,
//                           color: Colors.white,
//                         ),
//                         Text(
//                           '${widget.controller.value.playbackSpeed}x',
//                           style: _style,
//                         )
//                       ]))),
//               // IconButton(
//               //     onPressed: () {
//               //       _isFullScreen = !_isFullScreen;
//               //
//               //       if (_isFullScreen) {
//               //         hideStatusBar();
//               //         SystemChrome.setPreferredOrientations(
//               //             [DeviceOrientation.landscapeLeft]);
//               //       } else {
//               //         showStatusBar();
//               //         SystemChrome.setPreferredOrientations(
//               //             [DeviceOrientation.portraitUp]);
//               //       }
//               //       setState(() {});
//               //     },
//               //     icon: _isFullScreen
//               //         ? const Icon(Icons.fullscreen_exit, color: Colors.white)
//               //         : const Icon(
//               //       Icons.fullscreen,
//               //       color: Colors.white,
//               //     ))
//             ],
//           ),
//         ));
//   }
// }
