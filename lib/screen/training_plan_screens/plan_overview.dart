import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/check_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/check_workout_program_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/training_plan_screens/program_setup_page.dart';
import 'package:tcm/screen/training_plan_screens/workout_overview_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/check_workout_program_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlanOverviewScreen extends StatefulWidget {
  final String id;
  const PlanOverviewScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PlanOverviewScreenState createState() => _PlanOverviewScreenState();
}

class _PlanOverviewScreenState extends State<PlanOverviewScreen> {
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;

  ChewieController? _chewieController;
  WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());
  CheckWorkoutProgramViewModel _checkWorkoutProgramViewModel =
      Get.put(CheckWorkoutProgramViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();

    _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.id);
    log('id ---- ${widget.id}');
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youTubePlayerController?.dispose();
    super.dispose();
  }

  Future initializePlayer() async {
    log('id ---- ${widget.id}');

    await _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.id);

    WorkoutByIdResponseModel responseVid =
        _workoutByIdViewModel.apiResponse.data;

    youtubeVideoID() {
      String finalLink;
      String videoID = '${responseVid.data![0].workoutVideo}';
      List<String> splittedLink = videoID.split('v=');
      List<String> longLink = splittedLink.last.split('&');
      finalLink = longLink.first;
      return finalLink;
    }

    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      if ('${responseVid.data![0].workoutVideo}'.contains('www.youtube.com')) {
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
        _videoPlayerController = VideoPlayerController.network(
            '${responseVid.data![0].workoutVideo}');
        if (responseVid.data![0].workoutVideo != null) {
          await Future.wait([
            _videoPlayerController!.initialize(),
          ]);
        }

        _createChewieController();
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
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
  List<dynamic> data = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? GetBuilder<WorkoutByIdViewModel>(
              builder: (controller) {
                if (controller.apiResponse.status == Status.LOADING) {
                  return Center(
                    child: CircularProgressIndicator(color: ColorUtils.kTint),
                  );
                }
                if (controller.apiResponse.status == Status.ERROR) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (controller.apiResponse.status == Status.COMPLETE) {
                  WorkoutByIdResponseModel response =
                      controller.apiResponse.data;
                  data.clear();

                  response.data![0].daysAllData!.forEach((element) {
                    element.days.forEach((v) {
                      data.add(v);
                    });
                  });
                  print('response.data![0].workoutVideo ${response.data}');

                  List daysPerWeek = response.data![0].selectedDays == null
                      ? []
                      : response.data![0].selectedDays!.split(",");

                  return response.data![0].workoutVideo == null
                      ? screenData(response, controller, daysPerWeek)
                      : response.data![0].workoutVideo!
                              .contains('www.youtube.com')
                          ? _youTubePlayerController == null
                              ? screenData(response, controller, daysPerWeek)
                              : YoutubePlayerBuilder(
                                  onExitFullScreen: () {
                                    // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                    // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                                  },
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
                                        title: Text(
                                            '${response.data![0].workoutTitle}',
                                            style: FontTextStyle
                                                .kWhite16BoldRoboto),
                                        centerTitle: true,
                                        actions: [
                                          data.isNotEmpty || data.length != 0
                                              ? Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 18),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if (controller
                                                                .apiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          CheckWorkoutProgramRequestModel
                                                              _request =
                                                              CheckWorkoutProgramRequestModel();
                                                          _request.workoutId =
                                                              response.data![0]
                                                                  .workoutId;
                                                          _request.userId =
                                                              PreferenceManager
                                                                  .getUId();

                                                          await _checkWorkoutProgramViewModel
                                                              .checkWorkoutProgramViewModel(
                                                                  _request);

                                                          if (_checkWorkoutProgramViewModel
                                                                  .apiResponse
                                                                  .status ==
                                                              Status.COMPLETE) {
                                                            CheckWorkoutProgramResponseModel
                                                                checkResponse =
                                                                _checkWorkoutProgramViewModel
                                                                    .apiResponse
                                                                    .data;

                                                            if (checkResponse
                                                                    .success ==
                                                                true) {
                                                              if ('${response.data![0].workoutVideo}'
                                                                  .contains(
                                                                      'www.youtube.com')) {
                                                                _youTubePlayerController
                                                                    ?.pause();
                                                              } else {
                                                                _videoPlayerController
                                                                    ?.pause();
                                                                _chewieController
                                                                    ?.pause();
                                                              }
                                                              Get.to(
                                                                  ProgramSetupPage(
                                                                workoutId:
                                                                    '${response.data![0].workoutId}',
                                                                day: '1',
                                                                workoutName:
                                                                    '${response.data![0].workoutTitle}',
                                                              ));
                                                            } else if (checkResponse
                                                                    .success ==
                                                                false) {
                                                              Get.showSnackbar(
                                                                  GetSnackBar(
                                                                message:
                                                                    '${checkResponse.msg}',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    ColorUtils
                                                                        .kRed,
                                                              ));
                                                            }
                                                          } else if (_checkWorkoutProgramViewModel
                                                                  .apiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            Text(
                                                              'Something went wrong',
                                                              style: FontTextStyle
                                                                  .kWhite16W300Roboto,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Text('Start',
                                                          style: FontTextStyle
                                                              .kTine16W400Roboto),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      body: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: Get.height / 2.75,
                                              width: Get.width,
                                              child: '${response.data![0].workoutVideo}'
                                                      .contains(
                                                          'www.youtube.com')
                                                  ? Center(
                                                      child: _youTubePlayerController ==
                                                              null
                                                          ? CircularProgressIndicator(
                                                              color: ColorUtils
                                                                  .kTint)
                                                          : player,
                                                    )
                                                  : Center(
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
                                                          : response.data![0]
                                                                      .workoutImage ==
                                                                  null
                                                              ? noData()
                                                              : Image.network(
                                                                  response
                                                                      .data![0]
                                                                      .workoutImage!,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return noData();
                                                                  },
                                                                )),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                      height: Get.height * .02),
                                                  Container(
                                                    width: Get.width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                AppIcons
                                                                    .calender,
                                                                height: 15,
                                                                width: 15),
                                                            SizedBox(width: 5),
                                                            Text(
                                                                '${response.data![0].workoutDuration} WEEKS',
                                                                style: FontTextStyle
                                                                    .kWhite16BoldRoboto),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                AppIcons.clock,
                                                                height: 15,
                                                                width: 15),
                                                            SizedBox(width: 5),
                                                            Text(
                                                                '${daysPerWeek.length} x PER WEEK',
                                                                style: FontTextStyle
                                                                    .kWhite16BoldRoboto),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                AppIcons.medal,
                                                                height: 15,
                                                                width: 15),
                                                            SizedBox(width: 5),
                                                            Text(
                                                                '${response.data![0].levelTitle}',
                                                                style: FontTextStyle
                                                                    .kWhite16BoldRoboto),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: Get.height * .02),
                                                  htmlToText(
                                                      data:
                                                          '${response.data![0].workoutDescription}'),
                                                  // Text("${response.data![0].workoutDescription}",
                                                  //     maxLines: 5,
                                                  //     style: FontTextStyle.kWhite16W300Roboto),
                                                  SizedBox(
                                                      height: Get.height * .03),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'VIEW WORKOUTS',
                                                      style: FontTextStyle
                                                          .kWhite16BoldRoboto,
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: ColorUtils.kTint,
                                                    thickness: 1,
                                                  ),
                                                  SizedBox(
                                                      height: Get.height * .01),

                                                  data.isNotEmpty ||
                                                          data.length != 0
                                                      ? Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      Get.height *
                                                                          .012),
                                                          child: ListView
                                                              .separated(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                data.length,
                                                            separatorBuilder:
                                                                (_, index) {
                                                              return SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          .022);
                                                            },
                                                            itemBuilder:
                                                                (_, index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  if ('${response.data![0].workoutVideo}'
                                                                      .contains(
                                                                          'www.youtube.com')) {
                                                                    _youTubePlayerController
                                                                        ?.pause();
                                                                  } else {
                                                                    _videoPlayerController
                                                                        ?.pause();
                                                                    _chewieController
                                                                        ?.pause();
                                                                  }
                                                                  Get.to(
                                                                      WorkoutOverviewPage(
                                                                    day: index +
                                                                        1,
                                                                    workoutId:
                                                                        '${response.data![0].workoutId}',
                                                                    workoutDay:
                                                                        '${response.data![0].workoutDuration}',
                                                                    workoutName:
                                                                        '${response.data![0].workoutTitle}',
                                                                  ));
                                                                },
                                                                child:
                                                                    exerciseDayButton(
                                                                  day: '${response.data![0].dayNames![index]}'
                                                                      .capitalizeFirst,
                                                                  exercise:
                                                                      '${data[index].dayName}'
                                                                          .capitalizeFirst,
                                                                  weekDay:
                                                                      '${data[index].day}'
                                                                          .capitalizeFirst,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : Text(
                                                          'No days available',
                                                          style: FontTextStyle
                                                              .kTine17BoldRoboto,
                                                        ),

                                                  SizedBox(
                                                      height:
                                                          Get.height * .025),
                                                  data.isNotEmpty ||
                                                          data.length != 0
                                                      ? InkWell(
                                                          onTap: () async {
                                                            if (controller
                                                                    .apiResponse
                                                                    .status ==
                                                                Status
                                                                    .COMPLETE) {
                                                              CheckWorkoutProgramRequestModel
                                                                  _request =
                                                                  CheckWorkoutProgramRequestModel();
                                                              _request.workoutId =
                                                                  response
                                                                      .data![0]
                                                                      .workoutId;
                                                              _request.userId =
                                                                  PreferenceManager
                                                                      .getUId();

                                                              await _checkWorkoutProgramViewModel
                                                                  .checkWorkoutProgramViewModel(
                                                                      _request);

                                                              if (_checkWorkoutProgramViewModel
                                                                      .apiResponse
                                                                      .status ==
                                                                  Status
                                                                      .COMPLETE) {
                                                                CheckWorkoutProgramResponseModel
                                                                    checkResponse =
                                                                    _checkWorkoutProgramViewModel
                                                                        .apiResponse
                                                                        .data;

                                                                if (checkResponse
                                                                        .success ==
                                                                    true) {
                                                                  if ('${response.data![0].workoutVideo}'
                                                                      .contains(
                                                                          'www.youtube.com')) {
                                                                    _youTubePlayerController
                                                                        ?.pause();
                                                                  } else {
                                                                    _videoPlayerController
                                                                        ?.pause();
                                                                    _chewieController
                                                                        ?.pause();
                                                                  }
                                                                  Get.to(
                                                                      ProgramSetupPage(
                                                                    workoutId:
                                                                        '${response.data![0].workoutId}',
                                                                    day: '1',
                                                                    workoutName:
                                                                        '${response.data![0].workoutTitle}',
                                                                  ));
                                                                } else if (checkResponse
                                                                        .success ==
                                                                    false) {
                                                                  Get.showSnackbar(
                                                                      GetSnackBar(
                                                                    message:
                                                                        '${checkResponse.msg}',
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2),
                                                                    backgroundColor:
                                                                        ColorUtils
                                                                            .kRed,
                                                                  ));
                                                                }
                                                              } else if (_checkWorkoutProgramViewModel
                                                                      .apiResponse
                                                                      .status ==
                                                                  Status
                                                                      .ERROR) {
                                                                Text(
                                                                  'Something went wrong',
                                                                  style: FontTextStyle
                                                                      .kWhite16W300Roboto,
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 15,
                                                                    top: 5,
                                                                    right: 12,
                                                                    left: 12),
                                                            alignment: Alignment
                                                                .center,
                                                            height: Get.height *
                                                                .06,
                                                            width: Get.width,
                                                            decoration:
                                                                BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      begin: Alignment
                                                                          .topCenter,
                                                                      end: Alignment
                                                                          .bottomCenter,
                                                                      stops: [
                                                                        0.0,
                                                                        1.0
                                                                      ],
                                                                      colors: ColorUtilsGradient
                                                                          .kTintGradient,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6)),
                                                            child: Text(
                                                                'Start Program',
                                                                style: FontTextStyle
                                                                    .kBlack20BoldRoboto),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                      height: Get.height * .03),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                          : response.data![0].workoutVideo!
                                  .contains('https://vimeo.com/')
                              ? Scaffold(
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
                                    title: Text(
                                        '${response.data![0].workoutTitle}',
                                        style:
                                            FontTextStyle.kWhite16BoldRoboto),
                                    centerTitle: true,
                                    actions: [
                                      data.isNotEmpty || data.length != 0
                                          ? Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (controller.apiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      CheckWorkoutProgramRequestModel
                                                          _request =
                                                          CheckWorkoutProgramRequestModel();
                                                      _request.workoutId =
                                                          response.data![0]
                                                              .workoutId;
                                                      _request.userId =
                                                          PreferenceManager
                                                              .getUId();

                                                      await _checkWorkoutProgramViewModel
                                                          .checkWorkoutProgramViewModel(
                                                              _request);

                                                      if (_checkWorkoutProgramViewModel
                                                              .apiResponse
                                                              .status ==
                                                          Status.COMPLETE) {
                                                        CheckWorkoutProgramResponseModel
                                                            checkResponse =
                                                            _checkWorkoutProgramViewModel
                                                                .apiResponse
                                                                .data;

                                                        if (checkResponse
                                                                .success ==
                                                            true) {
                                                          // if ('${response.data![0].workoutVideo}'
                                                          //     .contains(
                                                          //         'www.youtube.com')) {
                                                          //   _youTubePlayerController
                                                          //       ?.pause();
                                                          // } else {
                                                          //   _videoPlayerController
                                                          //       ?.pause();
                                                          //   _chewieController?.pause();
                                                          // }
                                                          Get.to(
                                                              ProgramSetupPage(
                                                            workoutId:
                                                                '${response.data![0].workoutId}',
                                                            day: '1',
                                                            workoutName:
                                                                '${response.data![0].workoutTitle}',
                                                          ));
                                                        } else if (checkResponse
                                                                .success ==
                                                            false) {
                                                          Get.showSnackbar(
                                                              GetSnackBar(
                                                            message:
                                                                '${checkResponse.msg}',
                                                            duration: Duration(
                                                                seconds: 2),
                                                            backgroundColor:
                                                                ColorUtils.kRed,
                                                          ));
                                                        }
                                                      } else if (_checkWorkoutProgramViewModel
                                                              .apiResponse
                                                              .status ==
                                                          Status.ERROR) {
                                                        Text(
                                                          'Something went wrong',
                                                          style: FontTextStyle
                                                              .kWhite16W300Roboto,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Text('Start',
                                                      style: FontTextStyle
                                                          .kTine16W400Roboto),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  body: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: Get.height / 2.75,
                                          width: Get.width,
                                          child: Center(
                                            child: VimeoVideoPlayer(
                                              vimeoPlayerModel:
                                                  VimeoPlayerModel(
                                                // url: 'https://vimeo.com/336812686',
                                                url: response
                                                    .data![0].workoutVideo!,
                                                deviceOrientation:
                                                    DeviceOrientation
                                                        .portraitUp,
                                                systemUiOverlay: const [
                                                  SystemUiOverlay.top,
                                                  SystemUiOverlay.bottom,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  height: Get.height * .02),
                                              Container(
                                                width: Get.width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppIcons.calender,
                                                            height: 15,
                                                            width: 15,
                                                            color: ColorUtils
                                                                .kTint),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            '${response.data![0].workoutDuration} WEEKS',
                                                            style: FontTextStyle
                                                                .kWhite16BoldRoboto),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          AppIcons.clock,
                                                          height: 15,
                                                          width: 15,
                                                          color:
                                                              ColorUtils.kTint,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            '${daysPerWeek.length} x PER WEEK',
                                                            style: FontTextStyle
                                                                .kWhite16BoldRoboto),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppIcons.medal,
                                                            height: 15,
                                                            width: 15,
                                                            color: ColorUtils
                                                                .kTint),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            '${response.data![0].levelTitle}',
                                                            style: FontTextStyle
                                                                .kWhite16BoldRoboto),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Get.height * .02),
                                              htmlToText(
                                                  data:
                                                      '${response.data![0].workoutDescription}'),
                                              // Text("${response.data![0].workoutDescription}",
                                              //     maxLines: 5,
                                              //     style: FontTextStyle.kWhite16W300Roboto),
                                              SizedBox(
                                                  height: Get.height * .03),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'VIEW WORKOUTS',
                                                  style: FontTextStyle
                                                      .kWhite16BoldRoboto,
                                                ),
                                              ),
                                              Divider(
                                                color: ColorUtils.kTint,
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                  height: Get.height * .01),

                                              data.isNotEmpty ||
                                                      data.length != 0
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  Get.height *
                                                                      .012),
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: data.length,
                                                        separatorBuilder:
                                                            (_, index) {
                                                          return SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      .022);
                                                        },
                                                        itemBuilder:
                                                            (_, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              if ('${response.data![0].workoutVideo}'
                                                                  .contains(
                                                                      'www.youtube.com')) {
                                                                _youTubePlayerController
                                                                    ?.pause();
                                                              } else {
                                                                _videoPlayerController
                                                                    ?.pause();
                                                                _chewieController
                                                                    ?.pause();
                                                              }
                                                              Get.to(
                                                                  WorkoutOverviewPage(
                                                                day: index + 1,
                                                                workoutId:
                                                                    '${response.data![0].workoutId}',
                                                                workoutDay:
                                                                    '${response.data![0].workoutDuration}',
                                                                workoutName:
                                                                    '${response.data![0].workoutTitle}',
                                                              ));
                                                            },
                                                            child:
                                                                exerciseDayButton(
                                                              day: '${response.data![0].dayNames![index]}'
                                                                  .capitalizeFirst,
                                                              exercise:
                                                                  '${data[index].dayName}'
                                                                      .capitalizeFirst,
                                                              weekDay:
                                                                  '${data[index].day}'
                                                                      .capitalizeFirst,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Text(
                                                      'No days available',
                                                      style: FontTextStyle
                                                          .kTine17BoldRoboto,
                                                    ),

                                              SizedBox(
                                                  height: Get.height * .025),
                                              data.isNotEmpty ||
                                                      data.length != 0
                                                  ? InkWell(
                                                      onTap: () async {
                                                        if (controller
                                                                .apiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          CheckWorkoutProgramRequestModel
                                                              _request =
                                                              CheckWorkoutProgramRequestModel();
                                                          _request.workoutId =
                                                              response.data![0]
                                                                  .workoutId;
                                                          _request.userId =
                                                              PreferenceManager
                                                                  .getUId();

                                                          await _checkWorkoutProgramViewModel
                                                              .checkWorkoutProgramViewModel(
                                                                  _request);

                                                          if (_checkWorkoutProgramViewModel
                                                                  .apiResponse
                                                                  .status ==
                                                              Status.COMPLETE) {
                                                            CheckWorkoutProgramResponseModel
                                                                checkResponse =
                                                                _checkWorkoutProgramViewModel
                                                                    .apiResponse
                                                                    .data;

                                                            if (checkResponse
                                                                    .success ==
                                                                true) {
                                                              if ('${response.data![0].workoutVideo}'
                                                                  .contains(
                                                                      'www.youtube.com')) {
                                                                _youTubePlayerController
                                                                    ?.pause();
                                                              } else {
                                                                _videoPlayerController
                                                                    ?.pause();
                                                                _chewieController
                                                                    ?.pause();
                                                              }
                                                              Get.to(
                                                                  ProgramSetupPage(
                                                                workoutId:
                                                                    '${response.data![0].workoutId}',
                                                                day: '1',
                                                                workoutName:
                                                                    '${response.data![0].workoutTitle}',
                                                              ));
                                                            } else if (checkResponse
                                                                    .success ==
                                                                false) {
                                                              Get.showSnackbar(
                                                                  GetSnackBar(
                                                                message:
                                                                    '${checkResponse.msg}',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    ColorUtils
                                                                        .kRed,
                                                              ));
                                                            }
                                                          } else if (_checkWorkoutProgramViewModel
                                                                  .apiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            Text(
                                                              'Something went wrong',
                                                              style: FontTextStyle
                                                                  .kWhite16W300Roboto,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15,
                                                            top: 5,
                                                            right: 12,
                                                            left: 12),
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            Get.height * .06,
                                                        width: Get.width,
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ],
                                                                  colors: ColorUtilsGradient
                                                                      .kTintGradient,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                        child: Text(
                                                            'Start Program',
                                                            style: FontTextStyle
                                                                .kBlack20BoldRoboto),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                  height: Get.height * .03),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Scaffold(
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
                                    title: Text(
                                        '${response.data![0].workoutTitle}',
                                        style:
                                            FontTextStyle.kWhite16BoldRoboto),
                                    centerTitle: true,
                                    actions: [
                                      data.isNotEmpty || data.length != 0
                                          ? Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (controller.apiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      CheckWorkoutProgramRequestModel
                                                          _request =
                                                          CheckWorkoutProgramRequestModel();
                                                      _request.workoutId =
                                                          response.data![0]
                                                              .workoutId;
                                                      _request.userId =
                                                          PreferenceManager
                                                              .getUId();

                                                      await _checkWorkoutProgramViewModel
                                                          .checkWorkoutProgramViewModel(
                                                              _request);

                                                      if (_checkWorkoutProgramViewModel
                                                              .apiResponse
                                                              .status ==
                                                          Status.COMPLETE) {
                                                        CheckWorkoutProgramResponseModel
                                                            checkResponse =
                                                            _checkWorkoutProgramViewModel
                                                                .apiResponse
                                                                .data;

                                                        if (checkResponse
                                                                .success ==
                                                            true) {
                                                          if ('${response.data![0].workoutVideo}'
                                                              .contains(
                                                                  'www.youtube.com')) {
                                                            _youTubePlayerController
                                                                ?.pause();
                                                          } else {
                                                            _videoPlayerController
                                                                ?.pause();
                                                            _chewieController
                                                                ?.pause();
                                                          }
                                                          Get.to(
                                                              ProgramSetupPage(
                                                            workoutId:
                                                                '${response.data![0].workoutId}',
                                                            day: '1',
                                                            workoutName:
                                                                '${response.data![0].workoutTitle}',
                                                          ));
                                                        } else if (checkResponse
                                                                .success ==
                                                            false) {
                                                          Get.showSnackbar(
                                                              GetSnackBar(
                                                            message:
                                                                '${checkResponse.msg}',
                                                            duration: Duration(
                                                                seconds: 2),
                                                            backgroundColor:
                                                                ColorUtils.kRed,
                                                          ));
                                                        }
                                                      } else if (_checkWorkoutProgramViewModel
                                                              .apiResponse
                                                              .status ==
                                                          Status.ERROR) {
                                                        Text(
                                                          'Something went wrong',
                                                          style: FontTextStyle
                                                              .kWhite16W300Roboto,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Text('Start',
                                                      style: FontTextStyle
                                                          .kTine16W400Roboto),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  body: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: Get.height / 2.75,
                                          width: Get.width,
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
                                                  : response.data![0]
                                                              .workoutImage ==
                                                          null
                                                      ? noData()
                                                      : Image.network(
                                                          response.data![0]
                                                              .workoutImage!,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return noData();
                                                          },
                                                        )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  height: Get.height * .02),
                                              Container(
                                                width: Get.width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppIcons.calender,
                                                            height: 15,
                                                            width: 15,
                                                            color: ColorUtils
                                                                .kTint),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            '${response.data![0].workoutDuration} WEEKS',
                                                            style: FontTextStyle
                                                                .kWhite16BoldRoboto),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          AppIcons.clock,
                                                          height: 15,
                                                          width: 15,
                                                          color:
                                                              ColorUtils.kTint,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            '${daysPerWeek.length} x PER WEEK',
                                                            style: FontTextStyle
                                                                .kWhite16BoldRoboto),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppIcons.medal,
                                                            height: 15,
                                                            width: 15,
                                                            color: ColorUtils
                                                                .kTint),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            '${response.data![0].levelTitle}',
                                                            style: FontTextStyle
                                                                .kWhite16BoldRoboto),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Get.height * .02),
                                              htmlToText(
                                                  data:
                                                      '${response.data![0].workoutDescription}'),
                                              // Text("${response.data![0].workoutDescription}",
                                              //     maxLines: 5,
                                              //     style: FontTextStyle.kWhite16W300Roboto),
                                              SizedBox(
                                                  height: Get.height * .03),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'VIEW WORKOUTS',
                                                  style: FontTextStyle
                                                      .kWhite16BoldRoboto,
                                                ),
                                              ),
                                              Divider(
                                                color: ColorUtils.kTint,
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                  height: Get.height * .01),

                                              data.isNotEmpty ||
                                                      data.length != 0
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  Get.height *
                                                                      .012),
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: data.length,
                                                        separatorBuilder:
                                                            (_, index) {
                                                          return SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      .022);
                                                        },
                                                        itemBuilder:
                                                            (_, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              if ('${response.data![0].workoutVideo}'
                                                                  .contains(
                                                                      'www.youtube.com')) {
                                                                _youTubePlayerController
                                                                    ?.pause();
                                                              } else {
                                                                _videoPlayerController
                                                                    ?.pause();
                                                                _chewieController
                                                                    ?.pause();
                                                              }
                                                              Get.to(
                                                                  WorkoutOverviewPage(
                                                                day: index + 1,
                                                                workoutId:
                                                                    '${response.data![0].workoutId}',
                                                                workoutDay:
                                                                    '${response.data![0].workoutDuration}',
                                                                workoutName:
                                                                    '${response.data![0].workoutTitle}',
                                                              ));
                                                            },
                                                            child:
                                                                exerciseDayButton(
                                                              day: '${response.data![0].dayNames![index]}'
                                                                  .capitalizeFirst,
                                                              exercise:
                                                                  '${data[index].dayName}'
                                                                      .capitalizeFirst,
                                                              weekDay:
                                                                  '${data[index].day}'
                                                                      .capitalizeFirst,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Text(
                                                      'No days available',
                                                      style: FontTextStyle
                                                          .kTine17BoldRoboto,
                                                    ),

                                              SizedBox(
                                                  height: Get.height * .025),
                                              data.isNotEmpty ||
                                                      data.length != 0
                                                  ? InkWell(
                                                      onTap: () async {
                                                        if (controller
                                                                .apiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          CheckWorkoutProgramRequestModel
                                                              _request =
                                                              CheckWorkoutProgramRequestModel();
                                                          _request.workoutId =
                                                              response.data![0]
                                                                  .workoutId;
                                                          _request.userId =
                                                              PreferenceManager
                                                                  .getUId();

                                                          await _checkWorkoutProgramViewModel
                                                              .checkWorkoutProgramViewModel(
                                                                  _request);

                                                          if (_checkWorkoutProgramViewModel
                                                                  .apiResponse
                                                                  .status ==
                                                              Status.COMPLETE) {
                                                            CheckWorkoutProgramResponseModel
                                                                checkResponse =
                                                                _checkWorkoutProgramViewModel
                                                                    .apiResponse
                                                                    .data;

                                                            if (checkResponse
                                                                    .success ==
                                                                true) {
                                                              if ('${response.data![0].workoutVideo}'
                                                                  .contains(
                                                                      'www.youtube.com')) {
                                                                _youTubePlayerController
                                                                    ?.pause();
                                                              } else {
                                                                _videoPlayerController
                                                                    ?.pause();
                                                                _chewieController
                                                                    ?.pause();
                                                              }
                                                              Get.to(
                                                                  ProgramSetupPage(
                                                                workoutId:
                                                                    '${response.data![0].workoutId}',
                                                                day: '1',
                                                                workoutName:
                                                                    '${response.data![0].workoutTitle}',
                                                              ));
                                                            } else if (checkResponse
                                                                    .success ==
                                                                false) {
                                                              Get.showSnackbar(
                                                                  GetSnackBar(
                                                                message:
                                                                    '${checkResponse.msg}',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    ColorUtils
                                                                        .kRed,
                                                              ));
                                                            }
                                                          } else if (_checkWorkoutProgramViewModel
                                                                  .apiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            Text(
                                                              'Something went wrong',
                                                              style: FontTextStyle
                                                                  .kWhite16W300Roboto,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15,
                                                            top: 5,
                                                            right: 12,
                                                            left: 12),
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            Get.height * .06,
                                                        width: Get.width,
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ],
                                                                  colors: ColorUtilsGradient
                                                                      .kTintGradient,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                        child: Text(
                                                            'Start Program',
                                                            style: FontTextStyle
                                                                .kBlack20BoldRoboto),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                  height: Get.height * .03),
                                            ],
                                          ),
                                        ),
                                      ],
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
              },
            )
          : ConnectionCheckScreen();
    });
  }

  Widget screenData(WorkoutByIdResponseModel response,
      WorkoutByIdViewModel controller, List<dynamic> daysPerWeek) {
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
        title: Text('${response.data![0].workoutTitle}',
            style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: InkWell(
                onTap: () async {
                  if (controller.apiResponse.status == Status.COMPLETE) {
                    CheckWorkoutProgramRequestModel _request =
                        CheckWorkoutProgramRequestModel();
                    _request.workoutId = response.data![0].workoutId;
                    _request.userId = PreferenceManager.getUId();

                    await _checkWorkoutProgramViewModel
                        .checkWorkoutProgramViewModel(_request);

                    if (_checkWorkoutProgramViewModel.apiResponse.status ==
                        Status.COMPLETE) {
                      CheckWorkoutProgramResponseModel checkResponse =
                          _checkWorkoutProgramViewModel.apiResponse.data;

                      if (checkResponse.success == true) {
                        if ('${response.data![0].workoutVideo}'
                            .contains('www.youtube.com')) {
                          _youTubePlayerController?.pause();
                        } else {
                          _videoPlayerController?.pause();
                          _chewieController?.pause();
                        }
                        Get.to(ProgramSetupPage(
                          workoutId: '${response.data![0].workoutId}',
                          day: '1',
                          workoutName: '${response.data![0].workoutTitle}',
                        ));
                      } else if (checkResponse.success == false) {
                        Get.showSnackbar(GetSnackBar(
                          message: '${checkResponse.msg}',
                          duration: Duration(seconds: 2),
                          backgroundColor: ColorUtils.kRed,
                        ));
                      }
                    } else if (_checkWorkoutProgramViewModel
                            .apiResponse.status ==
                        Status.ERROR) {
                      Text(
                        'Something went wrong',
                        style: FontTextStyle.kWhite16W300Roboto,
                      );
                    }
                  }
                },
                child: Text('Start', style: FontTextStyle.kTine16W400Roboto),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: Get.height / 2.75,
              width: Get.width,
              child: '${response.data![0].workoutVideo}'
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
                            ),
                    )
                  : Center(
                      child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                          ? Chewie(
                              controller: _chewieController!,
                            )
                          : response.data![0].workoutImage == null
                              ? noData()
                              : Image.network(
                                  response.data![0].workoutImage!,
                                  errorBuilder: (context, error, stackTrace) {
                                    return noData();
                                  },
                                )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: Get.height * .02),
                  Container(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(AppIcons.calender,
                                height: 15, width: 15),
                            SizedBox(width: 5),
                            Text('${response.data![0].workoutDuration} WEEKS',
                                style: FontTextStyle.kWhite16BoldRoboto),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(AppIcons.clock, height: 15, width: 15),
                            SizedBox(width: 5),
                            Text('${daysPerWeek.length} x PER WEEK',
                                style: FontTextStyle.kWhite16BoldRoboto),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(AppIcons.medal, height: 15, width: 15),
                            SizedBox(width: 5),
                            Text('${response.data![0].levelTitle}',
                                style: FontTextStyle.kWhite16BoldRoboto),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * .02),
                  htmlToText(data: '${response.data![0].workoutDescription}'),
                  // Text("${response.data![0].workoutDescription}",
                  //     maxLines: 5,
                  //     style: FontTextStyle.kWhite16W300Roboto),
                  SizedBox(height: Get.height * .03),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'VIEW WORKOUTS',
                      style: FontTextStyle.kWhite16BoldRoboto,
                    ),
                  ),
                  Divider(
                    color: ColorUtils.kTint,
                    thickness: 1,
                  ),
                  SizedBox(height: Get.height * .01),

                  data.isNotEmpty || data.length != 0
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Get.height * .012),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            separatorBuilder: (_, index) {
                              return SizedBox(height: Get.height * .022);
                            },
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {
                                  if ('${response.data![0].workoutVideo}'
                                      .contains('www.youtube.com')) {
                                    _youTubePlayerController?.pause();
                                  } else {
                                    _videoPlayerController?.pause();
                                    _chewieController?.pause();
                                  }
                                  Get.to(WorkoutOverviewPage(
                                    day: index + 1,
                                    workoutId: '${response.data![0].workoutId}',
                                    workoutDay:
                                        '${response.data![0].workoutDuration}',
                                    workoutName:
                                        '${response.data![0].workoutTitle}',
                                  ));
                                },
                                child: exerciseDayButton(
                                  day: '${response.data![0].dayNames![index]}'
                                      .capitalizeFirst,
                                  exercise:
                                      '${data[index].dayName}'.capitalizeFirst,
                                  weekDay: '${data[index].day}'.capitalizeFirst,
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          'No days available',
                          style: FontTextStyle.kTine17BoldRoboto,
                        ),

                  SizedBox(height: Get.height * .025),
                  data.isNotEmpty || data.length != 0
                      ? InkWell(
                          onTap: () async {
                            if (controller.apiResponse.status ==
                                Status.COMPLETE) {
                              CheckWorkoutProgramRequestModel _request =
                                  CheckWorkoutProgramRequestModel();
                              _request.workoutId = response.data![0].workoutId;
                              _request.userId = PreferenceManager.getUId();

                              await _checkWorkoutProgramViewModel
                                  .checkWorkoutProgramViewModel(_request);

                              if (_checkWorkoutProgramViewModel
                                      .apiResponse.status ==
                                  Status.COMPLETE) {
                                CheckWorkoutProgramResponseModel checkResponse =
                                    _checkWorkoutProgramViewModel
                                        .apiResponse.data;

                                if (checkResponse.success == true) {
                                  if ('${response.data![0].workoutVideo}'
                                      .contains('www.youtube.com')) {
                                    _youTubePlayerController?.pause();
                                  } else {
                                    _videoPlayerController?.pause();
                                    _chewieController?.pause();
                                  }
                                  Get.to(ProgramSetupPage(
                                    workoutId: '${response.data![0].workoutId}',
                                    day: '1',
                                    workoutName:
                                        '${response.data![0].workoutTitle}',
                                  ));
                                } else if (checkResponse.success == false) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: '${checkResponse.msg}',
                                    duration: Duration(seconds: 2),
                                    backgroundColor: ColorUtils.kRed,
                                  ));
                                }
                              } else if (_checkWorkoutProgramViewModel
                                      .apiResponse.status ==
                                  Status.ERROR) {
                                Text(
                                  'Something went wrong',
                                  style: FontTextStyle.kWhite16W300Roboto,
                                );
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 15, top: 5, right: 12, left: 12),
                            alignment: Alignment.center,
                            height: Get.height * .06,
                            width: Get.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: ColorUtilsGradient.kTintGradient,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text('Start Program',
                                style: FontTextStyle.kBlack20BoldRoboto),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: Get.height * .03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row exerciseDayButton({String? day, String? exercise, String? weekDay}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                text: '$day - ',
                style: FontTextStyle.kWhite17BoldRoboto,
                children: [
              TextSpan(text: exercise, style: FontTextStyle.kWhite17W400Roboto),
              TextSpan(
                  text: ' ( $weekDay )',
                  style: FontTextStyle.kWhite17W400Roboto)
            ])),
        Icon(
          Icons.arrow_forward_ios_sharp,
          color: ColorUtils.kTint,
          size: Get.height * .026,
        )
      ],
    );
  }
}
