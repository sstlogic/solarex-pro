// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:video_player/video_player.dart';

bool _isFullScreen = false;
bool isOverlayVisible = true;
int nowPlaying = 0;

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String startTime;
  final String endTime;
  bool? isActionBar;
  final bool isfromLocal;

  CustomVideoPlayer(
      {Key? key,
      required this.videoUrl,
      required this.startTime,
      required this.endTime,
      this.isfromLocal = false,
      this.isActionBar = true})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        key: const ValueKey<String>('home_page'),
        child:   RemoteVideoPlayer(
                videoUrl: introVideoUrl,
                startTime: widget.startTime,
                endTime: widget.endTime,
                isActionBar: widget.isActionBar,
                isfromLocal: isFromLocal,
              )

      ),
    );
  }

  var isFromLocal = false;
  String introVideoUrl = '';
  var isCheckComplete = false;

  @override
  void initState() {
    super.initState();
    introVideoUrl = widget.videoUrl;
  }
}

class RemoteVideoPlayer extends StatefulWidget {
  RemoteVideoPlayer(
      {Key? key,
      required this.videoUrl,
      required this.startTime,
      required this.endTime,
      this.isfromLocal = false,
      this.isActionBar = true})
      : super(key: key);
  final String videoUrl;
  final String startTime;
  final String endTime;
  final bool isfromLocal;
  bool? isActionBar;

  @override
  _RemoteVideoPlayerState createState() => _RemoteVideoPlayerState();
}

class _RemoteVideoPlayerState extends State<RemoteVideoPlayer> {
  late VideoPlayerController _controller;

  // ignore: unused_field
  late double _origVolume;
  bool startedPlaying = false;

  // ignore: unused_field
  bool _isPlayerReady = false;

  int startTime = 0;
  int? endTime;
  var isVideoPlayerShow = true;

  @override
  void initState() {
    super.initState();
    playVideo();
  }

