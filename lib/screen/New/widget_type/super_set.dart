import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/repo/training_plan_repo/exercise_by_id_repo.dart';
import 'package:tcm/screen/New/widget_type/weighted_type.dart';
import 'package:tcm/screen/training_plan_screens/exercise_detail_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/workout_base_exercise_viewModel.dart';

/// Super set type
class SuperSetExercise extends StatefulWidget {
  final List superSetExercisesList;
  final int roundCount;
  final List superSetIdList;
  final int superSetRound;

  const SuperSetExercise(
      {Key? key,
      required this.superSetExercisesList,
      required this.roundCount,
      required this.superSetRound,
      required this.superSetIdList})
      : super(key: key);

  @override
  State<SuperSetExercise> createState() => _SuperSetExerciseState();
}

class _SuperSetExerciseState extends State<SuperSetExercise>
    with SingleTickerProviderStateMixin {
  WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
      Get.put(WorkoutBaseExerciseViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  TextEditingController? _weightTextEditingController;
  // UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
  //     Get.put(UpdateStatusUserProgramViewModel());
  Map<String, dynamic> repsMap = {};

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    if (timeInSecond % 60 == 0) {
      return "${(timeInSecond / 60).toString().split(".").first} minute";
    } else if (timeInSecond >= 60) {
      return "$minute : $second minute";
    } else {
      return "$timeInSecond second";
    }
  }

  @override
  void initState() {
    print('initstate');
    _workoutBaseExerciseViewModel.staticTimer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build called');
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: GetBuilder<WorkoutBaseExerciseViewModel>(
          builder: (controller) {
            return SizedBox(
              width: Get.width,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height * .027),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Superset',
                        style: FontTextStyle.kWhite24BoldRoboto
                            .copyWith(fontSize: Get.height * .03),
                      ),
                      SizedBox(height: Get.height * .015),
                      Text(
                          '${_userWorkoutsDateViewModel.superSetsRound} rounds',
                          style: FontTextStyle.kLightGray18W300Roboto),
                      SizedBox(height: Get.height * .008),
                      Text(
                          '${_userWorkoutsDateViewModel.restTime} secs rest between rounds',
                          style: FontTextStyle.kLightGray18W300Roboto),
                    ],
                  ),
                ),

                /// Round
                Container(
                  height: Get.height * .055,
                  width: Get.width * .33,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      gradient: LinearGradient(
                          colors: ColorUtilsGradient.kGrayGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Round', style: FontTextStyle.kWhite18BoldRoboto),
                      SizedBox(width: Get.width * .02),
                      CircleAvatar(
                          radius: Get.height * .019,
                          backgroundColor: ColorUtils.kTint,
                          child: Text(
                            '${widget.roundCount}',
                            style: FontTextStyle.kBlack20BoldRoboto,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Get.height * .03,
                      left: Get.height * .025,
                      right: Get.height * .025),
                  child: SizedBox(
                    width: Get.width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.superSetExercisesList.length,
                        // itemCount: exeName.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return superSet(
                              index: index,
                              id: widget.superSetExercisesList[index],
                              controllerWorkoutBaseExercise:
                                  _workoutBaseExerciseViewModel,
                              textEditingController:
                                  TextEditingController(text: ''));
                        }),
                  ),
                ),
                SupersetStaticTimer(
                  index: 0,
                  width: Get.width,
                  height: Get.height * .055,
                  timerEndTime: _userWorkoutsDateViewModel.restTime != ""
                      ? _userWorkoutsDateViewModel.restTime
                      : "30",
                )
                /*TimerProgressBar(
                  // superSetScreen: false,
                  index: 0,
                  width: Get.width,
                  height: Get.height * .055,
                  timerEndTime: _userWorkoutsDateViewModel.restTime != ""
                      ? _userWorkoutsDateViewModel.restTime
                      : "30",
                )*/
              ]),
            );
          },
        ),
      ),
    );
  }

  superSet(
      {var id,
      required int index,
      required WorkoutBaseExerciseViewModel controllerWorkoutBaseExercise,
      required TextEditingController? textEditingController}) {
    return FutureBuilder<ExerciseByIdResponseModel>(
      future: ExerciseByIdRepo().exerciseByIdRepo(id: id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ExerciseByIdResponseModel response = snapshot.data!;
          repsMap.addAll({
            "${snapshot.data!.data![0].exerciseTitle}":
                snapshot.data!.data![0].exerciseReps
          });
          if (response.data![0].exerciseType == "REPS") {
            if (_workoutBaseExerciseViewModel.superSetApiCall == true) {
              _workoutBaseExerciseViewModel.superSetApiCall = false;
              controllerWorkoutBaseExercise.repsSuperSetList = [];
              controllerWorkoutBaseExercise.repsSuperSetList
                  .add(int.parse("${response.data![0].exerciseReps}"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ExerciseDetailPage(
                            exerciseId: id, isFromExercise: true));
                      },
                      child: Image.asset(
                        AppIcons.info,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    SizedBox(width: Get.width * .03),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppIcons.compareArrow,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  '${response.data![0].exerciseReps} reps',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),
                SizedBox(height: Get.height * .0075),
                SuperSetCounterCard(
                  // counter: int.parse(
                  //     "${response.data![0].exerciseReps}".split("-").first),
                  counter: _workoutBaseExerciseViewModel.repsSuperSetList[0],
                ),
                // CounterCard(
                //     superSetScreen: true,
                //     index: 0,
                //     counter: int.parse(
                //         "${response.data![0].exerciseReps}".split("-").first)),
                Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
              ],
            );
          } else if (response.data![0].exerciseType == "TIME") {
            _userWorkoutsDateViewModel.responseTime =
                int.parse("${response.data![0].exerciseTime}");

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ExerciseDetailPage(
                            exerciseId: id, isFromExercise: true));
                      },
                      child: Image.asset(
                        AppIcons.info,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    SizedBox(width: Get.width * .03),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppIcons.compareArrow,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  '${response.data![0].exerciseTime} seconds each side',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),
                SizedBox(height: Get.height * .0075),
                SuperSetTimerProgressBar(
                  index: index,
                  height: Get.height * .1,
                  timerEndTime: response.data![0].exerciseTime.toString(),
                  width: Get.width,
                ),
                Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
              ],
            );
          } else if (response.data![0].exerciseType == "WEIGHTED") {
            if (_workoutBaseExerciseViewModel.superSetApiCall == true) {
              _workoutBaseExerciseViewModel.superSetApiCall == false;
              controllerWorkoutBaseExercise.weightedRepsList.clear();
              controllerWorkoutBaseExercise.lbsList.clear();
              // print(
              //     'exerciseWeight >>>> ${snapshot.data!.data![0].exerciseWeight}');
              controllerWorkoutBaseExercise.weightedRepsList
                  .add(snapshot.data!.data![0].exerciseReps ?? "5");
              controllerWorkoutBaseExercise.lbsList
                  .add(snapshot.data!.data![0].exerciseWeight ?? "0");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ExerciseDetailPage(
                            exerciseId: id, isFromExercise: true));
                      },
                      child: Image.asset(
                        AppIcons.info,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    SizedBox(width: Get.width * .03),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppIcons.compareArrow,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  '${response.data![0].exerciseReps} reps',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),
                SizedBox(height: Get.height * .0075),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    WeightedCard(
                        editingController: textEditingController!,
                        weight:
                            '${snapshot.data!.data![0].exerciseWeight ?? "30"}',
                        counter: int.parse(
                            '${snapshot.data!.data![0].exerciseReps}'
                                .split("-")
                                .first),
                        index: 0,
                        controller: controllerWorkoutBaseExercise),
                    Positioned(
                      top: Get.height * .01,
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height * .027,
                        width: Get.height * .09,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: snapshot.data!.data![0].exerciseColor ==
                                        "green"
                                    ? ColorUtilsGradient.kGreenGradient
                                    : snapshot.data!.data![0].exerciseColor ==
                                            "yellow"
                                        ? ColorUtilsGradient.kOrangeGradient
                                        : ColorUtilsGradient.kRedGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomLeft: Radius.circular(6))),
                        child: Text('RIR 0-1',
                            style: FontTextStyle.kWhite12BoldRoboto
                                .copyWith(fontWeight: FontWeight.w500)),
                      ),
                    )
                  ],
                ),
                Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
              ],
            );
          } else {
            return SizedBox();
          }
        } else {
          return SizedBox(
            height: Get.height * .125,
            width: Get.height * .125,
            child: Center(
              child: CircularProgressIndicator(color: ColorUtils.kTint),
            ),
          );
        }
      },
    );
  }
}

