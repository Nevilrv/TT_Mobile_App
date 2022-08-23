import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/share_progress_screen.dart';
import 'package:tcm/screen/workout_screen/super_set_screen.dart';
import 'package:tcm/screen/workout_screen/weighted_exercise.dart';
import 'package:tcm/screen/workout_screen/widget/workout_widgets.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_user_customized_exercise_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/workout_base_exercise_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';

// ignore: must_be_immutable
class NoWeightExerciseScreen extends StatefulWidget {
  List<WorkoutById> data;
  final String? workoutId;
  NoWeightExerciseScreen({Key? key, required this.data, this.workoutId})
      : super(key: key);
  @override
  State<NoWeightExerciseScreen> createState() => _NoWeightExerciseScreenState();
}

class _NoWeightExerciseScreenState extends State<NoWeightExerciseScreen> {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());

  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.counter_clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
      Get.put(SaveUserCustomizedExerciseViewModel());
  int totalRound = 0;
  // bool isHold = false;
  // bool isFirst = false;
  // bool isGreaterOne = false;
  @override
  void initState() {
    super.initState();
    initData();
    // initializePlayer();
  }

  initData() async {
    await _exerciseByIdViewModel.getExerciseByIdDetails(
        id: _userWorkoutsDateViewModel
            .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
    if (_exerciseByIdViewModel.apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_exerciseByIdViewModel.apiResponse.status == Status.COMPLETE) {
      _exerciseByIdViewModel.responseExe =
          _exerciseByIdViewModel.apiResponse.data;
    }
    _customizedExerciseViewModel.counterReps = int.parse(
        '${_exerciseByIdViewModel.responseExe!.data![0].exerciseReps}');
  }

  int currPlayIndex = 0;
  // Future<void> toggleVideo() async {
  //   await _videoPlayerController!.pause();
  //   currPlayIndex = currPlayIndex == 0 ? 1 : 0;
  //   await initializePlayer();
  // }

  int counterSets = 0;
  int counterTime = 0;
  String timeCounter({int? counterTime}) {
    int finalCounter = counterTime! * 15;
    var setTime = Duration(seconds: finalCounter).toString().split('.')[0];
    var formatTime = setTime.split(':');
    var finalTime = '${formatTime[1]} : ${formatTime[2]}';
    return finalTime;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExerciseByIdViewModel>(builder: (controller) {
      if (controller.apiResponse.status == Status.LOADING) {
        return ColoredBox(
          color: ColorUtils.kBlack,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorUtils.kTint,
            ),
          ),
        );
      }
      if (controller.apiResponse.status == Status.COMPLETE) {
        controller.responseExe = _exerciseByIdViewModel.apiResponse.data;

        print(
            'controller.responseExe!.data![0].exerciseType ${controller.responseExe!.data![0].exerciseType}');
        if (controller.responseExe!.data![0].exerciseType == "REPS") {
          // toggleVideo();
          return RepsScreen(
            data: widget.data,
            controller: controller,
            // isFirst: _userWorkoutsDateViewModel.isFirst,
            // isGreaterOne: _userWorkoutsDateViewModel.isGreaterOne,
            // isHold: _userWorkoutsDateViewModel.isHold,
            workoutId: widget.workoutId,
          );
        } else if (controller.responseExe!.data![0].exerciseType == "TIME") {
          return TimeScreen(
            data: widget.data,
            controller: controller,
            // isFirst: _userWorkoutsDateViewModel.isFirst,
            // isGreaterOne: _userWorkoutsDateViewModel.isGreaterOne,
            // isHold: _userWorkoutsDateViewModel.isHold,
            workoutId: widget.workoutId,
          );
        } else {
          return ColoredBox(
            color: ColorUtils.kBlack,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorUtils.kTint,
              ),
            ),
          );
        }
      } else {
        return ColoredBox(
          color: ColorUtils.kBlack,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorUtils.kTint,
            ),
          ),
        );
      }
    });
  }
}

class RepsScreen extends StatefulWidget {
  final ExerciseByIdViewModel? controller;
  // bool isHold;
  // bool isFirst;
  // bool isGreaterOne;
  List<WorkoutById> data;
  final String? workoutId;

  RepsScreen(
      {Key? key,
      this.controller,
      // this.isFirst = false,
      // this.isGreaterOne = false,
      // this.isHold = false,
      this.workoutId,
      required this.data})
      : super(key: key);

  @override
  _RepsScreenState createState() => _RepsScreenState();
}

class _RepsScreenState extends State<RepsScreen> {
  VideoPlayerController? _videoPlayerController;
  late YoutubePlayerController _youTubePlayerController;
  ChewieController? _chewieController;
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  bool isShow = false;
  Future initializePlayer() async {
    youtubeVideoID() {
      String finalLink;
      String videoID =
          '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}';
      List<String> splittedLink = videoID.split('v=');
      List<String> longLink = splittedLink.last.split('&');
      finalLink = longLink.first;
      return finalLink;
    }

    if ('${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}'
        .contains('www.youtube.com')) {
      log('_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo 111  ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');

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
      print(
          '_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');

      if (_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == null ||
          _exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == '') {
      } else {
        _videoPlayerController = VideoPlayerController.network(
            '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');
        print('started.....vide0 11');
        await Future.wait([
          _videoPlayerController!.initialize(),
        ]);
        _createChewieController();
        // setState(() {});
      }
    }
    setState(() {});
  }

