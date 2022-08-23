import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/no_weight_exercise_screen.dart';
import 'package:tcm/screen/workout_screen/share_progress_screen.dart';
import 'package:tcm/screen/workout_screen/time_based_exercise_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/workout_base_exercise_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class WorkoutHomeScreen extends StatefulWidget {
  List<ExerciseById> exeData;
  List<WorkoutById> data;
  final String? workoutId;

  WorkoutHomeScreen(
      {Key? key, required this.data, this.workoutId, required this.exeData})
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

  @override
  void initState() {
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
    log("called 123");

    await _userWorkoutsDateViewModel.getUserWorkoutsDateDetails(
        userId: PreferenceManager.getUId(),
        date: DateTime.now().toString().split(" ").first);

    if (_userWorkoutsDateViewModel.apiResponse.status == Status.COMPLETE) {
      print("complete api call");
      UserWorkoutsDateResponseModel resp =
          _userWorkoutsDateViewModel.apiResponse.data;

      log("--------------- dates ${resp.msg}");

      _userWorkoutsDateViewModel.exerciseId = resp.data!.exercisesIds!;

      print("list of ids ====== ${_userWorkoutsDateViewModel.exerciseId}");
      // log("list of ids ====== ${_userWorkoutsDateViewModel.exerciseId}");

      await _exerciseByIdViewModel.getExerciseByIdDetails(
          id: _userWorkoutsDateViewModel
              .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
    }
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
    print("list of ids ====== ${_userWorkoutsDateViewModel.exerciseId}");
    print('is data comming ????? ${widget.data[0].workoutTitle}');

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

      return GetBuilder<ExerciseByIdViewModel>(builder: (controller) {
        if (_exerciseByIdViewModel.apiResponse.status == Status.COMPLETE) {
          ExerciseByIdResponseModel responseExe =
              _exerciseByIdViewModel.apiResponse.data;

          print("exe date --------- ${responseExe.data![0].exerciseType}");

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              print("hello ${details.localPosition}");
              print("hello ${details.localPosition.dx}");
              print("hello ${details.globalPosition.distance}");

              if (details.localPosition.dx < 50.0) {
                //SWIPE FROM RIGHT DETECTION
                print("hello ");
                Get.offAll(HomeScreen());
              }
            },
            child: WillPopScope(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Text(
                              '${widget.data[0].workoutTitle}',
                              textAlign: TextAlign.center,
                              style: FontTextStyle.kWhite20BoldRoboto.copyWith(
                                  fontSize: Get.height * 0.022,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: Get.height * .02),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: finalHTMLInstruction.length - 1,
                              itemBuilder: (_, index) => htmlToTextGrey(
                                  data: finalHTMLInstruction[index])),
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
                                  child: '${widget.data[0].workoutVideo}'
                                          .contains('www.youtube.com')
                                      ? Center(
                                          child: _youTubePlayerController ==
                                                  null
                                              ? CircularProgressIndicator(
                                                  color: ColorUtils.kTint)
                                              : YoutubePlayer(
                                                  controller:
                                                      _youTubePlayerController!,
                                                  showVideoProgressIndicator:
                                                      true,
                                                  bufferIndicator:
                                                      CircularProgressIndicator(
                                                          color:
                                                              ColorUtils.kTint),
                                                  controlsTimeOut:
                                                      Duration(hours: 2),
                                                  aspectRatio: 16 / 9,
                                                  progressColors:
                                                      ProgressBarColors(
                                                          handleColor: ColorUtils
                                                              .kRed,
                                                          playedColor: ColorUtils
                                                              .kRed,
                                                          backgroundColor:
                                                              ColorUtils.kGray,
                                                          bufferedColor:
                                                              ColorUtils
                                                                  .kLightGray),
                                                ),
                                        )
                                      : Center(
                                          child: _chewieController != null &&
                                                  _chewieController!
                                                      .videoPlayerController
                                                      .value
                                                      .isInitialized
                                              ? Chewie(
                                                  controller:
                                                      _chewieController!,
                                                )
                                              : widget.data[0].workoutImage ==
                                                      null
                                                  ? noDataLottie()
                                                  : Image.network(
                                                      widget.data[0]
                                                          .workoutImage!,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return noDataLottie();
                                                      },
                                                    )),
                                )
                              : SizedBox(),

                          SizedBox(height: Get.height * .03),
                          Container(
                            // height: Get.height * .4,
                            width: Get.width * .9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    colors: ColorUtilsGradient.kGrayGradient,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // color: Colors.pink,
                                  width: Get.width * .525,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: Get.height * .05),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: Get.height * .02,
                                                backgroundColor:
                                                    ColorUtils.kWhite,
                                                child: Center(
                                                  child: Image.asset(
                                                    AppIcons.kettle_bell,
                                                    height: Get.height * 0.025,
                                                    width: Get.width * 0.1,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: Get.width * .03),
                                              Expanded(
                                                child: Text('Equipment needed',
                                                    style: FontTextStyle
                                                        .kWhite20BoldRoboto),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: Get.height * .05),
                                        Container(
                                          // color: Colors.teal,
                                          width: Get.width * .4,
                                          alignment: Alignment.centerLeft,
                                          child: ListView.separated(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: widget.data[0]
                                                  .availableEquipments!.length,
                                              separatorBuilder: (_, index) {
                                                return SizedBox(
                                                    height: Get.height * .008);
                                              },
                                              itemBuilder: (_, index) {
                                                if ('${widget.data[0].availableEquipments![index]}' !=
                                                    "No Equipment") {
                                                  return Row(
                                                    children: [
                                                      SizedBox(
                                                          width:
                                                              Get.width * .075),
                                                      Icon(
                                                        Icons.circle,
                                                        color: ColorUtils
                                                            .kLightGray,
                                                        size:
                                                            Get.height * 0.0135,
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: '',
                                                              style: FontTextStyle
                                                                  .kLightGray16W300Roboto,
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    ' ${widget.data[0].availableEquipments![index]}',
                                                                style: FontTextStyle
                                                                    .kWhite17BoldRoboto)
                                                          ])),
                                                    ],
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              }),
                                        ),
                                        SizedBox(height: Get.height * .05),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: Get.height * .02,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    AppIcons.clock,
                                                    color: ColorUtils.kWhite,
                                                    fit: BoxFit.fill,
                                                    height: Get.height,
                                                    width: Get.width,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: Get.width * .03),
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
                                        SizedBox(height: Get.height * .05),
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
                          commonNavigationButton(
                              name: 'Begin Warm-Up',
                              onTap: () {
                                Get.to(NoWeightExerciseScreen(
                                  data: widget.data,
                                  workoutId: widget.workoutId,
                                ));

                                if (_userWorkoutsDateViewModel.exeIdCounter ==
                                    _userWorkoutsDateViewModel
                                        .exerciseId.length) {
                                  Get.to(ShareProgressScreen(
                                    exeData: responseExe.data!,
                                    data: widget.data,
                                    workoutId: widget.workoutId,
                                  ));
                                }

                                setState(() {
                                  watchVideo = false;
                                });
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
            ),
          );
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
