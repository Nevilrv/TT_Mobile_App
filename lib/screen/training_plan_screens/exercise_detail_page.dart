import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/vimeo_video_player/vimeo_video_player.dart';
import 'package:tcm/model/request_model/training_plan_request_model/check_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/check_workout_program_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/training_plan_screens/program_setup_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/check_workout_program_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseDetailPage extends StatefulWidget {
  final String? exerciseId;
  final String? day;
  final String? workoutId;
  final String? workoutDay;
  final String? workoutName;
  final String? workoutImage;
  final bool isFromExercise;

  ExerciseDetailPage(
      {Key? key,
      required this.exerciseId,
      this.workoutId,
      this.day,
      this.workoutImage,
      this.workoutDay,
      this.workoutName,
      required this.isFromExercise})
      : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;
  ChewieController? _chewieController;
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  CheckWorkoutProgramViewModel _checkWorkoutProgramViewModel =
      Get.put(CheckWorkoutProgramViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();

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
    await _exerciseByIdViewModel.getExerciseByIdDetails(id: widget.exerciseId);

    ExerciseByIdResponseModel responseVid =
        _exerciseByIdViewModel.apiResponse.data;

    log('responseVid.data![0].exerciseVideo>>>>>>>  ${responseVid.data![0].exerciseVideo}');

    youtubeVideoID() {
      String finalLink;
      String videoID = '${responseVid.data![0].exerciseVideo}';
      List<String> splittedLink = videoID.split('v=');
      List<String> longLink = splittedLink.last.split('&');
      finalLink = longLink.first;
      return finalLink;
    }

    if (_exerciseByIdViewModel.apiResponse.status == Status.COMPLETE) {
      if ('${responseVid.data![0].exerciseVideo}'.contains('www.youtube.com')) {
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
            '${responseVid.data![0].exerciseVideo}');
        await Future.wait([
          _videoPlayerController!.initialize(),
        ]);
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
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? GetBuilder<ExerciseByIdViewModel>(builder: (controller) {
              print(
                  'true false ============ ${widget.isFromExercise == false}');

              if (controller.apiResponse.status == Status.COMPLETE) {
                ExerciseByIdResponseModel response =
                    controller.apiResponse.data;

                String htmlData = '${response.data![0].exerciseTips}';
                List<String> splitHTMLString = htmlData.split('</li>');
                List<String> finalHTMLString = [];
                splitHTMLString.forEach((element) {
                  finalHTMLString.add(
                      element.replaceAll('<ol>', '').replaceAll('</ol>', ''));
                });

                print(
                    'final response.data![0].exerciseVideo! ========================= ${response.data![0].exerciseVideo}');
                if (response.data![0].exerciseVideo != null) {
                  return response.data![0].exerciseVideo
                          .contains('www.youtube.com')
                      ? _youTubePlayerController == null ||
                              _youTubePlayerController == ''
                          ? Center(
                              child: CircularProgressIndicator(
                              color: ColorUtils.kTint,
                            ))
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
                                        '${response.data![0].exerciseTitle}',
                                        style:
                                            FontTextStyle.kWhite16BoldRoboto),
                                    centerTitle: true,
                                    actions: [
                                      !widget.isFromExercise
                                          ? Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 18),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (controller.apiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      CheckWorkoutProgramRequestModel
                                                          _request =
                                                          CheckWorkoutProgramRequestModel();
                                                      _request.workoutId =
                                                          widget.workoutId;
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
                                                          if ('${response.data![0].exerciseVideo}'
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
                                                          Get.to(() =>
                                                              ProgramSetupPage(
                                                                exerciseId: response
                                                                    .data![0]
                                                                    .exerciseId,
                                                                day: widget.day,
                                                                workoutId: widget
                                                                    .workoutId,
                                                                workoutName: widget
                                                                    .workoutName,
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
                                    child: Column(children: [
                                      Container(
                                        height: Get.height / 2.75,
                                        width: Get.width,
                                        child: Center(
                                          child: _youTubePlayerController !=
                                                      null ||
                                                  _youTubePlayerController != ''
                                              ? player
                                              : CircularProgressIndicator(
                                                  color: ColorUtils.kTint),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${response.data![0].exerciseTitle}'
                                                                .length >=
                                                            25
                                                        ? '${response.data![0].exerciseTitle!.substring(0, 25) + ' ..'}'
                                                        : '${response.data![0].exerciseTitle}',
                                                    style: FontTextStyle
                                                        .kWhite17BoldRoboto),
                                                RichText(
                                                  text: TextSpan(
                                                      text: 'Suggested: ',
                                                      style: FontTextStyle
                                                          .kLightGray16W300Roboto
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${response.data![0].exerciseSets}x${response.data![0].exerciseReps} reps',
                                                          style: FontTextStyle
                                                              .kLightGray16W300Roboto,
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                            // response.data![0].exerciseImage!.isEmpty
                                            //     ? SizedBox()
                                            //     : Container(
                                            //         alignment: Alignment.center,
                                            //         margin: EdgeInsets.symmetric(vertical: 5),
                                            //         height: Get.height * 0.25,
                                            //         width: Get.width,
                                            //         decoration: BoxDecoration(
                                            //             image: DecorationImage(
                                            //           fit: BoxFit.fitWidth,
                                            //           image: NetworkImage(
                                            //               '$baseImageUrl${response.data![0].exerciseImage}'),
                                            //         )),
                                            //       ),
                                            Container(
                                              padding: EdgeInsets.only(top: 20),
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
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    finalHTMLString.length - 1,
                                                itemBuilder: (_, index) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              ColorUtils.kTint,
                                                          radius:
                                                              Get.width * 0.04,
                                                          child: Text(
                                                              '${index + 1}',
                                                              style: FontTextStyle
                                                                  .kBlack12BoldRoboto),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: htmlToText(
                                                              data:
                                                                  finalHTMLString[
                                                                      index]))
                                                      // Text(
                                                      //     '${response.data![0].exerciseInstructions}',
                                                      //     maxLines: 4,
                                                      //     style: FontTextStyle.kWhite16W300Roboto)
                                                      // ),
                                                    ],
                                                  );
                                                }),
                                            SizedBox(height: Get.height * 0.03),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                            )
                      : response.data![0].exerciseVideo
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
                                    '${response.data![0].exerciseTitle}',
                                    style: FontTextStyle.kWhite16BoldRoboto),
                                centerTitle: true,
                                actions: [
                                  !widget.isFromExercise
                                      ? Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 18),
                                            child: InkWell(
                                              onTap: () async {
                                                if (controller
                                                        .apiResponse.status ==
                                                    Status.COMPLETE) {
                                                  CheckWorkoutProgramRequestModel
                                                      _request =
                                                      CheckWorkoutProgramRequestModel();
                                                  _request.workoutId =
                                                      widget.workoutId;
                                                  _request.userId =
                                                      PreferenceManager
                                                          .getUId();

                                                  await _checkWorkoutProgramViewModel
                                                      .checkWorkoutProgramViewModel(
                                                          _request);

                                                  if (_checkWorkoutProgramViewModel
                                                          .apiResponse.status ==
                                                      Status.COMPLETE) {
                                                    CheckWorkoutProgramResponseModel
                                                        checkResponse =
                                                        _checkWorkoutProgramViewModel
                                                            .apiResponse.data;

                                                    if (checkResponse.success ==
                                                        true) {
                                                      if ('${response.data![0].exerciseVideo}'
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
                                                      Get.to(() =>
                                                          ProgramSetupPage(
                                                            exerciseId: response
                                                                .data![0]
                                                                .exerciseId,
                                                            day: widget.day,
                                                            workoutId: widget
                                                                .workoutId,
                                                            workoutName: widget
                                                                .workoutName,
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
                                                          .apiResponse.status ==
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
                                child: Column(children: [
                                  Container(
                                    height: Get.height / 2.75,
                                    width: Get.width,
                                    child: Center(
                                      child: VimeoVideoPlayer(
                                        // url: 'https://vimeo.com/336812686',
                                        url: response.data![0].exerciseVideo!,
                                        deviceOrientation:
                                            DeviceOrientation.portraitUp,
                                        systemUiOverlay: const [
                                          SystemUiOverlay.top,
                                          SystemUiOverlay.bottom,
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${response.data![0].exerciseTitle}'
                                                            .length >=
                                                        25
                                                    ? '${response.data![0].exerciseTitle!.substring(0, 25) + ' ..'}'
                                                    : '${response.data![0].exerciseTitle}',
                                                style: FontTextStyle
                                                    .kWhite17BoldRoboto),
                                            RichText(
                                              text: TextSpan(
                                                  text: 'Suggested: ',
                                                  style: FontTextStyle
                                                      .kLightGray16W300Roboto
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${response.data![0].exerciseSets}x${response.data![0].exerciseReps} reps',
                                                      style: FontTextStyle
                                                          .kLightGray16W300Roboto,
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        // response.data![0].exerciseImage!.isEmpty
                                        //     ? SizedBox()
                                        //     : Container(
                                        //         alignment: Alignment.center,
                                        //         margin: EdgeInsets.symmetric(vertical: 5),
                                        //         height: Get.height * 0.25,
                                        //         width: Get.width,
                                        //         decoration: BoxDecoration(
                                        //             image: DecorationImage(
                                        //           fit: BoxFit.fitWidth,
                                        //           image: NetworkImage(
                                        //               '$baseImageUrl${response.data![0].exerciseImage}'),
                                        //         )),
                                        //       ),
                                        Container(
                                          padding: EdgeInsets.only(top: 20),
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
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                finalHTMLString.length - 1,
                                            itemBuilder: (_, index) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          ColorUtils.kTint,
                                                      radius: Get.width * 0.04,
                                                      child: Text(
                                                          '${index + 1}',
                                                          style: FontTextStyle
                                                              .kBlack12BoldRoboto),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: htmlToText(
                                                          data: finalHTMLString[
                                                              index]))
                                                  // Text(
                                                  //     '${response.data![0].exerciseInstructions}',
                                                  //     maxLines: 4,
                                                  //     style: FontTextStyle.kWhite16W300Roboto)
                                                  // ),
                                                ],
                                              );
                                            }),
                                        SizedBox(height: Get.height * 0.03),
                                      ],
                                    ),
                                  ),
                                ]),
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
                                    '${response.data![0].exerciseTitle}',
                                    style: FontTextStyle.kWhite16BoldRoboto),
                                centerTitle: true,
                                actions: [
                                  !widget.isFromExercise
                                      ? Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 18),
                                            child: InkWell(
                                              onTap: () async {
                                                if (controller
                                                        .apiResponse.status ==
                                                    Status.COMPLETE) {
                                                  CheckWorkoutProgramRequestModel
                                                      _request =
                                                      CheckWorkoutProgramRequestModel();
                                                  _request.workoutId =
                                                      widget.workoutId;
                                                  _request.userId =
                                                      PreferenceManager
                                                          .getUId();

                                                  await _checkWorkoutProgramViewModel
                                                      .checkWorkoutProgramViewModel(
                                                          _request);

                                                  if (_checkWorkoutProgramViewModel
                                                          .apiResponse.status ==
                                                      Status.COMPLETE) {
                                                    CheckWorkoutProgramResponseModel
                                                        checkResponse =
                                                        _checkWorkoutProgramViewModel
                                                            .apiResponse.data;

                                                    if (checkResponse.success ==
                                                        true) {
                                                      if ('${response.data![0].exerciseVideo}'
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
                                                      Get.to(() =>
                                                          ProgramSetupPage(
                                                            exerciseId: response
                                                                .data![0]
                                                                .exerciseId,
                                                            day: widget.day,
                                                            workoutId: widget
                                                                .workoutId,
                                                            workoutName: widget
                                                                .workoutName,
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
                                                          .apiResponse.status ==
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
                                child: Column(children: [
                                  Container(
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
                                            : response.data![0].exerciseImage ==
                                                    null
                                                ? noData()
                                                : Image.network(
                                                    response.data![0]
                                                        .exerciseImage!,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return noData();
                                                    },
                                                  )),
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${response.data![0].exerciseTitle}'
                                                            .length >=
                                                        25
                                                    ? '${response.data![0].exerciseTitle!.substring(0, 25) + ' ..'}'
                                                    : '${response.data![0].exerciseTitle}',
                                                style: FontTextStyle
                                                    .kWhite17BoldRoboto),
                                            RichText(
                                              text: TextSpan(
                                                  text: 'Suggested: ',
                                                  style: FontTextStyle
                                                      .kLightGray16W300Roboto
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${response.data![0].exerciseSets}x${response.data![0].exerciseReps} reps',
                                                      style: FontTextStyle
                                                          .kLightGray16W300Roboto,
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        // response.data![0].exerciseImage!.isEmpty
                                        //     ? SizedBox()
                                        //     : Container(
                                        //         alignment: Alignment.center,
                                        //         margin: EdgeInsets.symmetric(vertical: 5),
                                        //         height: Get.height * 0.25,
                                        //         width: Get.width,
                                        //         decoration: BoxDecoration(
                                        //             image: DecorationImage(
                                        //           fit: BoxFit.fitWidth,
                                        //           image: NetworkImage(
                                        //               '$baseImageUrl${response.data![0].exerciseImage}'),
                                        //         )),
                                        //       ),
                                        Container(
                                          padding: EdgeInsets.only(top: 20),
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
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                finalHTMLString.length - 1,
                                            itemBuilder: (_, index) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          ColorUtils.kTint,
                                                      radius: Get.width * 0.04,
                                                      child: Text(
                                                          '${index + 1}',
                                                          style: FontTextStyle
                                                              .kBlack12BoldRoboto),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: htmlToText(
                                                          data: finalHTMLString[
                                                              index]))
                                                  // Text(
                                                  //     '${response.data![0].exerciseInstructions}',
                                                  //     maxLines: 4,
                                                  //     style: FontTextStyle.kWhite16W300Roboto)
                                                  // ),
                                                ],
                                              );
                                            }),
                                        SizedBox(height: Get.height * 0.03),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            );
                } else {
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
                      title: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite16BoldRoboto),
                      centerTitle: true,
                      actions: [
                        !widget.isFromExercise
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 18),
                                  child: InkWell(
                                    onTap: () async {
                                      if (controller.apiResponse.status ==
                                          Status.COMPLETE) {
                                        CheckWorkoutProgramRequestModel
                                            _request =
                                            CheckWorkoutProgramRequestModel();
                                        _request.workoutId = widget.workoutId;
                                        _request.userId =
                                            PreferenceManager.getUId();

                                        await _checkWorkoutProgramViewModel
                                            .checkWorkoutProgramViewModel(
                                                _request);

                                        if (_checkWorkoutProgramViewModel
                                                .apiResponse.status ==
                                            Status.COMPLETE) {
                                          CheckWorkoutProgramResponseModel
                                              checkResponse =
                                              _checkWorkoutProgramViewModel
                                                  .apiResponse.data;

                                          if (checkResponse.success == true) {
                                            if ('${response.data![0].exerciseVideo}'
                                                .contains('www.youtube.com')) {
                                              _youTubePlayerController?.pause();
                                            } else {
                                              _videoPlayerController?.pause();
                                              _chewieController?.pause();
                                            }
                                            Get.to(() => ProgramSetupPage(
                                                  exerciseId: response
                                                      .data![0].exerciseId,
                                                  day: widget.day,
                                                  workoutId: widget.workoutId,
                                                  workoutName:
                                                      widget.workoutName,
                                                ));
                                          } else if (checkResponse.success ==
                                              false) {
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
                                            style: FontTextStyle
                                                .kWhite16W300Roboto,
                                          );
                                        }
                                      }
                                    },
                                    child: Text('Start',
                                        style: FontTextStyle.kTine16W400Roboto),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    body: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(children: [
                        Container(
                          height: Get.height / 2.75,
                          width: Get.width,
                          child: Center(
                              child: _chewieController != null &&
                                      _chewieController!.videoPlayerController
                                          .value.isInitialized
                                  ? Chewie(
                                      controller: _chewieController!,
                                    )
                                  : /*response.data![0].exerciseImage == null
                                      ? noData()
                                      :*/
                                  CachedNetworkImage(
                                      imageUrl:
                                          response.data![0].exerciseImage!,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          noData(),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Shimmer.fromColors(
                                        baseColor:
                                            Colors.white.withOpacity(0.4),
                                        highlightColor:
                                            Colors.white.withOpacity(0.2),
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${response.data![0].exerciseTitle}'
                                                  .length >=
                                              25
                                          ? '${response.data![0].exerciseTitle!.substring(0, 25) + ' ..'}'
                                          : '${response.data![0].exerciseTitle}',
                                      style: FontTextStyle.kWhite17BoldRoboto),
                                  RichText(
                                    text: TextSpan(
                                        text: 'Suggested: ',
                                        style: FontTextStyle
                                            .kLightGray16W300Roboto
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                        children: [
                                          TextSpan(
                                            text:
                                                '${response.data![0].exerciseSets}x${response.data![0].exerciseReps} reps',
                                            style: FontTextStyle
                                                .kLightGray16W300Roboto,
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                              // response.data![0].exerciseImage!.isEmpty
                              //     ? SizedBox()
                              //     : Container(
                              //         alignment: Alignment.center,
                              //         margin: EdgeInsets.symmetric(vertical: 5),
                              //         height: Get.height * 0.25,
                              //         width: Get.width,
                              //         decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //           fit: BoxFit.fitWidth,
                              //           image: NetworkImage(
                              //               '$baseImageUrl${response.data![0].exerciseImage}'),
                              //         )),
                              //       ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
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
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: finalHTMLString.length - 1,
                                  itemBuilder: (_, index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: CircleAvatar(
                                            backgroundColor: ColorUtils.kTint,
                                            radius: Get.width * 0.04,
                                            child: Text('${index + 1}',
                                                style: FontTextStyle
                                                    .kBlack12BoldRoboto),
                                          ),
                                        ),
                                        Expanded(
                                            child: htmlToText(
                                                data: finalHTMLString[index]))
                                        // Text(
                                        //     '${response.data![0].exerciseInstructions}',
                                        //     maxLines: 4,
                                        //     style: FontTextStyle.kWhite16W300Roboto)
                                        // ),
                                      ],
                                    );
                                  }),
                              SizedBox(height: Get.height * 0.03),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  ),
                );
              }
            })
          : ConnectionCheckScreen();
    });
  }
}