  void _createChewieController() async {
    print('started.....vide0');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      showControls: true,
      showControlsOnInitialize: true,
      hideControlsTimer: const Duration(hours: 5),
    );
  }

  @override
  void dispose() {
    if (_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == null ||
        _exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == '') {
    } else {
      _youTubePlayerController.dispose();
      _videoPlayerController!.dispose();
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // initializePlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return '${widget.controller!.responseExe!.data![0].exerciseVideo}'
            .contains('www.youtube.com')
        ? YoutubePlayerBuilder(
            onExitFullScreen: () {
              // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
              // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            player: YoutubePlayer(
              controller: _youTubePlayerController,
              showVideoProgressIndicator: true,
              width: Get.width,
              progressIndicatorColor: ColorUtils.kTint,
              // aspectRatio: 16 / 9,
              progressColors: ProgressBarColors(
                  handleColor: ColorUtils.kRed,
                  playedColor: ColorUtils.kRed,
                  backgroundColor: ColorUtils.kGray,
                  bufferedColor: ColorUtils.kLightGray),
            ),
            builder: (context, player) {
              return GestureDetector(
                // onHorizontalDragUpdate: (details) async {
                //   print("hello ${details.localPosition}");
                //   print("hello ${details.localPosition.dx}");
                //   print("hello ${details.globalPosition.distance}");
                //
                //   if (details.localPosition.dx < 100.0) {
                //     //SWIPE FROM RIGHT DETECTION
                //     print("hello ");
                //     _userWorkoutsDateViewModel.getBackId(
                //         counter: _userWorkoutsDateViewModel.exeIdCounter);
                //     if (_userWorkoutsDateViewModel.exeIdCounter <
                //         _userWorkoutsDateViewModel.exerciseId.length) {
                //       await widget.controller!.getExerciseByIdDetails(
                //           id: _userWorkoutsDateViewModel
                //               .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
                //       if (widget.controller!.apiResponse.status == Status.LOADING) {
                //         Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       }
                //       if (widget.controller!.apiResponse.status == Status.COMPLETE) {
                //         widget.controller!.responseExe =
                //             widget.controller!.apiResponse.data;
                //       }
                //     }
                //     if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                //       widget.isFirst = true;
                //     }
                //     if (widget.isFirst == true) {
                //       if (widget.isGreaterOne == false) {
                //         Get.back();
                //       }
                //       if (widget.isHold == true) {
                //         Get.back();
                //         widget.isHold = false;
                //         widget.isFirst = false;
                //       } else {
                //         widget.isHold = true;
                //       }
                //     }
                //   }
                // },
                child: WillPopScope(
                  onWillPop: () async {
                    _userWorkoutsDateViewModel.getBackId(
                        counter: _userWorkoutsDateViewModel.exeIdCounter);
                    if (_userWorkoutsDateViewModel.exeIdCounter <
                        _userWorkoutsDateViewModel.exerciseId.length) {
                      await widget.controller!.getExerciseByIdDetails(
                          id: _userWorkoutsDateViewModel.exerciseId[
                              _userWorkoutsDateViewModel.exeIdCounter]);
                      if (widget.controller!.apiResponse.status ==
                          Status.LOADING) {
                        Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (widget.controller!.apiResponse.status ==
                          Status.COMPLETE) {
                        widget.controller!.responseExe =
                            widget.controller!.apiResponse.data;
                      }
                    }
                    if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                      _userWorkoutsDateViewModel.isFirst = true;
                    }
                    if (_userWorkoutsDateViewModel.isFirst == true) {
                      if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                        _youTubePlayerController.pause();
                        Get.back();
                      }
                      if (_userWorkoutsDateViewModel.isHold == true) {
                        _youTubePlayerController.pause();
                        _userWorkoutsDateViewModel.isHold = false;
                        _userWorkoutsDateViewModel.isFirst = false;
                        Get.back();
                      } else {
                        _userWorkoutsDateViewModel.isHold = true;
                      }
                    }

                    return Future.value(false);
                  },
                  child: Scaffold(
                    backgroundColor: ColorUtils.kBlack,
                    appBar: AppBar(
                      elevation: 0,
                      leading: IconButton(
                          onPressed: () async {
                            _userWorkoutsDateViewModel.getBackId(
                                counter:
                                    _userWorkoutsDateViewModel.exeIdCounter);
                            if (_userWorkoutsDateViewModel.exeIdCounter <
                                _userWorkoutsDateViewModel.exerciseId.length) {
                              await widget.controller!.getExerciseByIdDetails(
                                  id: _userWorkoutsDateViewModel.exerciseId[
                                      _userWorkoutsDateViewModel.exeIdCounter]);
                              if (widget.controller!.apiResponse.status ==
                                  Status.LOADING) {
                                Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (widget.controller!.apiResponse.status ==
                                  Status.COMPLETE) {
                                widget.controller!.responseExe =
                                    widget.controller!.apiResponse.data;
                              }
                            }
                            if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                              _userWorkoutsDateViewModel.isFirst = true;
                            }
                            if (_userWorkoutsDateViewModel.isFirst == true) {
                              if (_userWorkoutsDateViewModel.isGreaterOne ==
                                  false) {
                                print('back........1');
                                Get.back();
                              }
                              if (_userWorkoutsDateViewModel.isHold == true) {
                                print('back........2');
                                Get.back();
                                _userWorkoutsDateViewModel.isHold = false;
                                _userWorkoutsDateViewModel.isFirst = false;
                              } else {
                                _userWorkoutsDateViewModel.isHold = true;
                              }
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: ColorUtils.kTint,
                          )),
                      backgroundColor: ColorUtils.kBlack,
                      title: Text('Warm-Up',
                          style: FontTextStyle.kWhite16BoldRoboto),
                      centerTitle: true,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.offAll(HomeScreen());
                              _userWorkoutsDateViewModel.exeIdCounter = 0;
                              _userWorkoutsDateViewModel.isHold = false;
                              _userWorkoutsDateViewModel.isFirst = false;
                            },
                            child: Text(
                              'Quit',
                              style: FontTextStyle.kTine16W400Roboto,
                            ))
                      ],
                    ),
                    body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Edit",
                                    style: FontTextStyle.kTint16BoldRoboto,
                                  )),
                              SizedBox(
                                height: Get.height * 0.015,
                              ),
                              Container(
                                width: Get.width * 0.7,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                          style:
                                              FontTextStyle.kWhite24BoldRoboto,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          log('hello...');
                                          setState(() {
                                            if (isShow == true) {
                                              isShow = false;
                                              _youTubePlayerController !=
                                                          null ||
                                                      _youTubePlayerController !=
                                                          ''
                                                  ? _youTubePlayerController
                                                      .pause()
                                                  : SizedBox();
                                            } else {
                                              if (_exerciseByIdViewModel
                                                          .responseExe!
                                                          .data![0]
                                                          .exerciseVideo ==
                                                      null ||
                                                  _exerciseByIdViewModel
                                                          .responseExe!
                                                          .data![0]
                                                          .exerciseVideo ==
                                                      '') {
                                              } else {
                                                log('_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo 111  ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');
                                                youtubeVideoID() {
                                                  String finalLink;
                                                  String videoID =
                                                      '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}';
                                                  List<String> splittedLink =
                                                      videoID.split('v=');
                                                  List<String> longLink =
                                                      splittedLink.last
                                                          .split('&');
                                                  finalLink = longLink.first;
                                                  return finalLink;
                                                }

                                                _youTubePlayerController =
                                                    YoutubePlayerController(
                                                  initialVideoId:
                                                      youtubeVideoID(),
                                                  flags: YoutubePlayerFlags(
                                                    autoPlay: true,
                                                    mute: false,
                                                    controlsVisibleAtStart:
                                                        true,
                                                    hideControls: false,
                                                    loop: true,
                                                  ),
                                                );
                                              }
                                              isShow = true;
                                            }
                                          });
                                        },
                                        child: Image.asset(
                                          AppIcons.play,
                                          height: Get.height * 0.03,
                                          width: Get.height * 0.03,
                                          color: ColorUtils.kTint,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.015,
                              ),
                              Text(
                                  '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                                  style: FontTextStyle.kLightGray16W300Roboto
                                      .copyWith(
                                          fontSize: Get.height * 0.023,
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w300)),
                              isShow == true
                                  ? Container(
                                      height: Get.height / 3,
                                      width: Get.width,
                                      child: Center(
                                        child: _youTubePlayerController !=
                                                    null ||
                                                _youTubePlayerController != ''
                                            ? player
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                color: ColorUtils.kTint,
                                              )),
                                      ))
                                  : SizedBox(),
                              SizedBox(
                                height: isShow == true
                                    ? Get.height * 0.02
                                    : Get.height * 0.06,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * .06,
                                ),
                                child: Container(
                                  height: Get.height * 0.68,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GetBuilder<
                                                SaveUserCustomizedExerciseViewModel>(
                                            builder: (controllerSave) {
                                          return Container(
                                            height: Get.height * 0.57,
                                            color: Colors.red,
                                            child: ListView.builder(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                itemCount: int.parse(widget
                                                    .controller!
                                                    .responseExe!
                                                    .data![0]
                                                    .exerciseSets
                                                    .toString()),
                                                itemBuilder: (_, index) {
                                                  return NoWeightedCounter(
                                                    counter: int.parse(
                                                        '${widget.controller!.responseExe!.data![0].exerciseReps}'),
                                                    repsNo:
                                                        '${widget.controller!.responseExe!.data![0].exerciseReps}',
                                                  );
                                                }),
                                          );
                                        }),
                                        Spacer(),
                                        commonNavigationButton(
                                            onTap: () async {
                                              _userWorkoutsDateViewModel.getExeId(
                                                  counter:
                                                      _userWorkoutsDateViewModel
                                                          .exeIdCounter);
                                              if (_userWorkoutsDateViewModel
                                                      .exeIdCounter <
                                                  _userWorkoutsDateViewModel
                                                      .exerciseId.length) {
                                                if (_userWorkoutsDateViewModel
                                                        .exeIdCounter >
                                                    0) {
                                                  _userWorkoutsDateViewModel
                                                      .isGreaterOne = true;
                                                  print(
                                                      "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                                }
                                                await widget.controller!
                                                    .getExerciseByIdDetails(
                                                        id: _userWorkoutsDateViewModel
                                                                .exerciseId[
                                                            _userWorkoutsDateViewModel
                                                                .exeIdCounter]);
                                                if (widget.controller!
                                                        .apiResponse.status ==
                                                    Status.LOADING) {
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                if (widget.controller!
                                                        .apiResponse.status ==
                                                    Status.COMPLETE) {
                                                  widget.controller!
                                                          .responseExe =
                                                      widget.controller!
                                                          .apiResponse.data;

                                                  _videoPlayerController
                                                      ?.pause();
                                                  _chewieController?.pause();
                                                }
                                              }
                                              if (_userWorkoutsDateViewModel
                                                      .exeIdCounter ==
                                                  _userWorkoutsDateViewModel
                                                      .exerciseId.length) {
                                                Get.to(ShareProgressScreen(
                                                  exeData: widget.controller!
                                                      .responseExe!.data!,
                                                  data: widget.data,
                                                  workoutId: widget.workoutId,
                                                ));
                                                _userWorkoutsDateViewModel
                                                    .isFirst = false;
                                                _userWorkoutsDateViewModel
                                                    .isHold = false;
                                                _videoPlayerController!.pause();
                                                _chewieController!.pause();
                                              }
                                            },
                                            name: widget
                                                        .controller!
                                                        .responseExe!
                                                        .data![0]
                                                        .exerciseId ==
                                                    _userWorkoutsDateViewModel
                                                        .exerciseId.last
                                                ? 'Save Exercise'
                                                : 'Next Exercise')
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.07,
                              ),
                            ]) /* Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: Get.height / 3,
                                width: Get.width,
                                child: Center(
                                  child: _youTubePlayerController != null ||
                                          _youTubePlayerController != ''
                                      ? player
                                      : Center(
                                          child: CircularProgressIndicator(
                                          color: ColorUtils.kTint,
                                        )),
                                )),
                            // Container(
                            //   height: Get.height / 2.75,
                            //   width: Get.width,
                            //   child:
                            //       '${widget.controller!.responseExe!.data![0].exerciseVideo}'
                            //               .contains('www.youtube.com')
                            //           ? Center(
                            //               child: _youTubePlayerController != null ||
                            //                       // ignore: unrelated_type_equality_checks
                            //                       _youTubePlayerController != ''
                            //                   ? YoutubePlayer(
                            //                       controller: _youTubePlayerController!,
                            //                       showVideoProgressIndicator: true,
                            //                       bufferIndicator: CircularProgressIndicator(
                            //                           color: ColorUtils.kTint),
                            //                       controlsTimeOut: Duration(hours: 2),
                            //                       aspectRatio: 16 / 9,
                            //                       progressColors: ProgressBarColors(
                            //                           handleColor: ColorUtils.kRed,
                            //                           playedColor: ColorUtils.kRed,
                            //                           backgroundColor: ColorUtils.kGray,
                            //                           bufferedColor: ColorUtils.kLightGray),
                            //                     )
                            //                   : noDataLottie(),
                            //             )
                            //           : Center(
                            //               child: _chewieController != null &&
                            //                       _chewieController!.videoPlayerController
                            //                           .value.isInitialized
                            //                   ? Chewie(
                            //                       controller: _chewieController!,
                            //                     )
                            //                   : widget.controller!.responseExe!.data![0]
                            //                               .exerciseImage ==
                            //                           null
                            //                       ? noDataLottie()
                            //                       : Image.network(
                            //                           "https://tcm.sataware.dev/images/" +
                            //                               widget.controller!.responseExe!
                            //                                   .data![0].exerciseImage!,
                            //                           errorBuilder:
                            //                               (context, error, stackTrace) {
                            //                             return noDataLottie();
                            //                           },
                            //                         )),
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * .06,
                                  vertical: Get.height * .02),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                      style: FontTextStyle.kWhite24BoldRoboto,
                                    ),
                                    SizedBox(height: Get.height * .005),
                                    Text(
                                      '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                                      style:
                                          FontTextStyle.kLightGray16W300Roboto,
                                    ),
                                    GetBuilder<
                                            SaveUserCustomizedExerciseViewModel>(
                                        builder: (controllerSave) {
                                      return SizedBox(
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: int.parse(widget
                                                .controller!
                                                .responseExe!
                                                .data![0]
                                                .exerciseSets
                                                .toString()),
                                            itemBuilder: (_, index) {
                                              return NoWeightedCounter(
                                                counter: int.parse(
                                                    '${widget.controller!.responseExe!.data![0].exerciseReps}'),
                                                repsNo:
                                                    '${widget.controller!.responseExe!.data![0].exerciseReps}',
                                              );
                                            }),
                                      );
                                    }),
                                    SizedBox(height: Get.height * .02),
                                    commonNavigationButton(
                                        onTap: () async {
                                          _userWorkoutsDateViewModel.getExeId(
                                              counter:
                                                  _userWorkoutsDateViewModel
                                                      .exeIdCounter);
                                          if (_userWorkoutsDateViewModel
                                                  .exeIdCounter <
                                              _userWorkoutsDateViewModel
                                                  .exerciseId.length) {
                                            if (_userWorkoutsDateViewModel
                                                    .exeIdCounter >
                                                0) {
                                              _userWorkoutsDateViewModel
                                                  .isGreaterOne = true;
                                            }
                                            await widget.controller!
                                                .getExerciseByIdDetails(
                                                    id: _userWorkoutsDateViewModel
                                                            .exerciseId[
                                                        _userWorkoutsDateViewModel
                                                            .exeIdCounter]);
                                            if (widget.controller!.apiResponse
                                                    .status ==
                                                Status.LOADING) {
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            if (widget.controller!.apiResponse
                                                    .status ==
                                                Status.COMPLETE) {
                                              widget.controller!.responseExe =
                                                  widget.controller!.apiResponse
                                                      .data;
                                              _youTubePlayerController.pause();
                                            }
                                          }
                                          if (_userWorkoutsDateViewModel
                                                  .exeIdCounter ==
                                              _userWorkoutsDateViewModel
                                                  .exerciseId.length) {
                                            Get.to(ShareProgressScreen(
                                              exeData: widget.controller!
                                                  .responseExe!.data!,
                                              data: widget.data,
                                              workoutId: widget.workoutId,
                                            ));
                                            _youTubePlayerController.pause();

                                            _userWorkoutsDateViewModel.isFirst =
                                                false;
                                            _userWorkoutsDateViewModel.isHold =
                                                false;
                                          }
                                        },
                                        name: widget.controller!.responseExe!
                                                    .data![0].exerciseId ==
                                                _userWorkoutsDateViewModel
                                                    .exerciseId.last
                                            ? 'Save Exercise'
                                            : 'Next Exercise')
                                  ]),
                            ),
                          ]),*/
                        ),
                  ),
                ),
              );
            })
        : GestureDetector(
            // onHorizontalDragUpdate: (details) async {
            //   print("hello ${details.localPosition}");
            //   print("hello ${details.localPosition.dx}");
            //   print("hello ${details.globalPosition.distance}");
            //
            //   if (details.localPosition.dx < 100.0) {
            //     //SWIPE FROM RIGHT DETECTION
            //     print("hello ");
            //     _userWorkoutsDateViewModel.getBackId(
            //         counter: _userWorkoutsDateViewModel.exeIdCounter);
            //     if (_userWorkoutsDateViewModel.exeIdCounter <
            //         _userWorkoutsDateViewModel.exerciseId.length) {
            //       await widget.controller!.getExerciseByIdDetails(
            //           id: _userWorkoutsDateViewModel
            //               .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
            //       if (widget.controller!.apiResponse.status == Status.LOADING) {
            //         Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       if (widget.controller!.apiResponse.status == Status.COMPLETE) {
            //         widget.controller!.responseExe =
            //             widget.controller!.apiResponse.data;
            //       }
            //     }
            //     if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
            //       widget.isFirst = true;
            //     }
            //     if (widget.isFirst == true) {
            //       if (widget.isGreaterOne == false) {
            //         Get.back();
            //       }
            //       if (widget.isHold == true) {
            //         Get.back();
            //         widget.isHold = false;
            //         widget.isFirst = false;
            //       } else {
            //         widget.isHold = true;
            //       }
            //     }
            //   }
            // },
            child: WillPopScope(
              onWillPop: () async {
                _userWorkoutsDateViewModel.getBackId(
                    counter: _userWorkoutsDateViewModel.exeIdCounter);
                if (_userWorkoutsDateViewModel.exeIdCounter <
                    _userWorkoutsDateViewModel.exerciseId.length) {
                  await widget.controller!.getExerciseByIdDetails(
                      id: _userWorkoutsDateViewModel
                          .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
                  if (widget.controller!.apiResponse.status == Status.LOADING) {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (widget.controller!.apiResponse.status ==
                      Status.COMPLETE) {
                    widget.controller!.responseExe =
                        widget.controller!.apiResponse.data;
                  }
                }
                if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                  _userWorkoutsDateViewModel.isFirst = true;
                }
                if (_userWorkoutsDateViewModel.isFirst == true) {
                  if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                    _videoPlayerController!.pause();
                    _chewieController!.pause();
                    Get.back();
                  }
                  if (_userWorkoutsDateViewModel.isHold == true) {
                    _videoPlayerController!.pause();
                    _chewieController!.pause();

                    _userWorkoutsDateViewModel.isHold = false;
                    _userWorkoutsDateViewModel.isFirst = false;
                    Get.back();
                  } else {
                    _userWorkoutsDateViewModel.isHold = true;
                  }
                }

                return Future.value(false);
              },
              child: Scaffold(
                backgroundColor: ColorUtils.kBlack,
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () async {
                        _userWorkoutsDateViewModel.getBackId(
                            counter: _userWorkoutsDateViewModel.exeIdCounter);
                        if (_userWorkoutsDateViewModel.exeIdCounter <
                            _userWorkoutsDateViewModel.exerciseId.length) {
                          await widget.controller!.getExerciseByIdDetails(
                              id: _userWorkoutsDateViewModel.exerciseId[
                                  _userWorkoutsDateViewModel.exeIdCounter]);
                          if (widget.controller!.apiResponse.status ==
                              Status.LOADING) {
                            Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (widget.controller!.apiResponse.status ==
                              Status.COMPLETE) {
                            widget.controller!.responseExe =
                                widget.controller!.apiResponse.data;
                          }
                        }
                        if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                          _userWorkoutsDateViewModel.isFirst = true;
                        }
                        if (_userWorkoutsDateViewModel.isFirst == true) {
                          if (_userWorkoutsDateViewModel.isGreaterOne ==
                              false) {
                            print('back........1');
                            print('greater one ........false call');
                            _videoPlayerController!.pause();
                            _chewieController!.pause();
                            Get.back();
                          }
                          if (_userWorkoutsDateViewModel.isHold == true) {
                            print('back........2');
                            print('hold true........call');

                            _videoPlayerController!.pause();
                            _chewieController!.pause();
                            _userWorkoutsDateViewModel.isHold = false;
                            _userWorkoutsDateViewModel.isFirst = false;
                            Get.back();
                          } else {
                            _userWorkoutsDateViewModel.isHold = true;
                          }
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: ColorUtils.kTint,
                      )),
                  backgroundColor: ColorUtils.kBlack,
                  title:
                      Text('Warm-Up', style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.offAll(HomeScreen());
                          _userWorkoutsDateViewModel.exeIdCounter = 0;
                          _userWorkoutsDateViewModel.isHold = false;
                          _userWorkoutsDateViewModel.isFirst = false;
                        },
                        child: Text(
                          'Quit',
                          style: FontTextStyle.kTine16W400Roboto,
                        ))
                  ],
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * .075),
                            child: GestureDetector(
                                onTap: () {
                                  Get.to(WeightExerciseScreen(
                                      data: widget
                                          .controller!.responseExe!.data!));
                                },
                                child: Text(
                                  "Edit",
                                  style: FontTextStyle.kTint16BoldRoboto,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.015,
                        ),
                        Container(
                          width: Get.width * 0.7,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                    style: FontTextStyle.kWhite24BoldRoboto,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    log('hello...');
                                    if (isShow == true) {
                                      setState(() {
                                        isShow = false;
                                      });

                                      if (_chewieController != null &&
                                          _chewieController!
                                              .videoPlayerController
                                              .value
                                              .isInitialized) {
                                        _chewieController!.pause();
                                        _videoPlayerController!.pause();
                                      } else {
                                        SizedBox();
                                      }
                                    } else {
                                      print(
                                          '_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');

                                      if (_exerciseByIdViewModel.responseExe!
                                                  .data![0].exerciseVideo ==
                                              null ||
                                          _exerciseByIdViewModel.responseExe!
                                                  .data![0].exerciseVideo ==
                                              '') {
                                      } else {
                                        _videoPlayerController =
                                            VideoPlayerController.network(
                                                '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');
                                        print('started.....vide0 11');
                                        await Future.wait([
                                          _videoPlayerController!.initialize(),
                                        ]);
                                        _createChewieController();
                                        // setState(() {});
                                      }
                                      setState(() {
                                        isShow = true;
                                      });
                                    }
                                    log('hello...1 $isShow');
                                  },
                                  child: Image.asset(
                                    AppIcons.play,
                                    height: Get.height * 0.03,
                                    width: Get.height * 0.03,
                                    color: ColorUtils.kTint,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.015,
                        ),
                        Text(
                            '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                            style: FontTextStyle.kLightGray16W300Roboto
                                .copyWith(
                                    fontSize: Get.height * 0.023,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w300)),
                        isShow == true
                            ? Container(
                                height: Get.height / 2.75,
                                width: Get.width,
                                child: Center(
                                    child: _chewieController != null &&
                                            _chewieController!
                                                .videoPlayerController
                                                .value
                                                .isInitialized
                                        ? Chewie(
                                            controller: _chewieController!,
                                          )
                                        : widget.controller!.responseExe!
                                                    .data![0].exerciseImage ==
                                                null
                                            ? noDataLottie()
                                            : Image.network(
                                                "https://tcm.sataware.dev/images/" +
                                                    widget
                                                        .controller!
                                                        .responseExe!
                                                        .data![0]
                                                        .exerciseImage!
                                                        .split("\/")
                                                        .last,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return noDataLottie();
                                                },
                                              ))

                                // Center(
                                //   child: _chewieController != null &&
                                //           _chewieController!.videoPlayerController
                                //               .value.isInitialized
                                //       ? Chewie(
                                //           controller: _chewieController!,
                                //         )
                                //       : Center(
                                //           child: CircularProgressIndicator(
                                //           color: ColorUtils.kTint,
                                //         )),
                                // ),
                                )
                            : SizedBox(),
                        SizedBox(
                          height: isShow == true
                              ? Get.height * 0.02
                              : Get.height * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * .06,
                          ),
                          child: Container(
                            height: Get.height * 0.68,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GetBuilder<
                                          SaveUserCustomizedExerciseViewModel>(
                                      builder: (controllerSave) {
                                    return Container(
                                      height: Get.height * 0.57,
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 0),
                                          itemCount: int.parse(widget
                                              .controller!
                                              .responseExe!
                                              .data![0]
                                              .exerciseSets
                                              .toString()),
                                          itemBuilder: (_, index) {
                                            return NoWeightedCounter(
                                              counter: int.parse(
                                                  '${widget.controller!.responseExe!.data![0].exerciseReps}'),
                                              repsNo:
                                                  '${widget.controller!.responseExe!.data![0].exerciseReps}',
                                            );
                                          }),
                                    );
                                  }),
                                  Spacer(),
                                  commonNavigationButton(
                                      onTap: () async {
                                        _userWorkoutsDateViewModel.getExeId(
                                            counter: _userWorkoutsDateViewModel
                                                .exeIdCounter);
                                        if (_userWorkoutsDateViewModel
                                                .exeIdCounter <
                                            _userWorkoutsDateViewModel
                                                .exerciseId.length) {
                                          if (_userWorkoutsDateViewModel
                                                  .exeIdCounter >
                                              0) {
                                            _userWorkoutsDateViewModel
                                                .isGreaterOne = true;
                                            print(
                                                "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                          }
                                          await widget.controller!
                                              .getExerciseByIdDetails(
                                                  id: _userWorkoutsDateViewModel
                                                          .exerciseId[
                                                      _userWorkoutsDateViewModel
                                                          .exeIdCounter]);
                                          if (widget.controller!.apiResponse
                                                  .status ==
                                              Status.LOADING) {
                                            Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (widget.controller!.apiResponse
                                                  .status ==
                                              Status.COMPLETE) {
                                            widget.controller!.responseExe =
                                                widget.controller!.apiResponse
                                                    .data;

                                            _videoPlayerController!.pause();
                                            _chewieController!.pause();
                                          }
                                        }
                                        if (_userWorkoutsDateViewModel
                                                .exeIdCounter ==
                                            _userWorkoutsDateViewModel
                                                .exerciseId.length) {
                                          Get.to(ShareProgressScreen(
                                            exeData: widget
                                                .controller!.responseExe!.data!,
                                            data: widget.data,
                                            workoutId: widget.workoutId,
                                          ));
                                          _userWorkoutsDateViewModel.isFirst =
                                              false;
                                          _userWorkoutsDateViewModel.isHold =
                                              false;
                                          _videoPlayerController!.pause();
                                          _chewieController!.pause();
                                        }
                                      },
                                      name: widget.controller!.responseExe!
                                                  .data![0].exerciseId ==
                                              _userWorkoutsDateViewModel
                                                  .exerciseId.last
                                          ? 'Save Exercise'
                                          : 'Next Exercise')
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                      ]),
                ),
              ),
            ),
          );
  }
}