/// super set timer
class SuperSetTimerProgressBar extends StatefulWidget {
  final double height;
  final double width;
  final int index;
  final String timerEndTime;
  const SuperSetTimerProgressBar({
    Key? key,
    required this.index,
    required this.timerEndTime,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  _SuperSetTimerProgressBarState createState() =>
      _SuperSetTimerProgressBarState();
}

class _SuperSetTimerProgressBarState extends State<SuperSetTimerProgressBar> {
  WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
      Get.put(WorkoutBaseExerciseViewModel());
  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    if (timeInSecond % 60 == 0) {
      return "${(timeInSecond / 60).toString().split(".").first} minute";
    } else if (timeInSecond >= 60) {
      return "$minute : $second minute";
    } else {
      return "$timeInSecond second";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutBaseExerciseViewModel>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: controller.showTimer == widget.index &&
                  controller.superSetCurrentValue == widget.index &&
                  controller.superSetCurrentValue != null
              ? Container(
                  height: widget.height,
                  width: widget.width,
                  // color: Colors.grey.shade50,
                  decoration: BoxDecoration(
                      // color: ColorUtils.kGray,
                      border: Border.all(color: Colors.black, width: 1.5),
                      gradient: LinearGradient(
                          colors: ColorUtilsGradient.kGrayGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(6)),
                  child: FAProgressBar(
                    animatedDuration: Duration(seconds: 1),
                    currentValue: controller.currentValue.toDouble(),
                    backgroundColor: ColorUtils.kGray,
                    progressColor: ColorUtils.kGreen,
                    maxValue: double.parse("${widget.timerEndTime}"),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (controller.timerStop == false) {
                      controller.timerStop = true;
                      controller.currentValue = 0;
                      controller.setStaticTimer(staticTimerValue: false);
                      controller.setIsClickForSuperSet(isValue: true);
                      if (controller.isClickForSuperSet) {
                        controller.setIsClickForSuperSet(isValue: false);

                        if (controller.showTimer == null) {
                        } else {
                          controller.resTimer!.cancel();
                        }
                        controller.setSuperSetCurrentValue(
                            valueForSuperSet: widget.index);
                        controller.showTimer = widget.index;
                        controller.startRestTimer(endTime: widget.timerEndTime);
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: Get.height * .1,
                    width: Get.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kGrayGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(6)),
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * .05,
                      width: Get.width * .65,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: ColorUtilsGradient.kTintGradient,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "Start ${formattedTime(timeInSecond: int.parse(widget.timerEndTime))} timer",
                        style: FontTextStyle.kBlack18w600Roboto,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

/// super set card
class SuperSetCounterCard extends StatefulWidget {
  final int counter;
  const SuperSetCounterCard({Key? key, required this.counter})
      : super(key: key);

  @override
  _SuperSetCounterCardState createState() => _SuperSetCounterCardState();
}

class _SuperSetCounterCardState extends State<SuperSetCounterCard> {
  WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
      Get.put(WorkoutBaseExerciseViewModel());
  int counters = 0;

  @override
  void initState() {
    counters = widget.counter;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Container(
        height: Get.height * .1,
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: ColorUtils.kBlack, width: 2),
            gradient: LinearGradient(
                colors: ColorUtilsGradient.kGrayGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              // controller.repsSuperSetList[0]++;
              // print('controller.repsList[index] ');
              //  controller.updateRepsSuperSetList(
              //         index: widget.index, isPlus: false);
              if (counters != 0) {
                setState(() {
                  counters--;
                });
              }
            },
            child: Container(
              height: Get.height * .06,
              width: Get.height * .06,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: ColorUtilsGradient.kTintGradient,
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Icon(Icons.remove, color: ColorUtils.kBlack),
            ),
          ),
          SizedBox(width: Get.width * .08),
          RichText(
              text: TextSpan(
                  // text:  '${controller.repsSuperSetList[widget.index]} ',
                  text: '$counters ',
                  style: counters == 0
                      ? FontTextStyle.kWhite24BoldRoboto
                          .copyWith(color: ColorUtils.kGray)
                      : FontTextStyle.kWhite24BoldRoboto,
                  children: [
                TextSpan(text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
              ])),
          SizedBox(width: Get.width * .08),
          InkWell(
              onTap: () {
                // controller.updateRepsSuperSetList(
                //         index: , isPlus: true);
                setState(() {
                  counters++;
                });
              },
              child: Container(
                height: Get.height * .06,
                width: Get.height * .06,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: ColorUtilsGradient.kTintGradient,
                        stops: [0.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Icon(Icons.add, color: ColorUtils.kBlack),
              )),
        ]),
      ),
    );
  }
}

/// super set static timer(30 sec)
class SupersetStaticTimer extends StatefulWidget {
  final double height;
  final double width;
  final int index;
  final String timerEndTime;

  const SupersetStaticTimer(
      {Key? key,
      required this.height,
      required this.width,
      required this.index,
      required this.timerEndTime})
      : super(key: key);

  @override
  _SupersetStaticTimerState createState() => _SupersetStaticTimerState();
}

class _SupersetStaticTimerState extends State<SupersetStaticTimer> {
  WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
      Get.put(WorkoutBaseExerciseViewModel());

  @override
  Widget build(BuildContext context) {
    // print('Time >>>${widget.timerEndTime}');
    return GetBuilder<WorkoutBaseExerciseViewModel>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: controller.staticTimer == true
              ? Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: ColorUtilsGradient.kGrayGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(6)),
                  child: FAProgressBar(
                    animatedDuration: Duration(seconds: 1),
                    currentValue: controller.currentValue.toDouble(),
                    backgroundColor: ColorUtils.kGray,
                    progressColor: ColorUtils.kGreen,
                    maxValue: double.parse("${widget.timerEndTime}"),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (controller.timerStop == false) {
                      controller.timerStop = true;
                      controller.currentValue = 0;
                      controller.setIsClickForSuperSet(isValue: true);
                      controller.setStaticTimer(staticTimerValue: true);
                      controller.setSuperSetCurrentValue(
                          valueForSuperSet: null);
                      if (controller.isClickForSuperSet == true) {
                        controller.setIsClickForSuperSet(isValue: false);

                        if (controller.showTimer == null) {
                        } else {
                          controller.resTimer!.cancel();
                        }
                        controller.showTimer = widget.index;
                        controller.startRestTimer(endTime: widget.timerEndTime);
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: widget.height,
                    width: widget.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kGrayGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text("${widget.timerEndTime} Seconds Rest",
                        style: FontTextStyle.kWhite17W400Roboto),
                  ),
                ),
        );
      },
    );
  }
}
