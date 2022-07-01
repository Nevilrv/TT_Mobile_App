import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/training_plan_screens/program_setup_page.dart';
import 'package:tcm/screen/training_plan_screens/workout_overview_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import 'package:video_player/video_player.dart';
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

  @override
  void initState() {
    super.initState();
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
    return GetBuilder<WorkoutByIdViewModel>(
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
          WorkoutByIdResponseModel response = controller.apiResponse.data;
          data.clear();

          response.data![0].daysAllData!.forEach((element) {
            element.days.forEach((v) {
              data.add(v);
            });
          });

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
                      onTap: () {
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
                          workoutDay: '${response.data![0].workoutDuration}',
                          workoutName: '${response.data![0].workoutTitle}',
                        ));
                      },
                      child:
                          Text('Start', style: FontTextStyle.kTine16W400Roboto),
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
                                ? CircularProgressIndicator(
                                    color: ColorUtils.kTint)
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
                                    _chewieController!.videoPlayerController
                                        .value.isInitialized
                                ? Chewie(
                                    controller: _chewieController!,
                                  )
                                : noDataLottie(),
                          ),
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
                                  Text(
                                      '${response.data![0].workoutDuration} WEEKS',
                                      style: FontTextStyle.kWhite16BoldRoboto),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(AppIcons.clock,
                                      height: 15, width: 15),
                                  SizedBox(width: 5),
                                  response.data![0].daysAllData!.isEmpty
                                      ? Text('0 x PER WEEK',
                                          style:
                                              FontTextStyle.kWhite16BoldRoboto)
                                      : Text(
                                          '${response.data![0].daysAllData![0].days!.length} x PER WEEK',
                                          style:
                                              FontTextStyle.kWhite16BoldRoboto),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(AppIcons.medal,
                                      height: 15, width: 15),
                                  SizedBox(width: 5),
                                  Text('${response.data![0].levelTitle}',
                                      style: FontTextStyle.kWhite16BoldRoboto),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height * .02),
                        htmlToText(
                            data: '${response.data![0].workoutDescription}'),
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
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.height * .012),
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
                                          workoutId:
                                              '${response.data![0].workoutId}',
                                          workoutDay:
                                              '${response.data![0].workoutDuration}',
                                          workoutName:
                                              '${response.data![0].workoutTitle}',
                                        ));
                                      },
                                      child: exerciseDayButton(
                                        day: '${data[index].dayName}',
                                        exercise: '${data[index].day}',
                                      ),
                                    );
                                  },
                                ),
                              )
                            : noDataLottie(),

                        SizedBox(height: Get.height * .025),
                        InkWell(
                          onTap: () {
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
                              workoutDay:
                                  '${response.data![0].workoutDuration}',
                              workoutName: '${response.data![0].workoutTitle}',
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 15, top: 5, right: 12, left: 12),
                            alignment: Alignment.center,
                            height: Get.height * .06,
                            width: Get.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: ColorUtilsGradient.kTintGradient,
                                    begin: Alignment.topCenter,
                                    end: Alignment.topCenter),
                                borderRadius:
                                    BorderRadius.circular(Get.height * .1)),
                            child: Text('Start Program',
                                style: FontTextStyle.kBlack20BoldRoboto),
                          ),
                        ),
                        SizedBox(height: Get.height * .03),
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
    );
  }

  Row exerciseDayButton({String? day, String? exercise}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                text: '$day - ',
                style: FontTextStyle.kWhite17BoldRoboto,
                children: [
              TextSpan(text: exercise, style: FontTextStyle.kWhite17W400Roboto)
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
