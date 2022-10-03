import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/goal_res_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_filter_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/goal_view_model.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_by_filter_viewModel.dart';

import '../../utils/images.dart';

class TrainingPlanScreen extends StatefulWidget {
  const TrainingPlanScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanScreenState createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  GoalViewModel _goalViewModel = Get.put(GoalViewModel());
  WorkoutByFilterViewModel _workoutByFilterViewModel =
      Get.put(WorkoutByFilterViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  String? goal = '1';
  String? duration = '3';
  String? gender = 'male';

  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();

    _goalViewModel.goals();
    _workoutByFilterViewModel.getWorkoutByFilterDetails(
      isLoading: true,
      goal: goal,
      duration: duration,
      gender: gender,
      userId: PreferenceManager.getUId(),
    );
  }

  bool? switchSelected = false;
  int? daySelected = 0;
  int? focusSelected = 0;
  var day = [3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
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
                title: Text('Training Plans',
                    style: FontTextStyle.kWhite16BoldRoboto),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.only(
                    left: Get.width * .05, right: Get.width * .05, top: 10),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter By',
                          style: FontTextStyle.kWhite17BoldRoboto,
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            genderSwitch(),
                            selectedDays(),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'FOCUS',
                          style: FontTextStyle.kGreyBoldRoboto,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        focusCategory(),
                        SizedBox(
                          height: 20,
                        ),
                        GetBuilder<WorkoutByFilterViewModel>(
                          builder: (controller) {
                            if (controller.apiResponse.status ==
                                Status.LOADING) {
                              return Center(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.height * .26),
                                child: CircularProgressIndicator(
                                  color: ColorUtils.kTint,
                                ),
                              ));
                            } else if (controller.apiResponse.status ==
                                Status.COMPLETE) {
                              WorkoutByFilterResponseModel response =
                                  controller.apiResponse.data;
                              return GetBuilder<GoalViewModel>(
                                builder: (goalController) {
                                  if (goalController.apiResponse.status ==
                                      Status.COMPLETE) {
                                    GoalsResModel goalResponse =
                                        goalController.apiResponse.data;

                                    if (response.data!.isNotEmpty &&
                                        response.data != []) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: goalResponse.data!.length,
                                          itemBuilder: (_, index) {
                                            return focusSelected == index
                                                ? focusTiles(
                                                    context: context,
                                                    workoutResponse: response,
                                                    goalsResModel: goalResponse)
                                                : SizedBox();
                                          });

                                      // return Column(children: [
                                      //   focusSelected == 0
                                      //       ? buildMuscle(
                                      //           context: context,
                                      //           workoutResponse: response,
                                      //           goalsResModel: goalResponse)
                                      //       : SizedBox(),
                                      //   focusSelected == 1
                                      //       ? cardio(
                                      //           context: context,
                                      //           workoutResponse: response,
                                      //           goalsResModel: goalResponse)
                                      //       : SizedBox(),
                                      //   focusSelected == 2
                                      //       ? strength(
                                      //           context: context,
                                      //           workoutResponse: response,
                                      //           goalsResModel: goalResponse)
                                      //       : SizedBox(),
                                      // ]);
                                    } else {
                                      return Center(
                                        child: Text(
                                          'No data ',
                                          style:
                                              FontTextStyle.kTine17BoldRoboto,
                                        ),
                                      );
                                    }
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ]),
                ),
              ),
            )
          : ConnectionCheckScreen();
    });
  }

  Widget focusTiles(
      {BuildContext? context,
      WorkoutByFilterResponseModel? workoutResponse,
      GoalsResModel? goalsResModel}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: workoutResponse!.data!.length,
        itemBuilder: (context, index) {
          if (workoutResponse.data!.isNotEmpty &&
              workoutResponse.data != null) {
            print(
                "workoutResponse.data![index] ==== ${workoutResponse.data![index].status}");
            if ("${workoutResponse.data![index].status}" == "1") {
              print(
                  "workoutResponse.data![index] ==== inside ${workoutResponse.data![index].status}");
              return selectedFocus(
                  text: '${workoutResponse.data![index].workoutTitle}',
                  image: '${workoutResponse.data![index].workoutImage}',
                  scheduled: workoutResponse.data![index].scheduled,
                  onTap: () {
                    Get.to(PlanOverviewScreen(
                      id: '${workoutResponse.data![index].workoutId}',
                    ));
                  });
            } else {
              return SizedBox();
            }
          } else {
            return Center(
                child: Text(
              'Data Not Found!',
              style: FontTextStyle.kTine17BoldRoboto,
            ));
          }
        });
  }

  Widget focusCategory() {
    return GetBuilder<GoalViewModel>(
      builder: (controller) {
        if (controller.apiResponse.status == Status.LOADING) {
          return SizedBox();
        }
        if (controller.apiResponse.status == Status.ERROR) {
          return Text(
            'Data Not Found!',
            style: FontTextStyle.kWhite17W400Roboto,
          );
        }
        if (controller.apiResponse.status == Status.COMPLETE) {
          GoalsResModel response = controller.apiResponse.data;

          return Container(
            height: Get.height * .05,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ColorUtils.kGray),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemCount: response.data!.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      focusSelected = index;
                      goal = '${response.data![index].goalId}';
                      _workoutByFilterViewModel.getWorkoutByFilterDetails(
                        goal: goal,
                        duration: duration,
                        gender: gender,
                        userId: PreferenceManager.getUId(),
                      );
                    });
                  },
                  child: focusSelected == index
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          alignment: Alignment.center,
                          height: Get.height * .05,
                          width: Get.width * .9 / response.data!.length,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorUtils.kTint,
                          ),
                          child: AutoSizeText(
                              '${response.data![index].goalTitle}',
                              maxLines: 1,
                              style: focusSelected == index
                                  ? FontTextStyle.kBlack16BoldRoboto
                                  : FontTextStyle.kWhite16BoldRoboto))
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          alignment: Alignment.center,
                          height: Get.height * .05,
                          width: Get.width * .9 / response.data!.length,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorUtils.kGray,
                          ),
                          child: AutoSizeText(
                              '${response.data![index].goalTitle}',
                              maxLines: 1,
                              style: focusSelected == index
                                  ? FontTextStyle.kBlack16BoldRoboto
                                  : FontTextStyle.kWhite16BoldRoboto),
                        ),
                );
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget selectedFocus(
      {String? image, String? text, dynamic scheduled, Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: Get.height * .27,
                width: Get.width * .99,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.kTint),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: image != null || image != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          image!,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Image.asset(
                                AppImages.logo,
                                height: Get.height * 0.18,
                                width: Get.height * 0.18,
                              ),
                            );
                          },
                        ),
                      )
                    : Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW3Y7khQ-HoaS-SjqUniPtFKPZVn5uqVYL9LTQhgjPlYzd1_aLj3QZt9DEO-QJpR6iVhg&usqp=CAU',
                        fit: BoxFit.fill,
                      ),
              ),
              Positioned(
                bottom: 1,
                top: 1,
                left: 1,
                right: 1,
                child: Container(
                    height: Get.height * .25,
                    width: Get.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: ColorUtilsGradient.kBlackGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    )),
              ),
              Positioned(
                  bottom: 20,
                  left: Get.width * .05,
                  right: Get.width * .05,
                  child: Text(
                    text!,
                    style: FontTextStyle.kWhite18BoldRoboto,
                  )),
              scheduled! || scheduled == "true"
                  ? Container(
                      alignment: Alignment.center,
                      height: Get.height * .03,
                      width: Get.height * .1,
                      decoration: BoxDecoration(
                          color: ColorUtils.kTint,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: Text('Following',
                          style: FontTextStyle.kBlack12BoldRoboto
                              .copyWith(fontWeight: FontWeight.w500)),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .02,
        ),
      ],
    );
  }

  SizedBox selectedDays() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAYS PER WEEK',
            style: FontTextStyle.kGreyBoldRoboto,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: Get.height * .05,
              width: Get.height * .2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ColorUtils.kGray),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                      day.length,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                daySelected = index;
                                duration = (daySelected! + 3).toString();

                                _workoutByFilterViewModel
                                    .getWorkoutByFilterDetails(
                                  goal: goal,
                                  gender: gender,
                                  duration: duration,
                                  userId: PreferenceManager.getUId(),
                                );
                              });
                            },
                            child: CircleAvatar(
                              radius: Get.height * .025,
                              backgroundColor: daySelected == index
                                  ? ColorUtils.kTint
                                  : ColorUtils.kGray,
                              child: Text('${day[index]}',
                                  style: daySelected == index
                                      ? FontTextStyle.kBlack20BoldRoboto
                                      : FontTextStyle.kWhite20BoldRoboto),
                            ),
                          )))),
        ],
      ),
    );
  }

  SizedBox genderSwitch() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GENDER',
            style: FontTextStyle.kGreyBoldRoboto,
          ),
          SizedBox(
            height: Get.height * .016,
          ),
          switchSelected == false
              ? Container(
                  alignment: Alignment.center,
                  height: Get.height * .05,
                  width: Get.height * .2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorUtils.kGray),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Get.height * .05,
                          width: Get.height * .1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorUtils.kTint,
                          ),
                          child: Center(
                              child: Text(
                            'Male',
                            style: FontTextStyle.kBlack12BoldRoboto,
                          )),
                        ),
                        SizedBox(
                          height: Get.height * .05,
                          width: Get.height * .1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                switchSelected = !switchSelected!;
                                gender = 'female';
                                _workoutByFilterViewModel
                                    .getWorkoutByFilterDetails(
                                  goal: goal,
                                  duration: duration,
                                  gender: gender,
                                  userId: PreferenceManager.getUId(),
                                );
                                log('gender --------- $gender');
                              });
                            },
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  'Female',
                                  style: FontTextStyle.kWhite12BoldRoboto,
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                )
              : Container(
                  height: Get.height * .05,
                  width: Get.height * .2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorUtils.kGray),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: Get.height * .05,
                          width: Get.height * .1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                switchSelected = !switchSelected!;
                                gender = 'male';

                                _workoutByFilterViewModel
                                    .getWorkoutByFilterDetails(
                                  goal: goal,
                                  duration: duration,
                                  gender: gender,
                                  userId: PreferenceManager.getUId(),
                                );
                              });
                            },
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Male',
                                  style: FontTextStyle.kWhite12BoldRoboto,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: Get.height * .05,
                          width: Get.height * .1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorUtils.kTint,
                          ),
                          child: Center(
                              child: Text(
                            'Female',
                            style: FontTextStyle.kBlack12BoldRoboto,
                          )),
                        ),
                      ]),
                )
        ],
      ),
    );
  }
}