class TimeScreen extends StatefulWidget {
  final ExerciseByIdViewModel? controller;
  // bool isHold;
  // bool isFirst;
  // bool isGreaterOne;
  List<WorkoutById> data;
  final String? workoutId;

  TimeScreen(
      {Key? key,
      this.controller,
      // this.isFirst = false,
      // this.isGreaterOne = false,
      // this.isHold = false,
      this.workoutId,
      required this.data})
      : super(key: key);

  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen>
    with SingleTickerProviderStateMixin {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  VideoPlayerController? _videoPlayerController;
  late YoutubePlayerController _youTubePlayerController;
  ChewieController? _chewieController;
  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.counter_clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
      Get.put(SaveUserCustomizedExerciseViewModel());
  int totalRound = 0;
  bool isShow = false;
  timeDuration() {
    String time =
        '${_exerciseByIdViewModel.responseExe!.data![0].exerciseTime}';
    List<String> splittedTime = time.split(' ');
    print('------------- ${splittedTime.first}');
    int? timer;
    if (splittedTime.first.length == 1) {
      timer = int.parse(splittedTime.first) * 60;
      print(' ----------  timer $timer');
      return timer;
    } else if (splittedTime.first.length >= 2) {
      timer = int.parse(splittedTime.first);
      print('timer -==-=-=-=-=-= $timer');
      return timer;
    }
  }

  @override
  void dispose() {
    if (_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == null ||
        _exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == '') {
    } else {
      _youTubePlayerController.dispose();
      _videoPlayerController!.dispose();
      _chewieController!.dispose();
    }

    super.dispose();
  }

  Future initializePlayer() async {
    youtubeVideoID() {
      String finalLink;
      String videoID =
          '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}';
      List<String> splittedLink = videoID.split('v=');
      List<String> longLink = splittedLink.last.split('&');
      finalLink = longLink.first;
      return finalLink;
    }

    if ('${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}'
        .contains('www.youtube.com')) {
      log('_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo 111  ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');

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
      print(
          '_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');

      if (_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == null ||
          _exerciseByIdViewModel.responseExe!.data![0].exerciseVideo == '') {
      } else {
        _videoPlayerController = VideoPlayerController.network(
            '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');
        print('started.....vide0 11');
        await Future.wait([
          _videoPlayerController!.initialize(),
        ]);
        _createChewieController();
        // setState(() {});
      }
    }
    setState(() {});
  }

  void _createChewieController() async {
    print('started.....vide0');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      showControls: true,
      showControlsOnInitialize: true,
      hideControlsTimer: const Duration(hours: 5),
    );
  }

