import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/no_weight_exercise_screen.dart';
import 'package:tcm/screen/workout_screen/share_progress_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../viewModel/conecction_check_viewModel.dart';

// ignore: must_be_immutable
class WorkoutHomeScreen extends StatefulWidget {
  List<ExerciseById> exeData;
  List<WorkoutById> data;
  final String? workoutId;
  final String date;

  WorkoutHomeScreen(
      {Key? key,
      required this.data,
      this.workoutId,
      required this.exeData,
      required this.date})
      : super(key: key);

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;

  ChewieController? _chewieController;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
    initializePlayer();
    getExercisesId();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youTubePlayerController?.dispose();
    super.dispose();
  }

  getExercisesId() async {
    print("called 123");
    print(
        'userProgramDatesId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.userProgramDateID}');

    _userWorkoutsDateViewModel.supersetExerciseId.clear();
    _userWorkoutsDateViewModel.exerciseId.clear();
    _userWorkoutsDateViewModel.userProgramDateID = '';
    _userWorkoutsDateViewModel.warmUpId.isEmpty;

    await _userWorkoutsDateViewModel.getUserWorkoutsDateDetails(
        userId: PreferenceManager.getUId(), date: widget.date.split(' ').first);

    print("complete api call");

    UserWorkoutsDateResponseModel resp =
        _userWorkoutsDateViewModel.apiResponse.data;

    print("---------------exercisesIds dates ${resp.data!.exercisesIds!}");

    _userWorkoutsDateViewModel.exerciseId = resp.data!.exercisesIds!;
    print('exerciseIds >>>>> ${_userWorkoutsDateViewModel.exerciseId}');
    _userWorkoutsDateViewModel.tmpExerciseId = resp.data!.exercisesIds!;
    print('tmpExerciseId >>>>> ${_userWorkoutsDateViewModel.tmpExerciseId}');

    _userWorkoutsDateViewModel.supersetExerciseId =
        resp.data!.supersetExercisesIds!;
    _userWorkoutsDateViewModel.userProgramDateID =
        resp.data!.userProgramDatesId!;

    if (resp.data!.selectedWarmup != [] &&
        resp.data!.selectedWarmup!.isNotEmpty) {
      // print('======= superset round ${resp.data!.round!.runtimeType}');
      // if (resp.data!.round!.isNotEmpty) {
      try {
        _userWorkoutsDateViewModel.warmUpId = resp.data!.selectedWarmup!;
      } catch (e) {
        _userWorkoutsDateViewModel.warmUpId = [];
      }
      print(
          'controller ======= superset warmUpId ${_userWorkoutsDateViewModel.warmUpId}');
      // }
    } else {
      _userWorkoutsDateViewModel.warmUpId = [];
      print(
          'else ======= superset warmUpId ${_userWorkoutsDateViewModel.warmUpId}');
    }

    if (resp.data!.restTime != "" && resp.data!.restTime != null) {
      try {
        _userWorkoutsDateViewModel.supersetRestTime = resp.data!.restTime;
        print(
            'controller ======= superset restTime ${_userWorkoutsDateViewModel.supersetRestTime}');
      } catch (e) {
        _userWorkoutsDateViewModel.supersetRestTime = "30";
      }
    } else {
      _userWorkoutsDateViewModel.supersetRestTime = "30";
      print(
          'else ======= superset restTime ${_userWorkoutsDateViewModel.supersetRestTime}');
    }
    if (resp.data!.round != "" && resp.data!.round != null) {
      print('======= superset round ${resp.data!.round}');
      try {
        _userWorkoutsDateViewModel.supersetRound =
            int.parse("${resp.data!.round!}");
        print(
            'controller ======= superset round ${_userWorkoutsDateViewModel.supersetRound}');
      } catch (e) {
        _userWorkoutsDateViewModel.supersetRound = 1;
      }
    } else {
      _userWorkoutsDateViewModel.supersetRound = 3;
      print(
          'else ======= superset Round ${_userWorkoutsDateViewModel.supersetRestTime}');
    }

    print(
        'userProgramDatesId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.userProgramDateID}');
    // _userWorkoutsDateViewModel.warmUpId = ["75", "76", "77"];
    print(
        'exerciseId >>> ${_userWorkoutsDateViewModel.exerciseId[_userWorkoutsDateViewModel.exeIdCounter]}');
    print('LIST >> . ${_userWorkoutsDateViewModel.exerciseId}');
    print('exeIdCounter >>> ${_userWorkoutsDateViewModel.exeIdCounter}');
    await _exerciseByIdViewModel.getExerciseByIdDetails(
        id: _userWorkoutsDateViewModel
            .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
  }

  Future initializePlayer() async {
    youtubeVideoID() {
      String finalLink;
      String videoID = '${widget.data[0].workoutVideo}';
      List<String> splittedLink = videoID.split('v=');
      List<String> longLink = splittedLink.last.split('&');
      finalLink = longLink.first;
      return finalLink;
    }

    if ('${widget.data[0].workoutVideo}'.contains('www.youtube.com')) {
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
      if (widget.data[0].workoutVideo == null ||
          widget.data[0].workoutVideo == '') {
      } else {
        _videoPlayerController =
            VideoPlayerController.network('${widget.data[0].workoutVideo}');

        await Future.wait([
          _videoPlayerController!.initialize(),
        ]);
        _createChewieController();
      }
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

  bool watchVideo = false;

  @override
  Widget build(BuildContext context) {
    print('build called');
    // print('Data >>>> ${widget.data}');
    // print('workoutId >>> ${widget.workoutId}');
    if (widget.exeData.isNotEmpty) {
      String exerciseInstructions = '${widget.data[0].workoutDescription}';
      List<String> splitHTMLInstruction = exerciseInstructions.split('</li>');
      List<String> finalHTMLInstruction = [];
      splitHTMLInstruction.forEach((element) {
        finalHTMLInstruction
            .add(element.replaceAll('<ol>', '').replaceAll('</ol>', ''));
      });

      String exerciseTips = '${widget.exeData[0].exerciseTips}';
      List<String> splitHTMLTips = exerciseTips.split('</li>');
      List<String> finalHTMLTips = [];
      splitHTMLTips.forEach((element) {
        finalHTMLTips
            .add(element.replaceAll('<ul>', '').replaceAll('</ul>', ''));
      });

      return GetBuilder<ConnectivityCheckViewModel>(
        builder: (control) => control.isOnline
            ? GetBuilder<ExerciseByIdViewModel>(builder: (controller) {
                if (_exerciseByIdViewModel.apiResponse.status ==
                    Status.COMPLETE) {
                  ExerciseByIdResponseModel responseExe =
                      _exerciseByIdViewModel.apiResponse.data;
                  print(
                      "exe date --------- ${responseExe.data![0].exerciseType}");

                  return '${widget.data[0].workoutVideo}'
                          .contains('www.youtube.com')
                      ? YoutubePlayerBuilder(
                          player: YoutubePlayer(
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
                          ),
                          builder: (context, player) {
                            return WillPopScope(
                              onWillPop: () async {
                                Get.offAll(HomeScreen());
                                return true;
                              },
                              child: Scaffold(
                                backgroundColor: ColorUtils.kBlack,
                                appBar: AppBar(
                                  elevation: 0,
                                  leading: IconButton(
                                      onPressed: () {
                                        Get.offAll(HomeScreen());
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_sharp,
                                        color: ColorUtils.kTint,
                                      )),
                                  backgroundColor: ColorUtils.kBlack,
                                  title: Text('Workout Overview',
                                      style: FontTextStyle.kWhite16BoldRoboto),
                                  centerTitle: true,
                                ),
                                body: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.09,
                                        vertical: Get.height * 0.02),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Center(
                                            child: Text(
                                              '${widget.data[0].workoutTitle}',
                                              textAlign: TextAlign.center,
                                              style: FontTextStyle
                                                  .kWhite20BoldRoboto
                                                  .copyWith(
                                                      fontSize:
                                                          Get.height * 0.022,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(height: Get.height * .02),
                                          ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  finalHTMLInstruction.length -
                                                      1,
                                              itemBuilder: (_, index) =>
                                                  htmlToTextGrey(
                                                      data:
                                                          finalHTMLInstruction[
                                                              index])),
                                          SizedBox(height: Get.height * .03),
                                          !watchVideo
                                              ? commonNavigationButtonWithIcon(
                                                  onTap: () {
                                                    setState(() {
                                                      watchVideo = true;
                                                    });
                                                  },
                                                  name: 'Watch Overview Video',
                                                  iconImg: AppIcons.video,
                                                  iconColor: ColorUtils.kBlack)
                                              : SizedBox(),
                                          watchVideo
                                              ? AnimatedContainer(
                                                  height: Get.height / 3.5,
                                                  width: Get.width,
                                                  duration:
                                                      Duration(seconds: 2),
                                                  child: Center(
                                                    child: _youTubePlayerController ==
                                                            null
                                                        ? CircularProgressIndicator(
                                                            color: ColorUtils
                                                                .kTint)
                                                        : player,
                                                  ))
                                              : SizedBox(),

                                          SizedBox(height: Get.height * .03),
                                          Container(
                                            // height: Get.height * .4,
                                            width: Get.width * .9,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                gradient: LinearGradient(
                                                    colors: ColorUtilsGradient
                                                        .kGrayGradient,
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  // color: Colors.pink,
                                                  width: Get.width * .525,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: Get.height *
                                                                .05),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                radius:
                                                                    Get.height *
                                                                        .02,
                                                                backgroundColor:
                                                                    ColorUtils
                                                                        .kWhite,
                                                                child: Center(
                                                                  child: Image
                                                                      .asset(
                                                                    AppIcons
                                                                        .kettle_bell,
                                                                    height: Get
                                                                            .height *
                                                                        0.025,
                                                                    width:
                                                                        Get.width *
                                                                            0.1,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      Get.width *
                                                                          .03),
                                                              Expanded(
                                                                child: Text(
                                                                    'Equipment needed',
                                                                    style: FontTextStyle
                                                                        .kWhite20BoldRoboto),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Get.height *
                                                                .05),
                                                        Container(
                                                          // color: Colors.teal,
                                                          width: Get.width * .4,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: ListView
                                                              .separated(
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: widget
                                                                      .data[0]
                                                                      .availableEquipments!
                                                                      .length,
                                                                  separatorBuilder:
                                                                      (_, index) {
                                                                    return SizedBox(
                                                                        height: Get.height *
                                                                            .008);
                                                                  },
                                                                  itemBuilder:
                                                                      (_, index) {
                                                                    if ('${widget.data[0].availableEquipments![index]}' !=
                                                                        "No Equipment") {
                                                                      return Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: Get.width * .075),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 3),
                                                                            child:
                                                                                Icon(
                                                                              Icons.circle,
                                                                              color: ColorUtils.kLightGray,
                                                                              size: Get.height * 0.0135,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: Get.width * .025),
                                                                          Flexible(
                                                                            child:
                                                                                Text(' ${widget.data[0].availableEquipments![index]}', style: FontTextStyle.kWhite17BoldRoboto),
                                                                          )
                                                                        ],
                                                                      );
                                                                    } else {
                                                                      return SizedBox();
                                                                    }
                                                                  }),
                                                        ),
                                                        SizedBox(
                                                            height: Get.height *
                                                                .05),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                radius:
                                                                    Get.height *
                                                                        .02,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .asset(
                                                                    AppIcons
                                                                        .clock,
                                                                    color: ColorUtils
                                                                        .kWhite,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: Get
                                                                        .height,
                                                                    width: Get
                                                                        .width,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      Get.width *
                                                                          .03),
                                                              Expanded(
                                                                child: Text(
                                                                  '${widget.exeData[0].exerciseRest} rest between sets',
                                                                  style: FontTextStyle
                                                                      .kWhite20BoldRoboto,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Get.height *
                                                                .05),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: Get.height * .03),
                                          // ListView.builder(
                                          //     physics: NeverScrollableScrollPhysics(),
                                          //     shrinkWrap: true,
                                          //     itemCount: finalHTMLTips.length - 1,
                                          //     itemBuilder: (_, index) =>
                                          //         ),
                                          // htmlToTextGrey(data: finalHTMLTips[1]),
                                          SizedBox(height: Get.height * .03),

                                          GetBuilder<UserWorkoutsDateViewModel>(
                                              builder: (controller) {
                                            // log('================ ?> ${controller.warmUpId.isNotEmpty}');

                                            return controller.userProgramDateID
                                                    .isNotEmpty
                                                ? Column(
                                                    children: [
                                                      controller.warmUpId
                                                                  .isNotEmpty &&
                                                              controller
                                                                      .warmUpId !=
                                                                  []
                                                          ? commonNavigationButton(
                                                              name:
                                                                  "Begin Warm-Up",
                                                              onTap: () {
                                                                log("hello warm up");
                                                                log("hello warm up id ${controller.warmUpId}");
                                                                log("hello exerciseId up Z${controller.exerciseId}");
                                                                if (controller
                                                                    .warmUpId
                                                                    .isNotEmpty) {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          controller
                                                                              .warmUpId
                                                                              .length;
                                                                      i++) {
                                                                    /// warm up
                                                                    if (controller
                                                                            .exerciseId
                                                                            .contains(controller.warmUpId[i]) ==
                                                                        false) {
                                                                      /// warm up data add in mix exerciseId list(warm up & exercised both data)
                                                                      controller
                                                                          .exerciseId
                                                                          .insert(
                                                                              i,
                                                                              controller.warmUpId[i]);
                                                                    }
                                                                  }
                                                                }
                                                                print(
                                                                    'exerciseId>>>> ${controller.exerciseId}');
                                                                setState(() {
                                                                  watchVideo =
                                                                      false;
                                                                });
                                                                // log("hello exerciseId up Z for loop ${controller.exerciseId}");

                                                                if (controller
                                                                        .exeIdCounter ==
                                                                    controller
                                                                        .exerciseId
                                                                        .length) {
                                                                  Get.to(
                                                                      () =>
                                                                          ShareProgressScreen(
                                                                            exeData:
                                                                                responseExe.data!,
                                                                            data:
                                                                                widget.data,
                                                                            workoutId:
                                                                                widget.workoutId,
                                                                          ),
                                                                      transition:
                                                                          Transition
                                                                              .rightToLeft);
                                                                }
                                                                Get.to(
                                                                    () =>
                                                                        NoWeightExerciseScreen(
                                                                          data:
                                                                              widget.data,
                                                                          workoutId:
                                                                              widget.workoutId,
                                                                        ),
                                                                    transition:
                                                                        Transition
                                                                            .rightToLeft);

                                                                // log("warm up added ${controller.exerciseId}");
                                                              })
                                                          : SizedBox(),
                                                      controller.warmUpId
                                                                  .isNotEmpty &&
                                                              controller
                                                                      .warmUpId !=
                                                                  []
                                                          ? SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      .03)
                                                          : SizedBox(),
                                                      commonNavigationButton(
                                                          name: 'Start Workout',
                                                          onTap: () {
                                                            for (int i = 0;
                                                                i <
                                                                    controller
                                                                        .warmUpId
                                                                        .length;
                                                                i++) {
                                                              if (controller
                                                                  .exerciseId
                                                                  .contains(
                                                                      controller
                                                                              .warmUpId[
                                                                          i])) {
                                                                controller
                                                                    .exerciseId
                                                                    .removeAt(
                                                                        0);
                                                              }
                                                            }
                                                            setState(() {
                                                              watchVideo =
                                                                  false;
                                                            });

                                                            // Get.to(SuperSetScreen());
                                                            // controller
                                                            //     .exerciseId
                                                            //     .clear();
                                                            //
                                                            // controller
                                                            //         .exerciseId =
                                                            //     controller
                                                            //         .tmpExerciseId;
                                                            // log("warm up added ${controller.exerciseId}");

                                                            if (controller
                                                                    .exeIdCounter ==
                                                                controller
                                                                    .exerciseId
                                                                    .length) {
                                                              Get.to(
                                                                  () =>
                                                                      ShareProgressScreen(
                                                                        exeData:
                                                                            responseExe.data!,
                                                                        data: widget
                                                                            .data,
                                                                        workoutId:
                                                                            widget.workoutId,
                                                                      ),
                                                                  transition:
                                                                      Transition
                                                                          .rightToLeft);
                                                            }
                                                            Get.to(
                                                                () =>
                                                                    NoWeightExerciseScreen(
                                                                      data: widget
                                                                          .data,
                                                                      workoutId:
                                                                          widget
                                                                              .workoutId,
                                                                    ),
                                                                transition:
                                                                    Transition
                                                                        .rightToLeft);
                                                          }),
                                                    ],
                                                  )
                                                : SizedBox();
                                          }),
                                          SizedBox(height: Get.height * .03),
                                          // commonNavigationButton(
                                          //     name: 'Back to Home',
                                          //     onTap: () {
                                          //       Get.offAll(HomeScreen());
                                          //       setState(() {
                                          //         watchVideo = false;
                                          //       });
                                          //     })
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          })
                      : WillPopScope(
                          onWillPop: () async {
                            print('xyz');
                            Get.offAll(HomeScreen());
                            return true;
                          },
                          child: Scaffold(
                            backgroundColor: ColorUtils.kBlack,
                            appBar: AppBar(
                              elevation: 0,
                              leading: IconButton(
                                  onPressed: () {
                                    Get.offAll(HomeScreen());
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_sharp,
                                    color: ColorUtils.kTint,
                                  )),
                              backgroundColor: ColorUtils.kBlack,
                              title: Text('Workout Overview',
                                  style: FontTextStyle.kWhite16BoldRoboto),
                              centerTitle: true,
                            ),
                            body: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.09,
                                    vertical: Get.height * 0.02),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child: Text(
                                          '${widget.data[0].workoutTitle}',
                                          textAlign: TextAlign.center,
                                          style: FontTextStyle
                                              .kWhite20BoldRoboto
                                              .copyWith(
                                                  fontSize: Get.height * 0.022,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: Get.height * .02),
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              finalHTMLInstruction.length - 1,
                                          itemBuilder: (_, index) =>
                                              htmlToTextGrey(
                                                  data: finalHTMLInstruction[
                                                      index])),
                                      SizedBox(height: Get.height * .03),
                                      !watchVideo
                                          ? commonNavigationButtonWithIcon(
                                              onTap: () {
                                                setState(() {
                                                  watchVideo = true;
                                                });
                                              },
                                              name: 'Watch Overview Video',
                                              iconImg: AppIcons.video,
                                              iconColor: ColorUtils.kBlack)
                                          : SizedBox(),
                                      watchVideo
                                          ? AnimatedContainer(
                                              height: Get.height / 3.5,
                                              width: Get.width,
                                              duration: Duration(seconds: 2),
                                              child: Center(
                                                  child: _chewieController !=
                                                              null &&
                                                          _chewieController!
                                                              .videoPlayerController
                                                              .value
                                                              .isInitialized
                                                      ? Chewie(
                                                          controller:
                                                              _chewieController!,
                                                        )
                                                      : widget.data[0]
                                                                  .workoutImage ==
                                                              null
                                                          ? noData()
                                                          : Image.network(
                                                              widget.data[0]
                                                                  .workoutImage!,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return noData();
                                                              },
                                                            )),
                                            )
                                          : SizedBox(),

                                      SizedBox(height: Get.height * .03),
                                      Container(
                                        // height: Get.height * .4,
                                        width: Get.width * .9,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            gradient: LinearGradient(
                                                colors: ColorUtilsGradient
                                                    .kGrayGradient,
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              // color: Colors.pink,
                                              width: Get.width * .525,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height:
                                                            Get.height * .05),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: Get.height *
                                                                .02,
                                                            backgroundColor:
                                                                ColorUtils
                                                                    .kWhite,
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
                                                                AppIcons
                                                                    .kettle_bell,
                                                                height:
                                                                    Get.height *
                                                                        0.025,
                                                                width:
                                                                    Get.width *
                                                                        0.1,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: Get.width *
                                                                  .03),
                                                          Expanded(
                                                            child: Text(
                                                                'Equipment needed',
                                                                style: FontTextStyle
                                                                    .kWhite20BoldRoboto),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            Get.height * .05),
                                                    Container(
                                                      // color: Colors.teal,
                                                      width: Get.width * .4,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: ListView.separated(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: widget
                                                              .data[0]
                                                              .availableEquipments!
                                                              .length,
                                                          separatorBuilder:
                                                              (_, index) {
                                                            return SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        .008);
                                                          },
                                                          itemBuilder:
                                                              (_, index) {
                                                            if ('${widget.data[0].availableEquipments![index]}' !=
                                                                "No Equipment") {
                                                              return Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                      width: Get
                                                                              .width *
                                                                          .075),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                3),
                                                                    child: Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: ColorUtils
                                                                          .kLightGray,
                                                                      size: Get
                                                                              .height *
                                                                          0.0135,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: Get
                                                                              .width *
                                                                          .025),
                                                                  Flexible(
                                                                    child: Text(
                                                                      '${widget.data[0].availableEquipments![index]}',
                                                                      style: FontTextStyle
                                                                          .kWhite17BoldRoboto,
                                                                    ),
                                                                  )
                                                                  // RichText(
                                                                  //     text: TextSpan(
                                                                  //         text: '',
                                                                  //         style: FontTextStyle
                                                                  //             .kLightGray16W300Roboto,
                                                                  //         children: [
                                                                  //       TextSpan(
                                                                  //           text:
                                                                  //               ' ${widget.data[0].availableEquipments![index]}',
                                                                  //           style: FontTextStyle
                                                                  //               .kWhite17BoldRoboto)
                                                                  //     ])),
                                                                ],
                                                              );
                                                            } else {
                                                              return SizedBox();
                                                            }
                                                          }),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            Get.height * .05),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: Get.height *
                                                                .02,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: ClipOval(
                                                              child:
                                                                  Image.asset(
                                                                AppIcons.clock,
                                                                color:
                                                                    ColorUtils
                                                                        .kWhite,
                                                                fit:
                                                                    BoxFit.fill,
                                                                height:
                                                                    Get.height,
                                                                width:
                                                                    Get.width,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: Get.width *
                                                                  .03),
                                                          Expanded(
                                                            child: Text(
                                                              '${widget.exeData[0].exerciseRest} rest between sets',
                                                              style: FontTextStyle
                                                                  .kWhite20BoldRoboto,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            Get.height * .05),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Get.height * .03),
                                      // ListView.builder(
                                      //     physics: NeverScrollableScrollPhysics(),
                                      //     shrinkWrap: true,
                                      //     itemCount: finalHTMLTips.length - 1,
                                      //     itemBuilder: (_, index) =>
                                      //         ),
                                      // htmlToTextGrey(data: finalHTMLTips[1]),

                                      SizedBox(height: Get.height * .03),
                                      GetBuilder<UserWorkoutsDateViewModel>(
                                          builder: (controller) {
                                        // log("======================= ?>${controller.  warmUpId.isNotEmpty}");
                                        return controller
                                                .userProgramDateID.isNotEmpty
                                            ? Column(
                                                children: [
                                                  controller.warmUpId
                                                              .isNotEmpty &&
                                                          controller.warmUpId !=
                                                              []
                                                      ? commonNavigationButton(
                                                          name: "Begin Warm-Up",
                                                          onTap: () {
                                                            // log("hello warm up");
                                                            // log("hello warm up id ${controller.warmUpId}");
                                                            // log("hello exerciseId up Z${controller.exerciseId}");

                                                            if (controller
                                                                .warmUpId
                                                                .isNotEmpty) {
                                                              for (int i = 0;
                                                                  i <
                                                                      controller
                                                                          .warmUpId
                                                                          .length;
                                                                  i++) {
                                                                if (controller
                                                                        .exerciseId
                                                                        .contains(
                                                                            controller.warmUpId[i]) ==
                                                                    false) {
                                                                  controller
                                                                      .exerciseId
                                                                      .insert(
                                                                          i,
                                                                          controller
                                                                              .warmUpId[i]);
                                                                }
                                                              }
                                                            }
                                                            // log("hello exerciseId up Z for loop ${controller.exerciseId}");

                                                            Get.to(
                                                                () =>
                                                                    NoWeightExerciseScreen(
                                                                      data: widget
                                                                          .data,
                                                                      workoutId:
                                                                          widget
                                                                              .workoutId,
                                                                    ),
                                                                transition:
                                                                    Transition
                                                                        .rightToLeft);

                                                            if (controller
                                                                    .exeIdCounter ==
                                                                controller
                                                                    .exerciseId
                                                                    .length) {
                                                              Get.to(
                                                                  () =>
                                                                      ShareProgressScreen(
                                                                        exeData:
                                                                            responseExe.data!,
                                                                        data: widget
                                                                            .data,
                                                                        workoutId:
                                                                            widget.workoutId,
                                                                      ),
                                                                  transition:
                                                                      Transition
                                                                          .rightToLeft);
                                                            }

                                                            setState(() {
                                                              watchVideo =
                                                                  false;
                                                            });
                                                            // log("warm up added ${controller.exerciseId}");
                                                          })
                                                      : SizedBox(),
                                                  controller.warmUpId
                                                              .isNotEmpty &&
                                                          controller.warmUpId !=
                                                              []
                                                      ? SizedBox(
                                                          height:
                                                              Get.height * .03)
                                                      : SizedBox(),
                                                  commonNavigationButton(
                                                      name: 'Start Workout',
                                                      onTap: () {
                                                        for (int i = 0;
                                                            i <
                                                                controller
                                                                    .warmUpId
                                                                    .length;
                                                            i++) {
                                                          if (controller
                                                              .exerciseId
                                                              .contains(controller
                                                                      .warmUpId[
                                                                  i])) {
                                                            controller
                                                                .exerciseId
                                                                .removeAt(0);
                                                          }
                                                        }

                                                        // Get.to(SuperSetScreen());
                                                        // controller
                                                        //     .exerciseId
                                                        //     .clear();
                                                        //
                                                        // controller
                                                        //         .exerciseId =
                                                        //     controller
                                                        //         .tmpExerciseId;
                                                        // log("warm up added ${controller.exerciseId}");

                                                        Get.to(
                                                            () =>
                                                                NoWeightExerciseScreen(
                                                                  data: widget
                                                                      .data,
                                                                  workoutId: widget
                                                                      .workoutId,
                                                                ),
                                                            transition: Transition
                                                                .rightToLeft);

                                                        if (controller
                                                                .exeIdCounter ==
                                                            controller
                                                                .exerciseId
                                                                .length) {
                                                          Get.to(
                                                              () =>
                                                                  ShareProgressScreen(
                                                                    exeData:
                                                                        responseExe
                                                                            .data!,
                                                                    data: widget
                                                                        .data,
                                                                    workoutId:
                                                                        widget
                                                                            .workoutId,
                                                                  ),
                                                              transition: Transition
                                                                  .rightToLeft);
                                                        }
                                                        setState(() {
                                                          watchVideo = false;
                                                        });
                                                      }),
                                                ],
                                              )
                                            : SizedBox();
                                      }),
                                      SizedBox(height: Get.height * .03),
                                      // commonNavigationButton(
                                      //     name: 'Back to Home',
                                      //     onTap: () {
                                      //       Get.offAll(HomeScreen());
                                      //       setState(() {
                                      //         watchVideo = false;
                                      //       });
                                      //     })
                                    ]),
                              ),
                            ),
                          ),
                        );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorUtils.kTint,
                    ),
                  );
                }
              })
            : ConnectionCheckScreen(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: ColorUtils.kTint,
        ),
      );
    }
  }

  Padding commonNavigationButtonWithIcon(
      {Function()? onTap, String? name, String? iconImg, Color? iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * .02),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            height: Get.height * .065,
            width: Get.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  colors: ColorUtilsGradient.kTintGradient,
                ),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconImg!,
                  color: iconColor,
                  width: Get.width * 0.06,
                  height: Get.width * 0.06,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  name!,
                  style: FontTextStyle.kBlack16BoldRoboto,
                ),
                SizedBox(
                  width: Get.width * 0.042,
                  height: Get.width * 0.036,
                ),
              ],
            )),
      ),
    );
  }
}