  playVideo() async {
    if (widget.isfromLocal) {
      _controller = VideoPlayerController.asset(
        widget.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } else {
      _controller = VideoPlayerController.network(
        widget.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    }

    _controller.initialize().then((value) => {
          _controller.addListener(() {
            //custom Listner
            if (_controller.value.isPlaying ||
                _controller.value.duration == _controller.value.position) {
              setState(() {
                if (!_controller.value.isPlaying &&
                    _controller.value.isInitialized &&
                    (_controller.value.duration ==
                        _controller.value.position)) {
                  //checking the duration and position every time
                  //Video Completed//
                  //print("videoComplete===$isVideoComplete");
                  Navigator.pop(context);
                  isVideoPlayerShow = false;
                  _controller.dispose();

                  // Navigator.pop(context);
                  if (mounted) {
                    setState(() {});
                  }
                }

                // if (_controller.value.position.inSeconds == 05 &&
                //     videoControl == false) {
                //   showBackIcon = true;
                //   setState(() {});
                // }
              });
            }
          })
        });

    _controller.setLooping(false);

    _controller.play();
    _isPlayerReady = true;
    _controller.addListener(() {
      // setState(() {
      // print('_controller.value.position====${_controller.value.position}');
      // print('_controller.value.duration====${_controller.value.duration.inSeconds - 1}');
      // if (_controller.value.position.inSeconds == _controller.value.duration.inSeconds-1) {
      //   _controller.pause();
      //   print('video End');
      //   Navigator.pop(context);
      // }
      // });
    }); //addListener {}
    setState(() {});
  }

  @override
  void dispose() {
    isVideoPlayerShow = false;
    if (_controller.value.isPlaying) {
      _controller.pause();
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _origVolume = _controller.value.volume;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading:
                  widget.isActionBar ?? false ? true : false,
            ),
      body: Column(
        children: <Widget>[
          isVideoPlayerShow
              ? Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: _isFullScreen
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.only(bottom: 20),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        fit: StackFit.loose,
                        children: <Widget>[
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment.center,
                            child: VideoPlayer(_controller),
                          )),
                          ClosedCaption(text: _controller.value.caption.text),
                          VideoProgressIndicator(_controller,
                              allowScrubbing: true,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10)),
                          _ControlsOverlay(controller: _controller),
                          isOverlayVisible
                              ? VideoOverlay(controller: _controller)
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
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

class VideoOverlay extends StatefulWidget {
  const VideoOverlay({
    Key? key,
    required this.controller, //required this.setSpeed
  }) : super(key: key);
  final VideoPlayerController controller;

  //final Function setSpeed;

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> {
  final TextStyle _style = const TextStyle(fontSize: 16, color: Colors.white);
  late Duration currentDuration;
  late Duration totalDuration;
  String startText = '';
  double sliderPosition = 0.0;
  double sliderTotal = 0.0;

  static const List<double> playbackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  @override
  void initState() {
    super.initState();
    currentDuration = const Duration(seconds: 0);
    totalDuration = const Duration(seconds: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) => {_getData()});
  }

  Future<void> _getData() async {
    // ignore: unnecessary_null_comparison
    if (widget.controller != null) {
      currentDuration =
          await widget.controller.position ?? const Duration(seconds: 0);
      totalDuration = widget.controller.value.duration;
      if (widget.controller.value.isPlaying) {
        startText =
            ((currentDuration.inSeconds / totalDuration.inSeconds) * 100)
                    .round()
                    .toString() +
                ' %';
      }
      sliderPosition = currentDuration.inSeconds.toDouble();
      sliderTotal = totalDuration.inSeconds.toDouble();

      setState(() {});
    }
  }

  Future showStatusBar() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Future hideStatusBar() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
  }

  _prepareTime(Duration time) {
    return '${(Duration(seconds: time.inSeconds))}'
        .split('.')[0]
        .padLeft(8, '0');
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Container(
      color: Colors.black.withOpacity(0.5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
              "${_prepareTime(currentDuration)}/${_prepareTime(totalDuration)}",
              style: _style),
          IconButton(
            onPressed: () {
              if (widget.controller.value.isPlaying) {
                widget.controller.pause();
              } else {
                widget.controller.play();
              }
              setState(() {});
            },
            icon: (widget.controller.value.isPlaying
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow)),
            color: Colors.white,
          ),
          // PopupMenuButton<double>(
          //     initialValue: widget.controller.value.playbackSpeed,
          //     tooltip: 'Playback speed',
          //     onSelected: (double speed) {
          //       widget.controller.setPlaybackSpeed(speed);
          //       setState(() {});
          //     },
          //     itemBuilder: (BuildContext context) {
          //       return <PopupMenuItem<double>>[
          //         for (final double speed in playbackRates)
          //           PopupMenuItem<double>(
          //             value: speed,
          //             child: Text(
          //               '${speed}x',
          //               style: const TextStyle(color: Colors.black),
          //             ),
          //             onTap: () {
          //               widget.controller.setPlaybackSpeed(speed);
          //               setState(() {});
          //             },
          //           )
          //       ];
          //     },
          //     child: Container(
          //         padding: const EdgeInsets.symmetric(
          //           // Using less vertical padding as the text is also longer
          //           // horizontally, so it feels like it would need more spacing
          //           // horizontally (matching the aspect ratio of the video).
          //           vertical: 12,
          //           horizontal: 40,
          //         ),
          //         child: Row(children: [
          //           const Icon(
          //             Icons.speed,
          //             color: Colors.white,
          //           ),
          //           Text(
          //             '${widget.controller.value.playbackSpeed}x',
          //             style: _style,
          //           )
          //         ]))),
          // IconButton(
          //     onPressed: () {
          //       _isFullScreen = !_isFullScreen;
          //
          //       if (_isFullScreen) {
          //         hideStatusBar();
          //         SystemChrome.setPreferredOrientations(
          //             [DeviceOrientation.landscapeLeft]);
          //       } else {
          //         showStatusBar();
          //         SystemChrome.setPreferredOrientations(
          //             [DeviceOrientation.portraitUp]);
          //       }
          //       setState(() {});
          //     },
          //     icon: _isFullScreen
          //         ? const Icon(Icons.fullscreen_exit, color: Colors.white)
          //         : const Icon(
          //             Icons.fullscreen,
          //             color: Colors.white,
          //           ))
        ],
      ),
    );
  }
}