  @override
  void initState() {
    _timerController = TimerController(this);

    timeDuration();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if ('${widget.controller!.responseExe!.data![0].exerciseVideo}'
        .contains('www.youtube.com')) {
      return YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _youTubePlayerController,
            showVideoProgressIndicator: true,
            width: Get.width,
            progressIndicatorColor: ColorUtils.kTint,
            // aspectRatio: 16 / 9,
            progressColors: ProgressBarColors(
                handleColor: ColorUtils.kRed,
                playedColor: ColorUtils.kRed,
                backgroundColor: ColorUtils.kGray,
                bufferedColor: ColorUtils.kLightGray),
          ),
          builder: (context, player) {
            return GestureDetector(
              // onHorizontalDragUpdate: (details) async {
              //   print("hello ${details.localPosition}");
              //   print("hello ${details.localPosition.dx}");
              //   print("hello ${details.globalPosition.distance}");
              //
              //   if (details.localPosition.dx < 100.0) {
              //     //SWIPE FROM RIGHT DETECTION
              //     print("hello ");
              //
              //     _timerController!.reset();
              //     setState(() {
              //       totalRound = 0;
              //     });
              //     _userWorkoutsDateViewModel.getBackId(
              //         counter: _userWorkoutsDateViewModel.exeIdCounter);
              //     if (_userWorkoutsDateViewModel.exeIdCounter <
              //         _userWorkoutsDateViewModel.exerciseId.length) {
              //       await widget.controller!.getExerciseByIdDetails(
              //           id: _userWorkoutsDateViewModel
              //               .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
              //       if (widget.controller!.apiResponse.status == Status.LOADING) {
              //         Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //       if (widget.controller!.apiResponse.status == Status.COMPLETE) {
              //         widget.controller!.responseExe =
              //             widget.controller!.apiResponse.data;
              //       }
              //     }
              //     if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
              //       widget.isFirst = true;
              //     }
              //     if (widget.isFirst == true) {
              //       if (widget.isGreaterOne == false) {
              //         Get.back();
              //       }
              //       if (widget.isHold == true) {
              //         Get.back();
              //         widget.isHold = false;
              //         widget.isFirst = false;
              //       } else {
              //         widget.isHold = true;
              //       }
              //     }
              //     _videoPlayerController!.pause();
              //     _chewieController!.pause();
              //     _youTubePlayerController!.pause();
              //   }
              // },
              child: WillPopScope(
                onWillPop: () async {
                  _timerController!.reset();
                  setState(() {
                    totalRound = 0;
                  });
                  _userWorkoutsDateViewModel.getBackId(
                      counter: _userWorkoutsDateViewModel.exeIdCounter);
                  if (_userWorkoutsDateViewModel.exeIdCounter <
                      _userWorkoutsDateViewModel.exerciseId.length) {
                    await widget.controller!.getExerciseByIdDetails(
                        id: _userWorkoutsDateViewModel.exerciseId[
                            _userWorkoutsDateViewModel.exeIdCounter]);
                    if (widget.controller!.apiResponse.status ==
                        Status.LOADING) {
                      Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (widget.controller!.apiResponse.status ==
                        Status.COMPLETE) {
                      widget.controller!.responseExe =
                          widget.controller!.apiResponse.data;
                    }
                  }
                  if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                    _userWorkoutsDateViewModel.isFirst = true;
                  }
                  if (_userWorkoutsDateViewModel.isFirst == true) {
                    if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                      Get.back();
                    }
                    if (_userWorkoutsDateViewModel.isHold == true) {
                      Get.back();
                      _userWorkoutsDateViewModel.isHold = false;
                      _userWorkoutsDateViewModel.isFirst = false;
                    } else {
                      _userWorkoutsDateViewModel.isHold = true;
                    }
                  }
                  return Future.value(false);
                },
                child: Scaffold(
                  backgroundColor: ColorUtils.kBlack,
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () async {
                          _timerController!.reset();
                          setState(() {
                            totalRound = 0;
                          });

                          _userWorkoutsDateViewModel.getBackId(
                              counter: _userWorkoutsDateViewModel.exeIdCounter);
                          if (_userWorkoutsDateViewModel.exeIdCounter <
                              _userWorkoutsDateViewModel.exerciseId.length) {
                            await widget.controller!.getExerciseByIdDetails(
                                id: _userWorkoutsDateViewModel.exerciseId[
                                    _userWorkoutsDateViewModel.exeIdCounter]);
                            if (widget.controller!.apiResponse.status ==
                                Status.LOADING) {
                              Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (widget.controller!.apiResponse.status ==
                                Status.COMPLETE) {
                              widget.controller!.responseExe =
                                  widget.controller!.apiResponse.data;
                            }
                          }
                          if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                            _userWorkoutsDateViewModel.isFirst = true;
                          }
                          if (_userWorkoutsDateViewModel.isFirst == true) {
                            if (_userWorkoutsDateViewModel.isGreaterOne ==
                                false) {
                              print('back........1');
                              Get.back();
                            }
                            if (_userWorkoutsDateViewModel.isHold == true) {
                              print('back........2');
                              Get.back();
                              _userWorkoutsDateViewModel.isHold = false;
                              _userWorkoutsDateViewModel.isFirst = false;
                            } else {
                              _userWorkoutsDateViewModel.isHold = true;
                            }
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          color: ColorUtils.kTint,
                        )),
                    backgroundColor: ColorUtils.kBlack,
                    title: Text('Warm-Up',
                        style: FontTextStyle.kWhite16BoldRoboto),
                    centerTitle: true,
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.offAll(HomeScreen());
                            _userWorkoutsDateViewModel.exeIdCounter = 0;

                            _userWorkoutsDateViewModel.isFirst = false;
                            _userWorkoutsDateViewModel.isHold = false;

                            _timerController!.reset();
                            setState(() {
                              totalRound = 0;
                            });
                            // controller.totalRound = 0;
                          },
                          child: Text(
                            'Quit',
                            style: FontTextStyle.kTine16W400Roboto,
                          ))
                    ],
                  ),
                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * .04,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () {
                                    // Get.to(WeightExerciseScreen(
                                    //   data:
                                    //       widget.controller!.responseExe!.data!,
                                    // ));
                                    Get.to(SuperSetScreen());
                                  },
                                  child: Text(
                                    'Edit',
                                    style: FontTextStyle.kTine16W400Roboto
                                        .copyWith(fontSize: Get.height * 0.022),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Container(
                            width: Get.width * 0.7,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                      style: FontTextStyle.kWhite24BoldRoboto,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isShow == true) {
                                          isShow = false;
                                          _youTubePlayerController != null ||
                                                  _youTubePlayerController != ''
                                              ? _youTubePlayerController.pause()
                                              : SizedBox();
                                        } else {
                                          if (_exerciseByIdViewModel
                                                      .responseExe!
                                                      .data![0]
                                                      .exerciseVideo ==
                                                  null ||
                                              _exerciseByIdViewModel
                                                      .responseExe!
                                                      .data![0]
                                                      .exerciseVideo ==
                                                  '') {
                                          } else {
                                            log('_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo 111  ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');
                                            youtubeVideoID() {
                                              String finalLink;
                                              String videoID =
                                                  '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}';
                                              List<String> splittedLink =
                                                  videoID.split('v=');
                                              List<String> longLink =
                                                  splittedLink.last.split('&');
                                              finalLink = longLink.first;
                                              return finalLink;
                                            }

                                            _youTubePlayerController =
                                                YoutubePlayerController(
                                              initialVideoId: youtubeVideoID(),
                                              flags: YoutubePlayerFlags(
                                                autoPlay: true,
                                                mute: false,
                                                controlsVisibleAtStart: true,
                                                hideControls: false,
                                                loop: true,
                                              ),
                                            );
                                          }
                                          isShow = true;
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      AppIcons.play,
                                      height: Get.height * 0.03,
                                      width: Get.height * 0.03,
                                      color: ColorUtils.kTint,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Text(
                            '${widget.controller!.responseExe!.data![0].exerciseTime} seconds each set',
                            style: FontTextStyle.kLightGray16W300Roboto
                                .copyWith(
                                    fontSize: Get.height * 0.023,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          isShow == true
                              ? Container(
                                  height: Get.height / 3,
                                  width: Get.width,
                                  child: Center(
                                    child: _youTubePlayerController != null ||
                                            _youTubePlayerController != ''
                                        ? player
                                        : Center(
                                            child: CircularProgressIndicator(
                                            color: ColorUtils.kTint,
                                          )),
                                  ))
                              : SizedBox(),
                          totalRound == 0
                              ? Text(
                                  'Sets ${widget.controller!.responseExe!.data![0].exerciseSets} ',
                                  style: FontTextStyle.kLightGray16W300Roboto,
                                )
                              : Text(
                                  'Sets ${totalRound}/${widget.controller!.responseExe!.data![0].exerciseSets} ',
                                  style: FontTextStyle.kLightGray16W300Roboto,
                                ),

                          Center(
                              child: Container(
                            height: Get.height * .23,
                            width: Get.height * .23,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: SimpleTimer(
                              duration: widget.controller!.responseExe!.data![0]
                                          .exerciseTime !=
                                      ""
                                  ? Duration(
                                      seconds: int.parse(
                                          "${widget.controller!.responseExe!.data![0].exerciseTime}"))
                                  : Duration(seconds: 10),
                              controller: _timerController,
                              timerStyle: _timerStyle,
                              progressTextFormatter: (format) {
                                return '00:${format.inSeconds.toString().padLeft(2, '0')}';
                              },
                              backgroundColor: ColorUtils.kGray,
                              progressIndicatorColor: ColorUtils.kTint,
                              progressIndicatorDirection:
                                  _progressIndicatorDirection,
                              progressTextCountDirection:
                                  _progressTextCountDirection,
                              progressTextStyle: FontTextStyle
                                  .kWhite24BoldRoboto
                                  .copyWith(fontSize: Get.height * 0.03),
                              strokeWidth: 17,
                              onStart: () {
                                setState(() {
                                  totalRound = totalRound + 1;
                                });
                              },
                              onEnd: () {
                                if (totalRound !=
                                    int.parse(widget.controller!.responseExe!
                                        .data![0].exerciseSets
                                        .toString())) {
                                  _timerController!.reset();
                                } else {
                                  _timerController!.stop();
                                }
                              },
                            ),
                          )),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('Start Pressed');
                                  if (totalRound !=
                                      int.parse(widget.controller!.responseExe!
                                          .data![0].exerciseSets
                                          .toString())) {
                                    _timerController!.start();

                                    print(
                                        'controller.totalRound-------> ${totalRound}');
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: Get.height * .06,
                                  width: Get.width * .3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                      colors: ColorUtilsGradient.kTintGradient,
                                    ),
                                  ),
                                  child: Text(
                                    'Start',
                                    style: FontTextStyle.kBlack18w600Roboto
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.02),
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.05),
                              GestureDetector(
                                onTap: () {
                                  print('Reset pressed ');
                                  setState(() {
                                    totalRound = 0;
                                  });

                                  // controller.totalRound = 0;
                                  _timerController!.reset();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: Get.height * .06,
                                  width: Get.width * .3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
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
                          SizedBox(
                            height: isShow == true
                                ? Get.height * 0.02
                                : Get.height * 0.22,
                          ),
                          SizedBox(
                            width: Get.width * 0.9,
                            child: commonNavigationButton(
                                onTap: () async {
                                  _timerController!.reset();

                                  setState(() {
                                    totalRound = 0;
                                  });
                                  // controller.totalRound = 0;
                                  _userWorkoutsDateViewModel.getExeId(
                                      counter: _userWorkoutsDateViewModel
                                          .exeIdCounter);

                                  if (_userWorkoutsDateViewModel.exeIdCounter <
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter >
                                        0) {
                                      _userWorkoutsDateViewModel.isGreaterOne =
                                          true;
                                      print(
                                          "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                    }
                                    await widget.controller!
                                        .getExerciseByIdDetails(
                                            id: _userWorkoutsDateViewModel
                                                    .exerciseId[
                                                _userWorkoutsDateViewModel
                                                    .exeIdCounter]);
                                    if (widget.controller!.apiResponse.status ==
                                        Status.LOADING) {
                                      Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (widget.controller!.apiResponse.status ==
                                        Status.COMPLETE) {
                                      widget.controller!.responseExe =
                                          widget.controller!.apiResponse.data;
                                      _videoPlayerController!.pause();
                                      _chewieController!.pause();
                                    }
                                  }
                                  if (_userWorkoutsDateViewModel.exeIdCounter ==
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    Get.to(ShareProgressScreen(
                                      exeData:
                                          widget.controller!.responseExe!.data!,
                                      data: widget.data,
                                      workoutId: widget.workoutId,
                                    ));
                                    _videoPlayerController!.pause();
                                    _chewieController!.pause();

                                    _userWorkoutsDateViewModel.isFirst = false;
                                    _userWorkoutsDateViewModel.isHold = false;
                                  }
                                },
                                name: widget.controller!.responseExe!.data![0]
                                            .exerciseId ==
                                        _userWorkoutsDateViewModel
                                            .exerciseId.last
                                    ? 'Finish and Log Workout'
                                    : 'Next Exercise'),
                          )
                          // Container(
                          //     height: Get.height / 3,
                          //     width: Get.width,
                          //     child: Center(
                          //       child: _youTubePlayerController != null ||
                          //               _youTubePlayerController != ''
                          //           ? player
                          //           : Center(
                          //               child: CircularProgressIndicator(
                          //               color: ColorUtils.kTint,
                          //             )),
                          //     )),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: Get.width * .06,
                          //       vertical: Get.height * .02),
                          //   child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Text(
                          //                   '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                          //                   style: FontTextStyle
                          //                       .kWhite24BoldRoboto,
                          //                 ),
                          //                 SizedBox(height: Get.height * .005),
                          //                 Text(
                          //                   '${widget.controller!.responseExe!.data![0].exerciseTime} seconds for each set',
                          //                   style: FontTextStyle
                          //                       .kLightGray16W300Roboto,
                          //                 ),
                          //               ],
                          //             ),
                          //             Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.end,
                          //               children: [
                          //                 InkWell(
                          //                     onTap: () {
                          //                       Get.to(WeightExerciseScreen(
                          //                         data: widget.controller!
                          //                             .responseExe!.data!,
                          //                       ));
                          //                     },
                          //                     child: Text(
                          //                       'Edit',
                          //                       style: FontTextStyle
                          //                           .kTine16W400Roboto,
                          //                     )),
                          //                 SizedBox(height: Get.height * .015),
                          //                 totalRound == 0
                          //                     ? Text(
                          //                         'Sets ${widget.controller!.responseExe!.data![0].exerciseSets} ',
                          //                         style: FontTextStyle
                          //                             .kLightGray16W300Roboto,
                          //                       )
                          //                     : Text(
                          //                         'Sets ${totalRound}/${widget.controller!.responseExe!.data![0].exerciseSets} ',
                          //                         style: FontTextStyle
                          //                             .kLightGray16W300Roboto,
                          //                       ),
                          //               ],
                          //             )
                          //           ],
                          //         ),
                          //         SizedBox(height: Get.height * .04),
                          //         Center(
                          //             child: Container(
                          //           height: Get.height * .2,
                          //           width: Get.height * .2,
                          //           margin: EdgeInsets.symmetric(vertical: 10),
                          //           child: SimpleTimer(
                          //             duration: widget.controller!.responseExe!
                          //                         .data![0].exerciseTime !=
                          //                     ""
                          //                 ? Duration(
                          //                     seconds: int.parse(
                          //                         "${widget.controller!.responseExe!.data![0].exerciseTime}"))
                          //                 : Duration(seconds: 10),
                          //             controller: _timerController,
                          //             timerStyle: _timerStyle,
                          //             progressTextFormatter: (format) {
                          //               return format.inSeconds.toString();
                          //             },
                          //             backgroundColor: ColorUtils.kGray,
                          //             progressIndicatorColor: ColorUtils.kTint,
                          //             progressIndicatorDirection:
                          //                 _progressIndicatorDirection,
                          //             progressTextCountDirection:
                          //                 _progressTextCountDirection,
                          //             progressTextStyle:
                          //                 FontTextStyle.kWhite24BoldRoboto,
                          //             strokeWidth: 15,
                          //             onStart: () {
                          //               setState(() {
                          //                 totalRound = totalRound + 1;
                          //               });
                          //             },
                          //             onEnd: () {
                          //               if (totalRound !=
                          //                   int.parse(widget
                          //                       .controller!
                          //                       .responseExe!
                          //                       .data![0]
                          //                       .exerciseSets
                          //                       .toString())) {
                          //                 _timerController!.reset();
                          //               } else {
                          //                 _timerController!.stop();
                          //               }
                          //             },
                          //           ),
                          //         )),
                          //         SizedBox(height: Get.height * .04),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             GestureDetector(
                          //               onTap: () {
                          //                 print('Start Pressed');
                          //                 if (totalRound !=
                          //                     int.parse(widget
                          //                         .controller!
                          //                         .responseExe!
                          //                         .data![0]
                          //                         .exerciseSets
                          //                         .toString())) {
                          //                   _timerController!.start();
                          //
                          //                   print(
                          //                       'controller.totalRound-------> ${totalRound}');
                          //                 }
                          //               },
                          //               child: Container(
                          //                 alignment: Alignment.center,
                          //                 height: Get.height * .05,
                          //                 width: Get.width * .3,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                       BorderRadius.circular(6),
                          //                   gradient: LinearGradient(
                          //                     begin: Alignment.topCenter,
                          //                     end: Alignment.bottomCenter,
                          //                     stops: [0.0, 1.0],
                          //                     colors: ColorUtilsGradient
                          //                         .kTintGradient,
                          //                   ),
                          //                 ),
                          //                 child: Text(
                          //                   'Start',
                          //                   style: FontTextStyle
                          //                       .kBlack18w600Roboto,
                          //                 ),
                          //               ),
                          //             ),
                          //             SizedBox(width: Get.width * 0.05),
                          //             GestureDetector(
                          //               onTap: () {
                          //                 print('Reset pressed ');
                          //                 setState(() {
                          //                   totalRound = 0;
                          //                 });
                          //
                          //                 // controller.totalRound = 0;
                          //                 _timerController!.reset();
                          //               },
                          //               child: Container(
                          //                 alignment: Alignment.center,
                          //                 height: Get.height * .05,
                          //                 width: Get.width * .3,
                          //                 decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(6),
                          //                     border: Border.all(
                          //                         color: ColorUtils.kTint,
                          //                         width: 1.5)),
                          //                 child: Text(
                          //                   'Reset',
                          //                   style:
                          //                       FontTextStyle.kTine17BoldRoboto,
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         SizedBox(height: Get.height * .04),
                          //         commonNavigationButton(
                          //             onTap: () async {
                          //               _timerController!.reset();
                          //
                          //               setState(() {
                          //                 totalRound = 0;
                          //               });
                          //               // controller.totalRound = 0;
                          //               _userWorkoutsDateViewModel.getExeId(
                          //                   counter: _userWorkoutsDateViewModel
                          //                       .exeIdCounter);
                          //
                          //               if (_userWorkoutsDateViewModel
                          //                       .exeIdCounter <
                          //                   _userWorkoutsDateViewModel
                          //                       .exerciseId.length) {
                          //                 if (_userWorkoutsDateViewModel
                          //                         .exeIdCounter >
                          //                     0) {
                          //                   _userWorkoutsDateViewModel
                          //                       .isGreaterOne = true;
                          //                 }
                          //                 await widget.controller!
                          //                     .getExerciseByIdDetails(
                          //                         id: _userWorkoutsDateViewModel
                          //                                 .exerciseId[
                          //                             _userWorkoutsDateViewModel
                          //                                 .exeIdCounter]);
                          //                 if (widget.controller!.apiResponse
                          //                         .status ==
                          //                     Status.LOADING) {
                          //                   Center(
                          //                     child:
                          //                         CircularProgressIndicator(),
                          //                   );
                          //                 }
                          //                 if (widget.controller!.apiResponse
                          //                         .status ==
                          //                     Status.COMPLETE) {
                          //                   widget.controller!.responseExe =
                          //                       widget.controller!.apiResponse
                          //                           .data;
                          //                   _youTubePlayerController.pause();
                          //                 }
                          //               }
                          //               if (_userWorkoutsDateViewModel
                          //                       .exeIdCounter ==
                          //                   _userWorkoutsDateViewModel
                          //                       .exerciseId.length) {
                          //                 Get.to(ShareProgressScreen(
                          //                   exeData: widget
                          //                       .controller!.responseExe!.data!,
                          //                   data: widget.data,
                          //                   workoutId: widget.workoutId,
                          //                 ));
                          //
                          //                 _userWorkoutsDateViewModel.isFirst =
                          //                     false;
                          //                 _userWorkoutsDateViewModel.isHold =
                          //                     false;
                          //                 _youTubePlayerController.pause();
                          //               }
                          //             },
                          //             name: widget.controller!.responseExe!
                          //                         .data![0].exerciseId ==
                          //                     _userWorkoutsDateViewModel
                          //                         .exerciseId.last
                          //                 ? 'Finish and Log Workout'
                          //                 : 'Next Exercise')
                          //       ]),
                          // ),
                        ]),
                  ),
                ),
              ),
            );
          });
    } else {
      return GestureDetector(
        // onHorizontalDragUpdate: (details) async {
        //   print("hello ${details.localPosition}");
        //   print("hello ${details.localPosition.dx}");
        //   print("hello ${details.globalPosition.distance}");
        //
        //   if (details.localPosition.dx < 100.0) {
        //     //SWIPE FROM RIGHT DETECTION
        //     print("hello ");
        //
        //     _timerController!.reset();
        //     setState(() {
        //       totalRound = 0;
        //     });
        //     _userWorkoutsDateViewModel.getBackId(
        //         counter: _userWorkoutsDateViewModel.exeIdCounter);
        //     if (_userWorkoutsDateViewModel.exeIdCounter <
        //         _userWorkoutsDateViewModel.exerciseId.length) {
        //       await widget.controller!.getExerciseByIdDetails(
        //           id: _userWorkoutsDateViewModel
        //               .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
        //       if (widget.controller!.apiResponse.status == Status.LOADING) {
        //         Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }
        //       if (widget.controller!.apiResponse.status == Status.COMPLETE) {
        //         widget.controller!.responseExe =
        //             widget.controller!.apiResponse.data;
        //       }
        //     }
        //     if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
        //       widget.isFirst = true;
        //     }
        //     if (widget.isFirst == true) {
        //       if (widget.isGreaterOne == false) {
        //         Get.back();
        //       }
        //       if (widget.isHold == true) {
        //         Get.back();
        //         widget.isHold = false;
        //         widget.isFirst = false;
        //       } else {
        //         widget.isHold = true;
        //       }
        //     }
        //     _videoPlayerController!.pause();
        //     _chewieController!.pause();
        //     _youTubePlayerController!.pause();
        //   }
        // },
        child: WillPopScope(
          onWillPop: () async {
            _timerController!.reset();
            setState(() {
              totalRound = 0;
            });
            _userWorkoutsDateViewModel.getBackId(
                counter: _userWorkoutsDateViewModel.exeIdCounter);
            if (_userWorkoutsDateViewModel.exeIdCounter <
                _userWorkoutsDateViewModel.exerciseId.length) {
              await widget.controller!.getExerciseByIdDetails(
                  id: _userWorkoutsDateViewModel
                      .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
              if (widget.controller!.apiResponse.status == Status.LOADING) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (widget.controller!.apiResponse.status == Status.COMPLETE) {
                widget.controller!.responseExe =
                    widget.controller!.apiResponse.data;
              }
            }
            if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
              _userWorkoutsDateViewModel.isFirst = true;
            }
            if (_userWorkoutsDateViewModel.isFirst == true) {
              if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                _videoPlayerController!.pause();
                _chewieController!.pause();
                Get.back();
              }
              if (_userWorkoutsDateViewModel.isHold == true) {
                _videoPlayerController!.pause();
                _chewieController!.pause();
                _userWorkoutsDateViewModel.isHold = false;
                _userWorkoutsDateViewModel.isFirst = false;
                Get.back();
              } else {
                _userWorkoutsDateViewModel.isHold = true;
              }
            }
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: ColorUtils.kBlack,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: () async {
                    _timerController!.reset();
                    setState(() {
                      totalRound = 0;
                    });

                    _userWorkoutsDateViewModel.getBackId(
                        counter: _userWorkoutsDateViewModel.exeIdCounter);
                    if (_userWorkoutsDateViewModel.exeIdCounter <
                        _userWorkoutsDateViewModel.exerciseId.length) {
                      await widget.controller!.getExerciseByIdDetails(
                          id: _userWorkoutsDateViewModel.exerciseId[
                              _userWorkoutsDateViewModel.exeIdCounter]);
                      if (widget.controller!.apiResponse.status ==
                          Status.LOADING) {
                        Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (widget.controller!.apiResponse.status ==
                          Status.COMPLETE) {
                        widget.controller!.responseExe =
                            widget.controller!.apiResponse.data;
                      }
                    }
                    if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                      _userWorkoutsDateViewModel.isFirst = true;
                    }
                    if (_userWorkoutsDateViewModel.isFirst == true) {
                      if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                        print('back........1');
                        Get.back();
                        _videoPlayerController!.pause();
                        _chewieController!.pause();
                      }
                      if (_userWorkoutsDateViewModel.isHold == true) {
                        print('back........2');
                        Get.back();
                        _videoPlayerController!.pause();
                        _chewieController!.pause();
                        _userWorkoutsDateViewModel.isHold = false;
                        _userWorkoutsDateViewModel.isFirst = false;
                      } else {
                        _userWorkoutsDateViewModel.isHold = true;
                      }
                    }
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
                      _userWorkoutsDateViewModel.exeIdCounter = 0;

                      _userWorkoutsDateViewModel.isFirst = false;
                      _userWorkoutsDateViewModel.isHold = false;

                      _timerController!.reset();
                      setState(() {
                        totalRound = 0;
                      });
                      // controller.totalRound = 0;
                    },
                    child: Text(
                      'Quit',
                      style: FontTextStyle.kTine16W400Roboto,
                    ))
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: Get.height,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * .04,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () {
                            // Get.to(WeightExerciseScreen(
                            //   data: widget.controller!.responseExe!.data!,
                            // ));
                            Get.to(SuperSetScreen());
                          },
                          child: Text(
                            'Edit',
                            style: FontTextStyle.kTine16W400Roboto
                                .copyWith(fontSize: Get.height * 0.022),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Container(
                    width: Get.width * 0.7,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                              style: FontTextStyle.kWhite24BoldRoboto,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              initializePlayer();

                              if (isShow == true) {
                                setState(() {
                                  isShow = false;
                                });

                                if (_chewieController != null &&
                                    _chewieController!.videoPlayerController
                                        .value.isInitialized) {
                                  _chewieController!.pause();
                                  _videoPlayerController!.pause();
                                } else {
                                  SizedBox();
                                }
                              } else {
                                print(
                                    '_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo ${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');

                                if (_exerciseByIdViewModel.responseExe!.data![0]
                                            .exerciseVideo ==
                                        null ||
                                    _exerciseByIdViewModel.responseExe!.data![0]
                                            .exerciseVideo ==
                                        '') {
                                } else {
                                  _videoPlayerController =
                                      VideoPlayerController.network(
                                          '${_exerciseByIdViewModel.responseExe!.data![0].exerciseVideo}');
                                  print('started.....vide0 11');
                                  await Future.wait([
                                    _videoPlayerController!.initialize(),
                                  ]);
                                  _createChewieController();
                                  // setState(() {});
                                }
                                setState(() {
                                  isShow = true;
                                });
                              }
                            },
                            child: Image.asset(
                              AppIcons.play,
                              height: Get.height * 0.03,
                              width: Get.height * 0.03,
                              color: ColorUtils.kTint,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.015,
                  ),
                  Text(
                    '${widget.controller!.responseExe!.data![0].exerciseTime} seconds each set',
                    style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                        fontSize: Get.height * 0.023,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  isShow == true
                      ? Container(
                          height: Get.height / 2.75,
                          width: Get.width,
                          child: Center(
                              child: _chewieController != null &&
                                      _chewieController!.videoPlayerController
                                          .value.isInitialized
                                  ? Chewie(
                                      controller: _chewieController!,
                                    )
                                  : widget.controller!.responseExe!.data![0]
                                              .exerciseImage ==
                                          null
                                      ? noDataLottie()
                                      : Image.network(
                                          "https://tcm.sataware.dev/images/" +
                                              widget.controller!.responseExe!
                                                  .data![0].exerciseImage!
                                                  .split("\/")
                                                  .last,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return noDataLottie();
                                          },
                                        )))
                      : SizedBox(),
                  totalRound == 0
                      ? Text(
                          'Sets ${widget.controller!.responseExe!.data![0].exerciseSets} ',
                          style: FontTextStyle.kLightGray16W300Roboto,
                        )
                      : Text(
                          'Sets ${totalRound}/${widget.controller!.responseExe!.data![0].exerciseSets} ',
                          style: FontTextStyle.kLightGray16W300Roboto,
                        ),
                  Center(
                      child: Container(
                    height: Get.height * .23,
                    width: Get.height * .23,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SimpleTimer(
                      duration: widget.controller!.responseExe!.data![0]
                                  .exerciseTime !=
                              ""
                          ? Duration(
                              seconds: int.parse(
                                  "${widget.controller!.responseExe!.data![0].exerciseTime}"))
                          : Duration(seconds: 10),
                      controller: _timerController,
                      timerStyle: _timerStyle,
                      progressTextFormatter: (format) {
                        return '00:${format.inSeconds.toString().padLeft(2, '0')}';
                      },
                      backgroundColor: ColorUtils.kGray,
                      progressIndicatorColor: ColorUtils.kTint,
                      progressIndicatorDirection: _progressIndicatorDirection,
                      progressTextCountDirection: _progressTextCountDirection,
                      progressTextStyle: FontTextStyle.kWhite24BoldRoboto
                          .copyWith(fontSize: Get.height * 0.03),
                      strokeWidth: 17,
                      onStart: () {
                        setState(() {
                          totalRound = totalRound + 1;
                        });
                      },
                      onEnd: () {
                        if (totalRound !=
                            int.parse(widget
                                .controller!.responseExe!.data![0].exerciseSets
                                .toString())) {
                          _timerController!.reset();
                        } else {
                          _timerController!.stop();
                        }
                      },
                    ),
                  )),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Start Pressed');
                          if (totalRound !=
                              int.parse(widget.controller!.responseExe!.data![0]
                                  .exerciseSets
                                  .toString())) {
                            _timerController!.start();

                            print(
                                'controller.totalRound-------> ${totalRound}');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: Get.height * .06,
                          width: Get.width * .3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              colors: ColorUtilsGradient.kTintGradient,
                            ),
                          ),
                          child: Text(
                            'Start',
                            style: FontTextStyle.kBlack18w600Roboto.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: Get.height * 0.02),
                          ),
                        ),
                      ),
                      SizedBox(width: Get.width * 0.05),
                      GestureDetector(
                        onTap: () {
                          print('Reset pressed ');
                          setState(() {
                            totalRound = 0;
                          });

                          // controller.totalRound = 0;
                          _timerController!.reset();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: Get.height * .06,
                          width: Get.width * .3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
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
                  SizedBox(
                    height:
                        isShow == true ? Get.height * 0.02 : Get.height * 0.22,
                  ),
                  SizedBox(
                    width: Get.width * 0.9,
                    child: commonNavigationButton(
                        onTap: () async {
                          _timerController!.reset();

                          setState(() {
                            totalRound = 0;
                          });
                          // controller.totalRound = 0;
                          _userWorkoutsDateViewModel.getExeId(
                              counter: _userWorkoutsDateViewModel.exeIdCounter);

                          if (_userWorkoutsDateViewModel.exeIdCounter <
                              _userWorkoutsDateViewModel.exerciseId.length) {
                            if (_userWorkoutsDateViewModel.exeIdCounter > 0) {
                              _userWorkoutsDateViewModel.isGreaterOne = true;
                              print(
                                  "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                            }
                            await widget.controller!.getExerciseByIdDetails(
                                id: _userWorkoutsDateViewModel.exerciseId[
                                    _userWorkoutsDateViewModel.exeIdCounter]);
                            if (widget.controller!.apiResponse.status ==
                                Status.LOADING) {
                              Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (widget.controller!.apiResponse.status ==
                                Status.COMPLETE) {
                              widget.controller!.responseExe =
                                  widget.controller!.apiResponse.data;
                              _videoPlayerController!.pause();
                              _chewieController!.pause();
                            }
                          }
                          if (_userWorkoutsDateViewModel.exeIdCounter ==
                              _userWorkoutsDateViewModel.exerciseId.length) {
                            Get.to(ShareProgressScreen(
                              exeData: widget.controller!.responseExe!.data!,
                              data: widget.data,
                              workoutId: widget.workoutId,
                            ));
                            _videoPlayerController!.pause();
                            _chewieController!.pause();

                            _userWorkoutsDateViewModel.isFirst = false;
                            _userWorkoutsDateViewModel.isHold = false;
                          }
                        },
                        name: widget.controller!.responseExe!.data![0]
                                    .exerciseId ==
                                _userWorkoutsDateViewModel.exerciseId.last
                            ? 'Finish and Log Workout'
                            : 'Next Exercise'),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    }
  }
}
