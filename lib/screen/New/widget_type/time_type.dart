import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:tcm/screen/training_plan_screens/exercise_detail_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:get/get.dart';

import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';

class TimeType extends StatefulWidget {
  // final ExerciseByIdViewModel? controller;
  // bool isHold;
  // bool isFirst;
  // bool isGreaterOne;
  // List<WorkoutById> data;
  // final String? workoutId;

  final String title;
  final String exerciseId;
  final String exerciseTime;
  final String exerciseSets;

  TimeType({
    Key? key,
    required this.title,
    required this.exerciseId,
    required this.exerciseTime,
    required this.exerciseSets,
    // this.controller,
    // this.isFirst = false,
    // this.isGreaterOne = false,
    // this.isHold = false,
    // this.workoutId,
    // required this.data
  }) : super(key: key);

  @override
  _TimeTypeState createState() => _TimeTypeState();
}

class _TimeTypeState extends State<TimeType>
    with SingleTickerProviderStateMixin {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  // SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
  //     Get.put(SaveUserCustomizedExerciseViewModel());
  int totalRound = 0;

  timeDuration() {
    String time =
        '${_exerciseByIdViewModel.responseExe!.data![0].exerciseTime}';
    List<String> splittedTime = time.split(' ');
    log('------------- ${splittedTime.first}');
    int? timer;
    if (splittedTime.first.length == 1) {
      timer = int.parse(splittedTime.first) * 60;
      // log(' ----------  timer $timer');
      return timer;
    } else if (splittedTime.first.length >= 2) {
      timer = int.parse(splittedTime.first);
      // log('timer -==-=-=-=-=-= $timer');
      return timer;
    }
  }

  @override
  void dispose() {
    super.dispose();
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
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: Container(
        height: Get.height,
        child: Column(children: [
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
                      '${widget.title}',
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
                      Get.to(() => ExerciseDetailPage(
                          exerciseId: widget.exerciseId, isFromExercise: true));
                    },
                    child: Image.asset(
                      AppIcons.info,
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
            '${widget.exerciseTime} seconds each set',
            style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                fontSize: Get.height * 0.023,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          totalRound == 0
              ? Text(
                  'Sets ${widget.exerciseSets} ',
                  style: FontTextStyle.kLightGray16W300Roboto,
                )
              : Text(
                  'Sets $totalRound/${widget.exerciseSets} ',
                  style: FontTextStyle.kLightGray16W300Roboto,
                ),
          Center(
              child: Container(
            height: Get.height * .23,
            width: Get.height * .23,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: SimpleTimer(
              duration: Duration(seconds: int.parse("${widget.exerciseTime}")),
              controller: _timerController,
              timerStyle: _timerStyle,
              progressTextFormatter: (format) {
                return formattedTime(timeInSecond: format.inSeconds);
              },
              backgroundColor: ColorUtils.kGray,
              progressIndicatorColor: ColorUtils.kTint,
              progressIndicatorDirection: _progressIndicatorDirection,
              progressTextCountDirection: _progressTextCountDirection,
              progressTextStyle: FontTextStyle.kWhite24BoldRoboto
                  .copyWith(fontSize: Get.height * 0.03),
              strokeWidth: 17,
              onStart: () {},
              onEnd: () {
                if (totalRound != int.parse(widget.exerciseSets.toString())) {
                  setState(() {
                    totalRound = totalRound + 1;
                  });
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
                  // log('Start Pressed');
                  if (totalRound != int.parse(widget.exerciseSets.toString())) {
                    _timerController!.start();

                    // log('controller.totalRound-------> $totalRound');
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
                  // log('Reset pressed ');
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
                      border: Border.all(color: ColorUtils.kTint, width: 1.5)),
                  child: Text(
                    'Reset',
                    style: FontTextStyle.kTine17BoldRoboto,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
    // }
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }
}
