import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/no_weight_exercise_screen.dart';
import 'package:tcm/screen/workout_screen/weighted_exercise.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TimeBasedExesiceScreen extends StatefulWidget {
  List<ExerciseById> data;

  TimeBasedExesiceScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<TimeBasedExesiceScreen> createState() => _TimeBasedExesiceScreenState();
}

class _TimeBasedExesiceScreenState extends State<TimeBasedExesiceScreen>
    with SingleTickerProviderStateMixin {
  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.counter_clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;

  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;

  ChewieController? _chewieController;

  @override
  void initState() {
    _timerController = TimerController(this);
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _youTubePlayerController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Future initializePlayer() async {
    youtubeVideoID() {
      String finalLink;
      String videoID = '${widget.data[0].exerciseVideo}';
      List<String> splittedLink = videoID.split('v=');
      List<String> longLink = splittedLink.last.split('&');

      finalLink = longLink.first;

      return finalLink;
    }

    if ('${widget.data[0].exerciseVideo}'.contains('www.youtube.com')) {
      _youTubePlayerController = YoutubePlayerController(
        initialVideoId: youtubeVideoID(),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: true,
          hideControls: false,
          loop: true,
        ),
      );
    } else {
      _videoPlayerController =
          VideoPlayerController.network('${widget.data[0].exerciseVideo}');

      await Future.wait([
        _videoPlayerController!.initialize(),
      ]);
      _createChewieController();
    }

    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      showControls: true,
      showControlsOnInitialize: true,
      hideControlsTimer: Duration(hours: 5),
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController!.pause();
    currPlayIndex = currPlayIndex == 0 ? 1 : 0;
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      timeDuration();
      print('----------------- ${widget.data[0].exerciseImage}');
      return Scaffold(
        backgroundColor: ColorUtils.kBlack,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: ColorUtils.kTint,
              )),
          backgroundColor: ColorUtils.kBlack,
          title: Text('Warm-Up', style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  Get.offAll(HomeScreen());
                },
                child: Text(
                  'Quit',
                  style: FontTextStyle.kTine16W400Roboto,
                ))
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: Get.height / 2.75,
              width: Get.width,
              child: '${widget.data[0].exerciseVideo}'
                      .contains('www.youtube.com')
                  ? Center(
                      child: _youTubePlayerController == null
                          ? CircularProgressIndicator(color: ColorUtils.kTint)
                          : YoutubePlayer(
                              controller: _youTubePlayerController!,
                              showVideoProgressIndicator: true,
                              bufferIndicator: CircularProgressIndicator(
                                  color: ColorUtils.kTint),
                              controlsTimeOut: Duration(hours: 2),
                              aspectRatio: 16 / 9,
                              progressColors: ProgressBarColors(
                                  handleColor: ColorUtils.kRed,
                                  playedColor: ColorUtils.kRed,
                                  backgroundColor: ColorUtils.kGray,
                                  bufferedColor: ColorUtils.kLightGray),
                            ))
                  : Center(
                      child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                          ? Chewie(
                              controller: _chewieController!,
                            )
                          : widget.data[0].exerciseImage == null
                              ? noDataLottie()
                              : Image.network(
                                  "https://tcm.sataware.dev/images/" +
                                      widget.data[0].exerciseImage!,
                                  errorBuilder: (context, error, stackTrace) {
                                    return noDataLottie();
                                  },
                                )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * .06, vertical: Get.height * .02),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.data[0].exerciseTitle}',
                              style: FontTextStyle.kWhite24BoldRoboto,
                            ),
                            SizedBox(height: Get.height * .005),
                            Text(
                              '${widget.data[0].exerciseRest} seconds each side',
                              style: FontTextStyle.kLightGray16W300Roboto,
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(NoWeightExerciseScreen(
                                data: widget.data,
                              ));
                            },
                            child: Text(
                              'Edit',
                              style: FontTextStyle.kTine16W400Roboto,
                            ))
                      ],
                    ),
                    SizedBox(height: Get.height * .04),
                    Center(
                        child: Container(
                      height: Get.height * .2,
                      width: Get.height * .2,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: SimpleTimer(
                        duration: Duration(seconds: timeDuration() ?? 30),
                        controller: _timerController,
                        timerStyle: _timerStyle,
                        progressTextFormatter: (format) {
                          return format.inSeconds.toString();
                        },
                        backgroundColor: ColorUtils.kGray,
                        progressIndicatorColor: ColorUtils.kTint,
                        progressIndicatorDirection: _progressIndicatorDirection,
                        progressTextCountDirection: _progressTextCountDirection,
                        progressTextStyle: FontTextStyle.kWhite24BoldRoboto,
                        strokeWidth: 15,
                      ),
                    )),
                    SizedBox(height: Get.height * .04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('Start Pressed');
                            _timerController!.start();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Get.height * .05,
                            width: Get.width * .3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                    colors: ColorUtilsGradient.kTintGradient,
                                    begin: Alignment.center,
                                    end: Alignment.center)),
                            child: Text(
                              'Start',
                              style: FontTextStyle.kBlack18w600Roboto,
                            ),
                          ),
                        ),
                        SizedBox(width: Get.width * 0.05),
                        GestureDetector(
                          onTap: () {
                            print('Reset pressed ');
                            _timerController!.reset();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Get.height * .05,
                            width: Get.width * .3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                    color: ColorUtils.kTint, width: 1.5)),
                            child: Text(
                              'Reset',
                              style: FontTextStyle.kTine17BoldRoboto,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * .04),
                    commonNevigationButton(
                        onTap: () {
                          if ('${widget.data[0].exerciseVideo}'
                              .contains('www.youtube.com')) {
                            _youTubePlayerController?.pause();
                          } else {
                            _videoPlayerController?.pause();
                            _chewieController?.pause();
                          }

                          Get.to(WeightExerciseScreen(
                            data: widget.data,
                          ));
                        },
                        name: 'Next exercise')
                  ]),
            ),
          ]),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: ColorUtils.kTint,
        ),
      );
    }
  }

  timeDuration() {
    String time = '${widget.data[0].exerciseRest}';
    List<String> splittedTime = time.split(' ');

    log('${splittedTime.first}');
    int? timer;
    if (splittedTime.first == '1') {
      timer = 60;
      log('$timer');
      return timer;
    } else if (splittedTime.first == '45') {
      timer = 45;
      log('$timer');
      return timer;
    } else if (splittedTime.first == '30') {
      timer = 30;
      log('$timer');
      return timer;
    }
  }
}
