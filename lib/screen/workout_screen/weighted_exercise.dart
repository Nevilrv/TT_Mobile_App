import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/save_user_customized_exercise_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/save_user_customized_exercise_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/share_progress_screen.dart';
import 'package:tcm/screen/workout_screen/widget/workout_widgets.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_user_customized_exercise_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WeightExerciseScreen extends StatefulWidget {
  List<ExerciseById> data;

  WeightExerciseScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<WeightExerciseScreen> createState() => _WeightExerciseScreenState();
}

class _WeightExerciseScreenState extends State<WeightExerciseScreen> {
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;
  ChewieController? _chewieController;
  SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
      Get.put(SaveUserCustomizedExerciseViewModel());

  @override
  void initState() {
    super.initState();
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

  int counterReps = 0;

  counterPlus() {
    setState(() {
      counterReps++;
    });
  }

  counterMinus() {
    setState(() {
      if (counterReps > 0) counterReps--;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      bool loader = false;

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
                    Text(
                      '${widget.data[0].exerciseTitle}',
                      style: FontTextStyle.kWhite24BoldRoboto,
                    ),
                    SizedBox(height: Get.height * .005),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.data[0].exerciseSets} sets of ${widget.data[0].exerciseReps} reps',
                          style: FontTextStyle.kLightGray16W300Roboto,
                        ),
                        Text(
                          '${widget.data[0].exerciseRest} second rest',
                          style: FontTextStyle.kLightGray16W300Roboto,
                        ),
                      ],
                    ),
                    Column(children: [
                      // WeightedCounter(
                      //   counter: int.parse('${widget.data[0].exerciseReps}'),
                      //   repsNo: '${widget.data[0].exerciseReps}',
                      // ),
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
                                    counterMinus();
                                    log('minus ${counterReps}');
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
                                        text: '${counterReps} ',
                                        style: counterReps == 0
                                            ? FontTextStyle.kWhite24BoldRoboto
                                                .copyWith(
                                                    color: ColorUtils.kGray)
                                            : FontTextStyle.kWhite24BoldRoboto,
                                        children: [
                                      TextSpan(
                                          text: 'reps',
                                          style:
                                              FontTextStyle.kWhite17W400Roboto)
                                    ])),
                                SizedBox(width: Get.width * .08),
                                InkWell(
                                  onTap: () {
                                    counterPlus();
                                    log('plus ${counterReps}');
                                  },
                                  child: CircleAvatar(
                                    radius: Get.height * .03,
                                    backgroundColor: ColorUtils.kTint,
                                    child: Icon(Icons.add,
                                        color: ColorUtils.kBlack),
                                  ),
                                ),
                                VerticalDivider(
                                  width: Get.width * .08,
                                  thickness: 1.25,
                                  color: ColorUtils.kGray,
                                  indent: Get.height * .015,
                                  endIndent: Get.height * .015,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: TextField(
                                            style: counterReps == 0
                                                ? FontTextStyle
                                                    .kWhite24BoldRoboto
                                                    .copyWith(
                                                        color: ColorUtils.kGray)
                                                : FontTextStyle
                                                    .kWhite24BoldRoboto,
                                            keyboardType: TextInputType.number,
                                            maxLength: 3,
                                            cursorColor: ColorUtils.kTint,
                                            decoration: InputDecoration(
                                                hintText: '0',
                                                counterText: '',
                                                semanticCounterText: '',
                                                hintStyle: FontTextStyle
                                                    .kWhite24BoldRoboto
                                                    .copyWith(
                                                        color: ColorUtils
                                                            .kGray),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent))),
                                          ),
                                        ),
                                        Text('lbs',
                                            style: FontTextStyle
                                                .kWhite17W400Roboto),
                                      ],
                                    ),
                                    SizedBox(),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Container(
                          margin:
                              EdgeInsets.symmetric(vertical: Get.height * .007),
                          alignment: Alignment.center,
                          width: Get.width,
                          height: Get.height * .035,
                          decoration: BoxDecoration(
                              color: ColorUtils.kSaperatedGray,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            '${widget.data[0].exerciseRest} second rest',
                            style: FontTextStyle.kWhite17W400Roboto,
                          ))
                    ]),
                    // SizedBox(
                    //   child: ListView.separated(
                    //       physics: NeverScrollableScrollPhysics(),
                    //       shrinkWrap: true,
                    //       itemCount: int.parse(
                    //           widget.data[0].exerciseSets!.toString()),
                    //       separatorBuilder: (_, index) {
                    //         return ;
                    //       },
                    //       itemBuilder: (_, index) {
                    //         return ;
                    //       }),
                    // ),
                    SizedBox(height: Get.height * .02),
                    GetBuilder<SaveUserCustomizedExerciseViewModel>(
                      builder: (controllerSave) {
                        return loader == true
                            ? Center(
                                child: CircularProgressIndicator(
                                color: ColorUtils.kTint,
                              ))
                            : commonNavigationButton(
                                onTap: () async {
                                  print('Save Exercise pressed!!!');

                                  setState(() {
                                    loader = true;
                                  });

                                  print('loader ----------- $loader');

                                  print(
                                      'counter out ----------------- ${counterReps}');
                                  if (counterReps <= 0) {
                                    Get.showSnackbar(GetSnackBar(
                                      message: 'Please set reps more than 0',
                                      duration: Duration(seconds: 2),
                                    ));
                                  }

                                  if (counterReps != 0 && counterReps > 0) {
                                    print(
                                        'counter ----------------- $counterReps');
                                    SaveUserCustomizedExerciseRequestModel
                                        _request =
                                        SaveUserCustomizedExerciseRequestModel();
                                    _request.userId =
                                        PreferenceManager.getUId();
                                    _request.exerciseId =
                                        widget.data[0].exerciseId;
                                    _request.reps = '$counterReps';
                                    _request.isCompleted = '1';

                                    await controllerSave
                                        .saveUserCustomizedExerciseViewModel(
                                            _request);

                                    if (controllerSave.apiResponse.status ==
                                        Status.COMPLETE) {
                                      SaveUserCustomizedExerciseResponseModel
                                          responseSave =
                                          controllerSave.apiResponse.data;

                                      setState(() {
                                        loader = false;
                                      });
                                      if (responseSave.success == true &&
                                          responseSave.data != null) {
                                        if ('${widget.data[0].exerciseVideo}'
                                            .contains('www.youtube.com')) {
                                          _youTubePlayerController?.pause();
                                        } else {
                                          _videoPlayerController?.pause();
                                          _chewieController?.pause();
                                        }

                                        Get.back();
                                        setState(() {
                                          counterReps = 0;
                                        });
                                        Get.showSnackbar(GetSnackBar(
                                          message: '${responseSave.msg}',
                                          duration: Duration(seconds: 2),
                                        ));
                                      } else if (responseSave.msg == null ||
                                          responseSave.msg == "" &&
                                              responseSave.data == null ||
                                          responseSave.data == "") {
                                        setState(() {
                                          loader = false;
                                        });
                                        Get.showSnackbar(GetSnackBar(
                                          message: '${responseSave.msg}',
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    } else if (controllerSave
                                            .apiResponse.status ==
                                        Status.ERROR) {
                                      setState(() {
                                        loader = false;
                                      });
                                      Get.showSnackbar(GetSnackBar(
                                        message:
                                            'Something went wrong !!! please try again !!!',
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                  }
                                },
                                name: 'Save Exercise');
                      },
                    ),
                    SizedBox(height: Get.height * .04)
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
