import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/screen/New/new_no_weight_exercises_screen.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../viewModel/conecction_check_viewModel.dart';

// ignore: must_be_immutable
class WorkoutHomeNew extends StatefulWidget {
  final String workoutId;
  final String exerciseId;
  final List warmUpList;
  final List exercisesList;
  final List withoutWarmUpExercisesList;
  final List superSetList;

  WorkoutHomeNew({
    Key? key,
    required this.workoutId,
    required this.exerciseId,
    required this.exercisesList,
    required this.superSetList,
    required this.withoutWarmUpExercisesList,
    required this.warmUpList,
  }) : super(key: key);

  @override
  State<WorkoutHomeNew> createState() => _WorkoutHomeNewState();
}

class _WorkoutHomeNewState extends State<WorkoutHomeNew> {
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());

  VideoPlayerController? _videoPlayerController;

  ChewieController? _chewieController;

  @override
  void initState() {
    print('WIDGET EXERCISES LIST; ${widget.exercisesList}');
    // print('initstare   >> ${_userWorkoutsDateViewModel.exercisesNewList}');
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
    Future.delayed(Duration.zero, () {
      apiCall();
    });
  }

  apiCall() async {
    await _exerciseByIdViewModel.getExerciseByIdDetails(id: widget.exerciseId);

    ExerciseByIdResponseModel exerciseByIdData =
        _exerciseByIdViewModel.apiResponse.data;

    _exerciseByIdViewModel.responseExe = exerciseByIdData;
    await _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.workoutId);
    WorkoutByIdResponseModel workoutByIdData =
        _workoutByIdViewModel.apiResponse.data;
    initializePlayer(workoutByIdData);
    // id: "78");
  }

  YoutubePlayerController? _youtubePlayerController;
  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubePlayerController!.dispose();
    super.dispose();
  }

  youtubeVideoID(WorkoutByIdResponseModel workoutByIdData) {
    String finalLink;
    print('workoutVideo >>>> ${workoutByIdData.data![0].workoutVideo}');
    String videoID = '${workoutByIdData.data![0].workoutVideo}';
    List<String> splittedLink = videoID.split('v=');
    List<String> longLink = splittedLink.last.split('&');
    finalLink = longLink.first;
    print('Link >>>>>  $finalLink');
    return finalLink;
  }

  Future initializePlayer(WorkoutByIdResponseModel workoutByIdData) async {
    youtubeVideoID(workoutByIdData);
    // if ('${widget.data[0].workoutVideo}'.contains('www.youtube.com')) {
    if ('${workoutByIdData.data![0].workoutVideo}'
        .contains('www.youtube.com')) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: youtubeVideoID(workoutByIdData),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: true,
          hideControls: false,
          loop: true,
        ),
      );
    } else {
      if (workoutByIdData.data![0].workoutVideo == null ||
          workoutByIdData.data![0].workoutVideo == '') {
      } else {
        _videoPlayerController = VideoPlayerController.network(
            '${workoutByIdData.data![0].workoutVideo}');

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
    print(
        'withoutWarmUpExercisesList********    ${widget.withoutWarmUpExercisesList}');
    print('exercisesList********    ${widget.exercisesList}');
    print('warmUpList********    ${widget.warmUpList}');
    print('build called');
    return GetBuilder<ConnectivityCheckViewModel>(
      builder: (control) => control.isOnline
          ? GetBuilder<WorkoutByIdViewModel>(
              builder: (workoutController) {
                if (workoutController.apiResponse.status == Status.COMPLETE) {
                  WorkoutByIdResponseModel workoutByIdData =
                      workoutController.apiResponse.data;
                  return GetBuilder<ExerciseByIdViewModel>(
                      builder: (exerciseByIdController) {
                    if (exerciseByIdController.apiResponse.status ==
                        Status.COMPLETE) {
                      ExerciseByIdResponseModel exerciseByIdData =
                          exerciseByIdController.apiResponse.data;
                      print(
                          "exe date --------- ${exerciseByIdData.data![0].exerciseType}");
                      if (exerciseByIdData.data!.isNotEmpty) {
                        /* String exerciseInstructions =
                            '${workoutByIdData.data![0].workoutDescription}';
                        List<String> splitHTMLInstruction =
                            exerciseInstructions.split('</li>');
                        List<String> finalHTMLInstruction = [];
                        splitHTMLInstruction.forEach((element) {
                          finalHTMLInstruction.add(element
                              .replaceAll('<ol>', '')
                              .replaceAll('</ol>', ''));
                        });

                        String exerciseTips =
                            '${exerciseByIdData.data![0]..exerciseTips}';
                        List<String> splitHTMLTips =
                            exerciseTips.split('</li>');
                        List<String> finalHTMLTips = [];
                        splitHTMLTips.forEach((element) {
                          finalHTMLTips.add(element
                              .replaceAll('<ul>', '')
                              .replaceAll('</ul>', ''));
                          print(
                              'finalHTMLInstruction >>>>>  ${finalHTMLInstruction}');
                          print('finalHTMLTips >>>>>  ${finalHTMLTips}');
                        });*/
                        try {
                          return '${workoutByIdData.data![0].workoutVideo}'
                                  .contains('www.youtube.com')
                              ? YoutubePlayerBuilder(
                                  player: YoutubePlayer(
                                    controller: _youtubePlayerController!,
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
                                              Get.offAll(HomeScreen());
                                            },
                                            icon: Icon(
                                              Icons.arrow_back_ios_sharp,
                                              color: ColorUtils.kTint,
                                            )),
                                        backgroundColor: ColorUtils.kBlack,
                                        title: Text('Workout Overview',
                                            style: FontTextStyle
                                                .kWhite16BoldRoboto),
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
                                                    '${workoutByIdData.data![0].workoutTitle}',
                                                    textAlign: TextAlign.center,
                                                    style: FontTextStyle
                                                        .kWhite20BoldRoboto
                                                        .copyWith(
                                                            fontSize:
                                                                Get.height *
                                                                    0.022,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: Get.height * .02),
                                                /* ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        finalHTMLInstruction
                                                                .length -
                                                            1,
                                                    itemBuilder: (_, index) =>
                                                        htmlToTextGrey(
                                                            data:
                                                                finalHTMLInstruction[
                                                                    index])),*/
                                                SizedBox(
                                                    height: Get.height * .03),
                                                !watchVideo
                                                    ? commonNavigationButtonWithIcon(
                                                        onTap: () {
                                                          setState(() {
                                                            watchVideo = true;
                                                          });
                                                        },
                                                        name:
                                                            'Watch Overview Video',
                                                        iconImg: AppIcons.video,
                                                        iconColor:
                                                            ColorUtils.kBlack)
                                                    : SizedBox(),
                                                watchVideo
                                                    ? AnimatedContainer(
                                                        height:
                                                            Get.height / 3.5,
                                                        width: Get.width,
                                                        duration: Duration(
                                                            seconds: 2),
                                                        child: Center(
                                                          child: _youtubePlayerController ==
                                                                  null
                                                              ? CircularProgressIndicator(
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint)
                                                              : player,
                                                        ))
                                                    : SizedBox(),

                                                SizedBox(
                                                    height: Get.height * .03),
                                                Container(
                                                  // height: Get.height * .4,
                                                  width: Get.width * .9,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      gradient: LinearGradient(
                                                          colors:
                                                              ColorUtilsGradient
                                                                  .kGrayGradient,
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                                  height:
                                                                      Get.height *
                                                                          .05),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
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
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          AppIcons
                                                                              .kettle_bell,
                                                                          height:
                                                                              Get.height * 0.025,
                                                                          width:
                                                                              Get.width * 0.1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: Get.width *
                                                                            .03),
                                                                    Expanded(
                                                                      child: Text(
                                                                          'Equipment needed',
                                                                          style:
                                                                              FontTextStyle.kWhite20BoldRoboto),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          .05),
                                                              Container(
                                                                // color: Colors.teal,
                                                                width:
                                                                    Get.width *
                                                                        .4,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: ListView
                                                                    .separated(
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: workoutByIdData
                                                                            .data![
                                                                                0]
                                                                            .availableEquipments!
                                                                            .length,
                                                                        separatorBuilder: (_,
                                                                            index) {
                                                                          return SizedBox(
                                                                              height: Get.height * .008);
                                                                        },
                                                                        itemBuilder:
                                                                            (_, index) {
                                                                          if ('${workoutByIdData.data![0].availableEquipments![index]}' !=
                                                                              "No Equipment") {
                                                                            return Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(width: Get.width * .075),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 3),
                                                                                  child: Icon(
                                                                                    Icons.circle,
                                                                                    color: ColorUtils.kLightGray,
                                                                                    size: Get.height * 0.0135,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: Get.width * .025),
                                                                                Flexible(
                                                                                  child: Text(' ${workoutByIdData.data![0].availableEquipments![index]}', style: FontTextStyle.kWhite17BoldRoboto),
                                                                                )
                                                                              ],
                                                                            );
                                                                          } else {
                                                                            return SizedBox();
                                                                          }
                                                                        }),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          .05),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
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
                                                                      child:
                                                                          ClipOval(
                                                                        child: Image
                                                                            .asset(
                                                                          AppIcons
                                                                              .clock,
                                                                          color:
                                                                              ColorUtils.kWhite,
                                                                          fit: BoxFit
                                                                              .fill,
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
                                                                      child:
                                                                          Text(
                                                                        '${exerciseByIdData.data![0].exerciseRest} rest between sets',
                                                                        style: FontTextStyle
                                                                            .kWhite20BoldRoboto,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          .05),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: Get.height * .03),
                                                // ListView.builder(
                                                //     physics: NeverScrollableScrollPhysics(),
                                                //     shrinkWrap: true,
                                                //     itemCount: finalHTMLTips.length - 1,
                                                //     itemBuilder: (_, index) =>
                                                //         ),
                                                // htmlToTextGrey(data: finalHTMLTips[1]),
                                                SizedBox(
                                                    height: Get.height * .03),
                                                widget.warmUpList.isNotEmpty
                                                    ? commonNavigationButton(
                                                        name: "Begin Warm-Up",
                                                        onTap: () {
                                                          try {
                                                            _youtubePlayerController!
                                                                .pause();
                                                          } catch (e) {}
                                                          setState(() {
                                                            watchVideo = false;
                                                          });
                                                          Get.to(
                                                              () => NewNoWeightExercise(
                                                                  userProgramDatesId:
                                                                      _userWorkoutsDateViewModel
                                                                          .userProgramDatesId,
                                                                  superSetRound: _userWorkoutsDateViewModel
                                                                              .superSetsRound ==
                                                                          ""
                                                                      ? 1
                                                                      : int.parse(
                                                                          _userWorkoutsDateViewModel
                                                                              .superSetsRound),
                                                                  exerciseList:
                                                                      widget
                                                                          .exercisesList,
                                                                  superSetList:
                                                                      widget
                                                                          .superSetList),
                                                              transition: Transition
                                                                  .rightToLeft);
                                                        })
                                                    : SizedBox(),
                                                SizedBox(
                                                    height: Get.height * .03),
                                                widget.exercisesList.isNotEmpty
                                                    ? commonNavigationButton(
                                                        name: "Start Workout",
                                                        onTap: () {
                                                          try {
                                                            _youtubePlayerController!
                                                                .pause();
                                                          } catch (e) {}
                                                          setState(() {
                                                            watchVideo = false;
                                                          });
                                                          Get.to(
                                                              () => NewNoWeightExercise(
                                                                  userProgramDatesId:
                                                                      _userWorkoutsDateViewModel
                                                                          .userProgramDatesId,
                                                                  superSetRound: _userWorkoutsDateViewModel
                                                                              .superSetsRound ==
                                                                          ""
                                                                      ? 1
                                                                      : int.parse(
                                                                          _userWorkoutsDateViewModel
                                                                              .superSetsRound),
                                                                  superSetList:
                                                                      widget
                                                                          .superSetList,
                                                                  exerciseList:
                                                                      widget
                                                                          .withoutWarmUpExercisesList),
                                                              transition: Transition
                                                                  .rightToLeft);
                                                        })
                                                    : SizedBox()

                                                /*  GetBuilder<
                                                        UserWorkoutsDateViewModel>(
                                                    builder: (controller) {
                                                  // log('================ ?> ${controller.warmUpId.isNotEmpty}');

                                                  return controller
                                                          .userProgramDateID
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
                                                                      Get.to(
                                                                              () =>
                                                                              NoWeightExerciseScreen(
                                                                                data:
                                                                                workoutByIdData.data!,
                                                                                workoutId:
                                                                                workoutByIdData.data![0].workoutId,
                                                                              ),
                                                                          transition:
                                                                          Transition
                                                                              .rightToLeft);
                                                                      // log("hello warm up");
                                                                      // log("hello warm up id ${controller.warmUpId}");
                                                                      // log("hello exerciseId up Z${controller.exerciseId}");
                                                                      // if (controller
                                                                      //     .warmUpId
                                                                      //     .isNotEmpty) {
                                                                      //   for (int i =
                                                                      //           0;
                                                                      //       i < controller.warmUpId.length;
                                                                      //       i++) {
                                                                      //     /// warm up
                                                                      //     if (controller.exerciseId.contains(controller.warmUpId[i]) ==
                                                                      //         false) {
                                                                      //       /// warm up data add in mix exerciseId list(warm up & exercised both data)
                                                                      //       controller.exerciseId.insert(i,
                                                                      //           controller.warmUpId[i]);
                                                                      //     }
                                                                      //   }
                                                                      // }
                                                                      // print(
                                                                      //     'exerciseId>>>> ${controller.exerciseId}');
                                                                      // setState(
                                                                      //     () {
                                                                      //   watchVideo =
                                                                      //       false;
                                                                      // });
                                                                      // // log("hello exerciseId up Z for loop ${controller.exerciseId}");
                                                                      //
                                                                      // if (controller
                                                                      //         .exeIdCounter ==
                                                                      //     controller
                                                                      //         .exerciseId
                                                                      //         .length) {
                                                                      //   Get.to(
                                                                      //       () =>
                                                                      //           ShareProgressScreen(
                                                                      //             exeData: exerciseByIdData.data!,
                                                                      //             data: workoutByIdData.data!,
                                                                      //             workoutId: workoutByIdData.data![0].workoutId,
                                                                      //           ),
                                                                      //       transition:
                                                                      //           Transition.rightToLeft);
                                                                      // }
                                                                      // Get.to(
                                                                      //     () =>
                                                                      //         NoWeightExerciseScreen(
                                                                      //           data: workoutByIdData.data!,
                                                                      //           workoutId: workoutByIdData.data![0].workoutId,
                                                                      //
                                                                      //           // workoutId:
                                                                      //           // widget.workoutId,
                                                                      //         ),
                                                                      //     transition:
                                                                      //         Transition.rightToLeft);
                                                                      //
                                                                      // // log("warm up added ${controller.exerciseId}");
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
                                                            // commonNavigationButton(
                                                            //     name:
                                                            //         'Start Workout',
                                                            //     onTap: () {
                                                            //       for (int i =
                                                            //               0;
                                                            //           i <
                                                            //               controller
                                                            //                   .warmUpId
                                                            //                   .length;
                                                            //           i++) {
                                                            //         if (controller
                                                            //             .exerciseId
                                                            //             .contains(
                                                            //                 controller.warmUpId[i])) {
                                                            //           controller
                                                            //               .exerciseId
                                                            //               .removeAt(
                                                            //                   0);
                                                            //         }
                                                            //       }
                                                            //       setState(() {
                                                            //         watchVideo =
                                                            //             false;
                                                            //       });
                                                            //
                                                            //       // Get.to(SuperSetScreen());
                                                            //       // controller
                                                            //       //     .exerciseId
                                                            //       //     .clear();
                                                            //       //
                                                            //       // controller
                                                            //       //         .exerciseId =
                                                            //       //     controller
                                                            //       //         .tmpExerciseId;
                                                            //       // log("warm up added ${controller.exerciseId}");
                                                            //
                                                            //       if (controller
                                                            //               .exeIdCounter ==
                                                            //           controller
                                                            //               .exerciseId
                                                            //               .length) {
                                                            //         Get.to(
                                                            //             () =>
                                                            //                 ShareProgressScreen(
                                                            //                   exeData: exerciseByIdData.data!,
                                                            //                   data: workoutByIdData.data!,
                                                            //                   workoutId: workoutByIdData.data![0].workoutId,
                                                            //                 ),
                                                            //             transition:
                                                            //                 Transition.rightToLeft);
                                                            //       }
                                                            //       Get.to(
                                                            //           () =>
                                                            //               NoWeightExerciseScreen(
                                                            //                 data:
                                                            //                     workoutByIdData.data!,
                                                            //                 workoutId:
                                                            //                     workoutByIdData.data![0].workoutId,
                                                            //               ),
                                                            //           transition:
                                                            //               Transition
                                                            //                   .rightToLeft);
                                                            //     }),
                                                          ],
                                                        )
                                                      : SizedBox();
                                                }),*/
                                                ,
                                                SizedBox(
                                                    height: Get.height * .03),
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
                                          style:
                                              FontTextStyle.kWhite16BoldRoboto),
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
                                                  '${workoutByIdData.data![0].workoutTitle}',
                                                  textAlign: TextAlign.center,
                                                  style: FontTextStyle
                                                      .kWhite20BoldRoboto
                                                      .copyWith(
                                                          fontSize: Get.height *
                                                              0.022,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Get.height * .02),
                                              /*ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: finalHTMLInstruction
                                                          .length -
                                                      1,
                                                  itemBuilder: (_, index) =>
                                                      htmlToTextGrey(
                                                          data:
                                                              finalHTMLInstruction[
                                                                  index])),*/
                                              SizedBox(
                                                  height: Get.height * .03),
                                              !watchVideo
                                                  ? commonNavigationButtonWithIcon(
                                                      onTap: () {
                                                        setState(() {
                                                          watchVideo = true;
                                                        });
                                                      },
                                                      name:
                                                          'Watch Overview Video',
                                                      iconImg: AppIcons.video,
                                                      iconColor:
                                                          ColorUtils.kBlack)
                                                  : SizedBox(),
                                              watchVideo
                                                  ? AnimatedContainer(
                                                      height: Get.height / 3.5,
                                                      width: Get.width,
                                                      duration:
                                                          Duration(seconds: 2),
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
                                                              : workoutByIdData
                                                                          .data![
                                                                              0]
                                                                          .workoutImage ==
                                                                      null
                                                                  ? noData()
                                                                  : Image
                                                                      .network(
                                                                      workoutByIdData
                                                                          .data![
                                                                              0]
                                                                          .workoutImage!,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return noData();
                                                                      },
                                                                    )),
                                                    )
                                                  : SizedBox(),

                                              SizedBox(
                                                  height: Get.height * .03),
                                              Container(
                                                // height: Get.height * .4,
                                                width: Get.width * .9,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    gradient: LinearGradient(
                                                        colors:
                                                            ColorUtilsGradient
                                                                .kGrayGradient,
                                                        begin:
                                                            Alignment.topCenter,
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
                                                                height:
                                                                    Get.height *
                                                                        .05),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
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
                                                                    child:
                                                                        Center(
                                                                      child: Image
                                                                          .asset(
                                                                        AppIcons
                                                                            .kettle_bell,
                                                                        height: Get.height *
                                                                            0.025,
                                                                        width: Get.width *
                                                                            0.1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: Get
                                                                              .width *
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
                                                                    Get.height *
                                                                        .05),
                                                            Container(
                                                              // color: Colors.teal,
                                                              width: Get.width *
                                                                  .4,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: ListView
                                                                  .separated(
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: workoutByIdData
                                                                          .data![
                                                                              0]
                                                                          .availableEquipments!
                                                                          .length,
                                                                      separatorBuilder: (_,
                                                                          index) {
                                                                        return SizedBox(
                                                                            height:
                                                                                Get.height * .008);
                                                                      },
                                                                      itemBuilder:
                                                                          (_, index) {
                                                                        if ('${workoutByIdData.data![0].availableEquipments![index]}' !=
                                                                            "No Equipment") {
                                                                          return Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(width: Get.width * .075),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 3),
                                                                                child: Icon(
                                                                                  Icons.circle,
                                                                                  color: ColorUtils.kLightGray,
                                                                                  size: Get.height * 0.0135,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: Get.width * .025),
                                                                              Flexible(
                                                                                child: Text(
                                                                                  '${workoutByIdData.data![0].availableEquipments![index]}',
                                                                                  style: FontTextStyle.kWhite17BoldRoboto,
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
                                                                    Get.height *
                                                                        .05),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
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
                                                                    child:
                                                                        ClipOval(
                                                                      child: Image
                                                                          .asset(
                                                                        AppIcons
                                                                            .clock,
                                                                        color: ColorUtils
                                                                            .kWhite,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        height:
                                                                            Get.height,
                                                                        width: Get
                                                                            .width,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: Get
                                                                              .width *
                                                                          .03),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${exerciseByIdData.data![0].exerciseRest} rest between sets',
                                                                      style: FontTextStyle
                                                                          .kWhite20BoldRoboto,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        .05),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Get.height * .03),
                                              // ListView.builder(
                                              //     physics: NeverScrollableScrollPhysics(),
                                              //     shrinkWrap: true,
                                              //     itemCount: finalHTMLTips.length - 1,
                                              //     itemBuilder: (_, index) =>
                                              //         ),
                                              // htmlToTextGrey(data: finalHTMLTips[1]),

                                              SizedBox(
                                                  height: Get.height * .03),
                                              widget.warmUpList.isNotEmpty
                                                  ? commonNavigationButton(
                                                      name: "Begin Warm-Up",
                                                      onTap: () {
                                                        try {
                                                          _youtubePlayerController!
                                                              .pause();
                                                        } catch (e) {}
                                                        setState(() {
                                                          watchVideo = false;
                                                        });
                                                        Get.to(
                                                            () => NewNoWeightExercise(
                                                                userProgramDatesId:
                                                                    _userWorkoutsDateViewModel
                                                                        .userProgramDatesId,
                                                                superSetRound: _userWorkoutsDateViewModel
                                                                            .superSetsRound ==
                                                                        ""
                                                                    ? 1
                                                                    : int.parse(
                                                                        _userWorkoutsDateViewModel
                                                                            .superSetsRound),
                                                                exerciseList: widget
                                                                    .exercisesList,
                                                                superSetList: widget
                                                                    .superSetList),
                                                            transition: Transition
                                                                .rightToLeft);
                                                      })
                                                  : SizedBox(),
                                              SizedBox(
                                                  height: Get.height * .03),
                                              widget.exercisesList.isNotEmpty
                                                  ? commonNavigationButton(
                                                      name: "Start Workout",
                                                      onTap: () {
                                                        try {
                                                          _youtubePlayerController!
                                                              .pause();
                                                        } catch (e) {}
                                                        setState(() {
                                                          watchVideo = false;
                                                        });
                                                        print(
                                                            'ZHomew userProgramDatesId    ${_userWorkoutsDateViewModel.userProgramDatesId}');
                                                        Get.to(
                                                            () => NewNoWeightExercise(
                                                                userProgramDatesId:
                                                                    _userWorkoutsDateViewModel
                                                                        .userProgramDatesId,
                                                                superSetRound: _userWorkoutsDateViewModel
                                                                            .superSetsRound ==
                                                                        ""
                                                                    ? 1
                                                                    : int.parse(
                                                                        _userWorkoutsDateViewModel
                                                                            .superSetsRound),
                                                                superSetList: widget
                                                                    .superSetList,
                                                                exerciseList: widget
                                                                    .withoutWarmUpExercisesList),
                                                            transition: Transition
                                                                .rightToLeft);
                                                      })
                                                  : SizedBox()

                                              /* GetBuilder<
                                                      UserWorkoutsDateViewModel>(
                                                  builder: (controller) {
                                                // log("======================= ?>${controller.  warmUpId.isNotEmpty}");
                                                return controller
                                                        .userProgramDateID
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
                                                                    // log("hello warm up");
                                                                    // log("hello warm up id ${controller.warmUpId}");
                                                                    // log("hello exerciseId up Z${controller.exerciseId}");

                                                                    if (controller
                                                                        .warmUpId
                                                                        .isNotEmpty) {
                                                                      for (int i =
                                                                              0;
                                                                          i < controller.warmUpId.length;
                                                                          i++) {
                                                                        if (controller
                                                                                .exerciseId
                                                                                .contains(controller.warmUpId[i]) ==
                                                                            false) {
                                                                          controller
                                                                              .exerciseId
                                                                              .insert(i,
                                                                                  controller.warmUpId[i]);
                                                                        }
                                                                      }
                                                                    }
                                                                    // log("hello exerciseId up Z for loop ${controller.exerciseId}");

                                                                    Get.to(
                                                                        () =>
                                                                            NoWeightExerciseScreen(
                                                                              data:
                                                                                  workoutByIdData.data!,
                                                                              workoutId:
                                                                                  workoutByIdData.data![0].workoutId,
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
                                                                                exeData: exerciseByIdData.data!,
                                                                                data: workoutByIdData.data!,
                                                                                workoutId: workoutByIdData.data![0].workoutId,
                                                                              ),
                                                                          transition:
                                                                              Transition.rightToLeft);
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
                                                                  controller
                                                                          .warmUpId !=
                                                                      []
                                                              ? SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          .03)
                                                              : SizedBox(),
                                                          commonNavigationButton(
                                                              name:
                                                                  'Start Workout',
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
                                                                              .warmUpId[i])) {
                                                                    controller
                                                                        .exerciseId
                                                                        .removeAt(
                                                                            0);
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
                                                                          data: workoutByIdData
                                                                              .data!,
                                                                          workoutId: workoutByIdData
                                                                              .data![0]
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
                                                                                exerciseByIdData.data!,
                                                                            data:
                                                                                workoutByIdData.data!,
                                                                            workoutId: workoutByIdData
                                                                                .data![0]
                                                                                .workoutId,
                                                                          ),
                                                                      transition:
                                                                          Transition
                                                                              .rightToLeft);
                                                                }
                                                                setState(() {
                                                                  watchVideo =
                                                                      false;
                                                                });
                                                              }),
                                                        ],
                                                      )
                                                    : SizedBox();
                                              }),*/
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
                        } catch (e) {
                          // TODO
                          return Center(
                              child: CircularProgressIndicator(
                            color: ColorUtils.kTint,
                          ));
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorUtils.kTint,
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
                  });
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  ));
                }
              },
            )
          : ConnectionCheckScreen(),
    );
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
/*getExercisesId() async {
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
  }*/
