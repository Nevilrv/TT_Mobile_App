import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // Map<String, Map<String, dynamic>> countIndexMapOfSuperSet = {};
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
    _workoutBaseExerciseViewModel.showReps = false;
    _workoutBaseExerciseViewModel.isOneTimeApiCall = true;
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
          print('API CALLING');
          ExerciseByIdResponseModel response = snapshot.data!;
          if (controllerWorkoutBaseExercise.isOneTimeApiCall) {
            repsMap.addAll({
              "${snapshot.data!.data![0].exerciseTitle}":
                  snapshot.data!.data![0].exerciseReps!.isEmpty ||
                          snapshot.data!.data![0].exerciseReps == ""
                      ? "12"
                      : snapshot.data!.data![0].exerciseReps
            });
            print('superSetsuperSetsuperSetsuperSet');
          }

          print('length of key ??? ${repsMap.keys}');
          print('length of superSetId ??? ${widget.superSetIdList.length}');
          print(
              'value of ShowReps Before  ${_workoutBaseExerciseViewModel.showReps}');

          if (repsMap.keys.length == widget.superSetIdList.length) {
            print('Enter in if');
            print(
                'value of ShowReps Before  ${_workoutBaseExerciseViewModel.showReps}');
            if (_workoutBaseExerciseViewModel.showReps == false) {
              _workoutBaseExerciseViewModel.showReps = true;
              print(
                  'value of ShowReps after  ${_workoutBaseExerciseViewModel.showReps}');
              if (controllerWorkoutBaseExercise.isOneTimeApiCall) {
                for (var i = 1; i <= widget.superSetRound; i++) {
                  _workoutBaseExerciseViewModel.superSetRepsSaveMap
                      .addAll({'$i': repsMap});
                }
                controllerWorkoutBaseExercise.isOneTimeApiCall = false;
                print('superSetsuperSetsuperSetsuperSet1');
              }

              print(
                  'NewList >>>> ${_workoutBaseExerciseViewModel.superSetRepsSaveMap}');
              print(
                  'length >>> ${_workoutBaseExerciseViewModel.superSetRepsSaveMap.length}');
              // newList.insert(0, {
              // newList.insert(0, {
              //   "Renegade Row": 45,
              //   "Elbow Plank Pike Jacks": 10,
              //   "Barbell Hang Pull": 5
              // });
              // print('updated NewList >>>> $newList');

            }
          }

          print('Round Count >>??? ${widget.roundCount}');
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
                superSetCounterCardWidget(
                  showText: '${response.data![0].exerciseReps}',
                  controller: _workoutBaseExerciseViewModel,
                  superSetRound: int.parse("${widget.superSetRound}"),
                  round: widget.roundCount,
                  keys: "${response.data![0].exerciseTitle}",
                  // counter: int.parse(
                  //     "${response.data![0].exerciseReps}".split("-").first),
                  counter: 2,
                  newList: [],
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
superSetCounterCardWidget(
    {required int counter,
    required String showText,
    required int round,
    required int superSetRound,
    required WorkoutBaseExerciseViewModel controller,
    required String keys,
    required List<Map<String, dynamic>> newList}) {
  print('round >>> ${round}');
  print('keys >>> ${keys}');
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

            if (controller.superSetRepsSaveMap['$round'][keys] != 0) {
              int t = int.parse(controller.superSetRepsSaveMap['$round'][keys]);

              t--;
              controller.updateSuperSetRepsSaveMap(
                  keyMain: '$round', subKey: keys, value: '$t');

              print('>>>>>> -    $t');

              // var index = widget.round;
              // print('index /// $index');
              // var x = widget.newList[index];
              //
              // print('cxcxcxcxc $x');
              // print('${widget.keys}');
              //
              // x[widget.keys] = t;
              // print('yyyy $x');
              // widget.newList.removeAt(index);
              // widget.newList.insert(index, x);
              // print('1221212 >>> ${widget.newList}');
            }
            Future.delayed(Duration(milliseconds: 100));
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
        showCountText(
          subKey: keys,
          key: '$round',
          controller: controller,
          showText: '${showText}',
        ),
        // RichText(
        //     text: TextSpan(
        //         text:
        //             '${_workoutBaseExerciseViewModel.superSetRepsSaveMap["1"]["Renegade Row"]} ',
        //         // style: widget.newList[widget.round]['${widget.keys}'] == 0
        //         //     ? FontTextStyle.kWhite24BoldRoboto
        //         //         .copyWith(color: ColorUtils.kGray)
        //         //     : FontTextStyle.kWhite24BoldRoboto,
        //         children: [
        //       TextSpan(
        //           text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
        //     ])),
        SizedBox(width: Get.width * .08),
        InkWell(
            onTap: () {
              // controller.updateRepsSuperSetList(
              //         index: , isPlus: true);
              print('=====1-2-3-4  ${controller.superSetRepsSaveMap}');
              int t =
                  int.parse(controller.superSetRepsSaveMap['$round']["$keys"]);

              t++;
              controller.updateSuperSetRepsSaveMap(
                  keyMain: "$round", subKey: "$keys", value: '$t');
              print('++++ /// $t');

              /*var index = widget.round;
                print('index /// $index');
                var x = widget.newList[index];

                print('cxcxcxcxc $x');
                print('${widget.keys}');

                x[widget.keys] = t;
                print('yyyy $x');
                widget.newList.removeAt(index);
                widget.newList.insert(index, x);
                print('1221212 >>> ${widget.newList}');*/
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

Text showCountText(
    {required WorkoutBaseExerciseViewModel controller,
    required String showText,
    required String subKey,
    required String key}) {
  try {
    return Text(
      '${controller.superSetRepsSaveMap[key][subKey] ?? ""}',
      style: TextStyle(color: Colors.white),
    );
  } catch (e) {
    return Text(
      '$showText',
      style: TextStyle(color: Colors.white),
    );
  }
}
// class SuperSetCounterCard extends StatefulWidget {
//   final int counter;
//   final int round;
//   final int superSetRound;
//   final WorkoutBaseExerciseViewModel controller;
//   final String keys;
//   final List<Map<String, dynamic>> newList;
//   const SuperSetCounterCard(
//       {Key? key,
//       required this.counter,
//       required this.round,
//       required this.superSetRound,
//       required this.keys,
//       required this.newList,
//       required this.controller})
//       : super(key: key);
//
//   @override
//   _SuperSetCounterCardState createState() => _SuperSetCounterCardState();
// }

// class _SuperSetCounterCardState extends State<SuperSetCounterCard> {
//   // int counters = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('round >>> ${widget.round}');
//     print('keys >>> ${widget.keys}');
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
//       child: Container(
//         height: Get.height * .1,
//         width: Get.width,
//         decoration: BoxDecoration(
//             border: Border.all(color: ColorUtils.kBlack, width: 2),
//             gradient: LinearGradient(
//                 colors: ColorUtilsGradient.kGrayGradient,
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter),
//             borderRadius: BorderRadius.circular(6)),
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           InkWell(
//             onTap: () {
//
//               // controller.repsSuperSetList[0]++;
//               // print('controller.repsList[index] ');
//               //  controller.updateRepsSuperSetList(
//               //         index: widget.index, isPlus: false);
//
//               if (widget.controller.superSetRepsSaveMap["1"]["Renegade Row"] !=
//                   0) {
//                 int t = int.parse(
//                     widget.controller.superSetRepsSaveMap["1"]["Renegade Row"]);
//
//                 t--;
//                 widget.controller.updateSuperSetRepsSaveMap(
//                     keyMain: "1", subKey: "Renegade Row", value: '$t');
//
//                 print('>>>>>> -    $t');
//
//                 // var index = widget.round;
//                 // print('index /// $index');
//                 // var x = widget.newList[index];
//                 //
//                 // print('cxcxcxcxc $x');
//                 // print('${widget.keys}');
//                 //
//                 // x[widget.keys] = t;
//                 // print('yyyy $x');
//                 // widget.newList.removeAt(index);
//                 // widget.newList.insert(index, x);
//                 // print('1221212 >>> ${widget.newList}');
//               }
//             },
//             child: Container(
//               height: Get.height * .06,
//               width: Get.height * .06,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                       colors: ColorUtilsGradient.kTintGradient,
//                       stops: [0.0, 1.0],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter)),
//               child: Icon(Icons.remove, color: ColorUtils.kBlack),
//             ),
//           ),
//           SizedBox(width: Get.width * .08),
//           Text(
//             '${widget.controller.superSetRepsSaveMap["1"]["Renegade Row"]}',
//             style: TextStyle(color: Colors.white),
//           ),
//           // RichText(
//           //     text: TextSpan(
//           //         text:
//           //             '${_workoutBaseExerciseViewModel.superSetRepsSaveMap["1"]["Renegade Row"]} ',
//           //         // style: widget.newList[widget.round]['${widget.keys}'] == 0
//           //         //     ? FontTextStyle.kWhite24BoldRoboto
//           //         //         .copyWith(color: ColorUtils.kGray)
//           //         //     : FontTextStyle.kWhite24BoldRoboto,
//           //         children: [
//           //       TextSpan(
//           //           text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
//           //     ])),
//           SizedBox(width: Get.width * .08),
//           InkWell(
//               onTap: () {
//                 // controller.updateRepsSuperSetList(
//                 //         index: , isPlus: true);
//                 print('=====1-2-3-4  ${widget.controller.superSetRepsSaveMap}');
//                 int t = int.parse(
//                     widget.controller.superSetRepsSaveMap["1"]["Renegade Row"]);
//
//                 t++;
//                 widget.controller.updateSuperSetRepsSaveMap(
//                     keyMain: "1", subKey: "Renegade Row", value: '$t');
//                 print('++++ /// $t');
//
//                 /*var index = widget.round;
//                 print('index /// $index');
//                 var x = widget.newList[index];
//
//                 print('cxcxcxcxc $x');
//                 print('${widget.keys}');
//
//                 x[widget.keys] = t;
//                 print('yyyy $x');
//                 widget.newList.removeAt(index);
//                 widget.newList.insert(index, x);
//                 print('1221212 >>> ${widget.newList}');*/
//               },
//               child: Container(
//                 height: Get.height * .06,
//                 width: Get.height * .06,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                         colors: ColorUtilsGradient.kTintGradient,
//                         stops: [0.0, 1.0],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter)),
//                 child: Icon(Icons.add, color: ColorUtils.kBlack),
//               )),
//         ]),
//       ),
//     );
//   }
// }

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
  // WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
  //     Get.put(WorkoutBaseExerciseViewModel());

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

/// super set weighted card
class SuperSetWeightedCard extends StatefulWidget {
  TextEditingController? editingController;
  final WorkoutBaseExerciseViewModel controller;
  final String weight;
  final int counter;
  final int index;

  SuperSetWeightedCard(
      {Key? key,
      this.editingController,
      required this.controller,
      required this.weight,
      required this.counter,
      required this.index})
      : super(key: key);

  @override
  _SuperSetWeightedCardState createState() => _SuperSetWeightedCardState();
}

class _SuperSetWeightedCardState extends State<SuperSetWeightedCard> {
  void initState() {
    super.initState();
    widget.editingController = TextEditingController(text: widget.weight);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: GetBuilder<WorkoutBaseExerciseViewModel>(
        builder: (controller) {
          return Container(
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
                  controller.updateWeightRepsList(
                      index: widget.index, isPlus: false);
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
                      text: '${controller.weightedRepsList[widget.index]} ',
                      style: widget.counter == 0
                          ? FontTextStyle.kWhite24BoldRoboto
                              .copyWith(color: ColorUtils.kGray)
                          : FontTextStyle.kWhite24BoldRoboto,
                      children: [
                    TextSpan(
                        text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
                  ])),
              SizedBox(width: Get.width * .08),
              InkWell(
                onTap: () {
                  print('Index >>> ${widget.index}');
                  print('${widget.index.runtimeType}');
                  controller.updateWeightRepsList(
                      index: widget.index, isPlus: true);
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
                ),
              ),
              VerticalDivider(
                width: Get.width * .08,
                thickness: 1.25,
                color: ColorUtils.kBlack,
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
                          controller: widget.editingController,
                          style: widget.counter == 0
                              ? FontTextStyle.kWhite24BoldRoboto
                                  .copyWith(color: ColorUtils.kGray)
                              : FontTextStyle.kWhite24BoldRoboto,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 3,
                          cursorColor: ColorUtils.kTint,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.updateLbsList(
                                  index: widget.index,
                                  value: widget.editingController!.text);
                            } else {
                              controller.updateLbsList(
                                  index: widget.index, value: "0");
                            }
                          },
                          decoration: InputDecoration(
                              hintText: '0',
                              counterText: '',
                              semanticCounterText: '',
                              hintStyle: FontTextStyle.kWhite24BoldRoboto
                                  .copyWith(color: ColorUtils.kGray),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      ),
                      Text('lbs', style: FontTextStyle.kWhite17W400Roboto),
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            ]),
          );
        },
      ),
    );
  }
}
