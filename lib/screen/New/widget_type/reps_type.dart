import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/training_plan_screens/exercise_detail_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/workout_viewModel/workout_base_exercise_viewModel.dart';

Widget repsType(
    {required String title,
    required String exercisesId,
    required String sets,
    required String reps,
    required String exercisesMaxRep,
    String? repsData,
    required WorkoutBaseExerciseViewModel controller,
    required exerciseColor}) {
  controller.repsList = [];

  try {
    List tmpRepsDataList = repsData!
        .replaceAll("[", "")
        .replaceAll("]", "")
        .removeAllWhitespace
        .split(",");

    print('repsData ========== > ${tmpRepsDataList}');

    for (int i = 0; i < tmpRepsDataList.length; i++) {
      exercisesMaxRep == '1'
          ? controller.repsList.add(int.parse('0'))
          : controller.repsList.add(int.parse(tmpRepsDataList[i]));
    }
  } catch (e) {
    for (int i = 0; i < int.parse(sets); i++) {
      exercisesMaxRep == '1'
          ? controller.repsList.add(int.parse('0'))
          : controller.repsList.add(int.parse(reps.split("-").first));
    }
  }

  if (controller.repsList.length < int.parse(sets)) {
    print('Enter');
    int tmpLoopCount = int.parse(sets) - controller.repsList.length;
    print('tmpcount>>> ${tmpLoopCount}');

    for (int i = 0; i < tmpLoopCount; i++) {
      exercisesMaxRep == '1'
          ? controller.repsList.add(int.parse('0'))
          : controller.repsList.add(int.parse(reps.split("-").first));
    }
    print('reps list >>> ${controller.repsList}');
  }
  controller.repsIndexMap
      .addAll({"${controller.currentIndex}": controller.repsList});
  print('repsIndexList >>> ${controller.repsIndexMap}');
  repsText() {
    String s = exercisesMaxRep == '1' ? "Maximum" : reps;
    return s;
  }

  // print('uyuyuy ${controller.repsIndexList["1"][0]}');
  return Scaffold(
    backgroundColor: ColorUtils.kBlack,
    body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: Get.height * 0.05,
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
                    title,
                    // '${widget.controller!.responseExe!.data![0].exerciseTitle}',
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
                        exerciseId: exercisesId, isFromExercise: true));
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
        Text('$sets sets of ${repsText()} reps',
            style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                fontSize: Get.height * 0.023,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w300)),
        SizedBox(
          height: Get.height * 0.05,
        ),
        GetBuilder<WorkoutBaseExerciseViewModel>(
          builder: (controller) => ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: 0, right: Get.width * .06, left: Get.width * .06),
              itemCount: int.parse(sets),
              itemBuilder: (_, index) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: Get.height * .12,
                      width: Get.width,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorUtils.kBlack, width: 2),
                          gradient: LinearGradient(
                              colors: ColorUtilsGradient.kGrayGradient,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    CounterCard(
                      exercisesMaxReps: exercisesMaxRep,
                      index: index,
                      counter: int.tryParse(reps.split("-").first) != null
                          ? int.parse(reps.split("-").first)
                          : 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: Get.height * .027,
                      width: Get.height * .09,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: exerciseColor == "green"
                                  ? ColorUtilsGradient.kGreenGradient
                                  : exerciseColor == "yellow"
                                      ? ColorUtilsGradient.kOrangeGradient
                                      : ColorUtilsGradient.kRedGradient,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomLeft: Radius.circular(6))),
                      child: Text('RIR $reps',
                          style: FontTextStyle.kWhite12BoldRoboto
                              .copyWith(fontWeight: FontWeight.w500)),
                    )
                  ],
                );
              }),
        ),
        SizedBox(
          height: Get.height * 0.05,
        ),
        SizedBox(
          height: Get.height * 0.05,
        ),
      ]),
    ),
  );
}

class CounterCard extends StatefulWidget {
  final int index;
  final int counter;
  final String exercisesMaxReps;
  const CounterCard({
    Key? key,
    required this.index,
    required this.counter,
    required this.exercisesMaxReps,
  }) : super(key: key);

  @override
  _CounterCardState createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
      Get.put(WorkoutBaseExerciseViewModel());
  @override
  Widget build(BuildContext context) {
    // print('exercisesmaxreps >>>> ${widget.exercisesMaxReps}');
    return GetBuilder<WorkoutBaseExerciseViewModel>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          child: Container(
            height: Get.height * .11,
            width: Get.width,
            color: Colors.transparent,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  print('controller.repsList[index] ');
                  controller.updateRepsList(
                      index: widget.index,
                      isPlus: false,
                      key: "${controller.currentIndex}");
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
                      text: widget.exercisesMaxReps == '1'
                          ? '${(_workoutBaseExerciseViewModel.repsIndexMap["${_workoutBaseExerciseViewModel.currentIndex}"][widget.index].toString()) == '0' ? "-   " : '${controller.repsIndexMap["${controller.currentIndex}"][widget.index]} '}'
                          : '${controller.repsIndexMap["${controller.currentIndex}"][widget.index]} '
                      // text:
                      //     '${controller.repsIndexList[controller.currentIndex][widget.index]} ',
                      ,
                      style: widget.exercisesMaxReps == '1'
                          ? FontTextStyle.kWhite24BoldRoboto
                          : controller.repsIndexMap["${controller.currentIndex}"][widget.index] == 0
                              ? FontTextStyle.kWhite24BoldRoboto.copyWith(color: ColorUtils.kGray)
                              : FontTextStyle.kWhite24BoldRoboto,
                      children: [
                    TextSpan(
                        text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
                  ])),
              SizedBox(width: Get.width * .08),
              InkWell(
                  onTap: () {
                    controller.updateRepsList(
                        index: widget.index,
                        isPlus: true,
                        key: "${controller.currentIndex}");
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
      },
    );
  }
}
