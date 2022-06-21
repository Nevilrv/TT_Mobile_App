import 'dart:async';
import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/weighted_exercise.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class NoWeightExerciseScreen extends StatefulWidget {
  List<ExerciseById> data;

  NoWeightExerciseScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<NoWeightExerciseScreen> createState() => _NoWeightExerciseScreenState();
}

class _NoWeightExerciseScreenState extends State<NoWeightExerciseScreen> {
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _youTubePlayerController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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
      showControls: true,
      showControlsOnInitialize: true,
      hideControlsTimer: const Duration(hours: 5),
    );
  }

  int currPlayIndex = 0;
  int repsCounter = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController!.pause();
    currPlayIndex = currPlayIndex == 0 ? 1 : 0;
    await initializePlayer();
  }

  int counterSets = 0;
  int counterReps = 0;
  Duration counterTime = Duration(seconds: 0);
  Duration timerPM = Duration(seconds: 15);

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
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
              child:
                  '${widget.data[0].exerciseVideo}'.contains('www.youtube.com')
                      ? Center(
                          child: _youTubePlayerController != null ||
                                  _youTubePlayerController != ''
                              ? YoutubePlayer(
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
                                )
                              : noDataLottie(),
                        )
                      : Center(
                          child: _chewieController != null &&
                                  _chewieController!
                                      .videoPlayerController.value.isInitialized
                              ? Chewie(
                                  controller: _chewieController!,
                                )
                              : noDataLottie(),
                        ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * .06, vertical: Get.height * .02),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.data[0].exerciseTitle}',
                      style: FontTextStyle.kWhite24BoldRoboto,
                    ),
                    SizedBox(height: Get.height * .005),
                    Text(
                      '${widget.data[0].exerciseSets} sets of ${widget.data[0].exerciseReps} reps',
                      style: FontTextStyle.kLightGray16W300Roboto,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Get.height * 0.01),
                      child: Container(
                        height: Get.height * .1,
                        width: Get.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: ColorUtilsGradient.kGrayGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.topCenter),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  log('minus $counterSets');

                                  setState(() {
                                    if (counterSets > 0) counterSets--;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: Get.height * .03,
                                  backgroundColor: ColorUtils.kTint,
                                  child: Icon(Icons.remove,
                                      color: ColorUtils.kBlack),
                                ),
                              ),
                              SizedBox(width: Get.width * .08),
                              RichText(
                                  text: TextSpan(
                                      text: '$counterSets\t',
                                      style: counterSets == 0
                                          ? FontTextStyle.kWhite24BoldRoboto
                                              .copyWith(color: ColorUtils.kGray)
                                          : FontTextStyle.kWhite24BoldRoboto,
                                      children: [
                                    TextSpan(
                                        text: 'sets',
                                        style: FontTextStyle.kWhite17W400Roboto)
                                  ])),
                              SizedBox(width: Get.width * .08),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    counterSets++;
                                  });
                                  log(' plus $counterSets');
                                },
                                child: CircleAvatar(
                                  radius: Get.height * .03,
                                  backgroundColor: ColorUtils.kTint,
                                  child:
                                      Icon(Icons.add, color: ColorUtils.kBlack),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Get.height * 0.01),
                      child: Container(
                        height: Get.height * .1,
                        width: Get.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: ColorUtilsGradient.kGrayGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.topCenter),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  log('minus $counterReps');

                                  setState(() {
                                    if (counterReps > 0) counterReps--;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: Get.height * .03,
                                  backgroundColor: ColorUtils.kTint,
                                  child: Icon(Icons.remove,
                                      color: ColorUtils.kBlack),
                                ),
                              ),
                              SizedBox(width: Get.width * .08),
                              RichText(
                                  text: TextSpan(
                                      text: '$counterReps\t',
                                      style: counterReps == 0
                                          ? FontTextStyle.kWhite24BoldRoboto
                                              .copyWith(color: ColorUtils.kGray)
                                          : FontTextStyle.kWhite24BoldRoboto,
                                      children: [
                                    TextSpan(
                                        text: 'reps',
                                        style: FontTextStyle.kWhite17W400Roboto)
                                  ])),
                              SizedBox(width: Get.width * .08),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    counterReps++;
                                  });
                                  log(' plus $counterReps');
                                },
                                child: CircleAvatar(
                                  radius: Get.height * .03,
                                  backgroundColor: ColorUtils.kTint,
                                  child:
                                      Icon(Icons.add, color: ColorUtils.kBlack),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Get.height * 0.01),
                      child: Container(
                        height: Get.height * .1,
                        width: Get.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: ColorUtilsGradient.kGrayGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.topCenter),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  log('minus $counterReps');

                                  setState(() {
                                    if (counterTime > Duration(seconds: 0))
                                      counterTime - timerPM;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: Get.height * .03,
                                  backgroundColor: ColorUtils.kTint,
                                  child: Icon(Icons.remove,
                                      color: ColorUtils.kBlack),
                                ),
                              ),
                              SizedBox(width: Get.width * .08),
                              RichText(
                                  text: TextSpan(
                                      text: '${counterTime}\t',
                                      style: counterTime == Duration(seconds: 0)
                                          ? FontTextStyle.kWhite24BoldRoboto
                                              .copyWith(color: ColorUtils.kGray)
                                          : FontTextStyle.kWhite24BoldRoboto,
                                      children: [
                                    TextSpan(
                                        text: 'Time',
                                        style: FontTextStyle.kWhite17W400Roboto)
                                  ])),
                              SizedBox(width: Get.width * .08),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    counterTime + timerPM;
                                  });
                                  log(' plus timer $counterTime');
                                },
                                child: CircleAvatar(
                                  radius: Get.height * .03,
                                  backgroundColor: ColorUtils.kTint,
                                  child:
                                      Icon(Icons.add, color: ColorUtils.kBlack),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    // ListView.builder(
                    //     physics: NeverScrollableScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemCount:
                    //         int.parse(widget.data[0].exerciseSets!.toString()),
                    //     itemBuilder: (_, index) {
                    //       return NoWeightedCounter(
                    //         counter: repsCounter,
                    //         repsNo: '${widget.data[0].exerciseReps}',
                    //       );
                    //     }),
                    SizedBox(height: Get.height * .02),

                    commonNevigationButton(
                        onTap: () {
                          if ('${widget.data[0].exerciseVideo}'
                              .contains('www.youtube.com')) {
                            _youTubePlayerController?.pause();
                          } else {
                            _videoPlayerController?.pause();
                            _chewieController?.pause();
                          }
                          Get.to(WeightExerciseScreen(data: widget.data));
                          setState(() {
                            repsCounter = 0;
                          });
                        },
                        name: 'Start Exercise'),
                    SizedBox(height: Get.height * .02),
                    commonNevigationButton(
                        onTap: () {
                          if ('${widget.data[0].exerciseVideo}'
                              .contains('www.youtube.com')) {
                            _youTubePlayerController?.pause();
                          } else {
                            _videoPlayerController?.pause();
                            _chewieController?.pause();
                          }
                          Get.to(WeightExerciseScreen(data: widget.data));
                          setState(() {
                            repsCounter = 0;
                          });
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
}
