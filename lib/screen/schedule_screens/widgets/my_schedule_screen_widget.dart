import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/remove_workout_program_request_model.dart';
import 'package:tcm/model/response_model/schedule_response_model/schedule_by_date_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/remove_workout_program_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/screen/training_plan_screens/program_setup_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/schedule_viewModel/schedule_by_date_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/remove_workout_program_viewModel.dart';

import '../../../model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import '../../../model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import '../../../model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import '../../../viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import '../../../viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import '../../../viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import '../../workout_screen/workout_home.dart';

// ScheduleByDateViewModel _scheduleByDateViewModel =
//     Get.put(ScheduleByDateViewModel());
UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
    Get.put(UserWorkoutsDateViewModel());
ExerciseByIdViewModel _exerciseByIdViewModel = Get.put(ExerciseByIdViewModel());
WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());
Padding listViewTab(
    {required List<Schedule> getEventForDay,
    required BuildContext context,
    ScheduleByDateResponseModel? scheduleResponse}) {
  getEventForDay.sort((a, b) {
    return a.date!.compareTo(b.date!);
  });

  return Padding(
    padding: EdgeInsets.only(top: Get.height * 0.03),
    child: SizedBox(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: getEventForDay.length,
          itemBuilder: (_, index) {
            if (getEventForDay[index].programData!.isNotEmpty ||
                getEventForDay[index].programData! == []) {
              return Padding(
                padding: EdgeInsets.only(bottom: Get.height * .02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Jiffy(getEventForDay[index].date).format('EEEE, MMMM do')}',
                      style: FontTextStyle.kWhite16BoldRoboto,
                    ),
                    Divider(
                      color: ColorUtils.kTint,
                      height: Get.height * .03,
                      thickness: 1.5,
                    ),
                    ListView.builder(
                        itemCount: getEventForDay[index].programData!.length,
                        padding: EdgeInsets.only(top: 0, left: 0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index1) {
                          return ListTile(
                            contentPadding: EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            title: Text(
                              getEventForDay[index]
                                  .programData![index1]
                                  .workoutTitle!,
                              style: FontTextStyle.kWhite17BoldRoboto,
                            ),
                            subtitle: getEventForDay[index]
                                        .programData![0]
                                        .exerciseTitle ==
                                    null
                                ? SizedBox()
                                : Text(
                                    '${getEventForDay[index].programData![0].exerciseTitle}' +
                                        " - " +
                                        ' ${getEventForDay[index].programData![0].exerciseTitle} ',
                                    style: FontTextStyle.kLightGray16W300Roboto,
                                  ),
                            trailing: InkWell(
                              onTap: () {
                                openBottomSheet(
                                    context: context,
                                    event: getEventForDay[index],
                                    date: getEventForDay[index].date,
                                    onPressedView: () {
                                      Get.to(() => PlanOverviewScreen(
                                          id: "${getEventForDay[index].programData![0].workoutId}"));
                                    },
                                    onPressedStart: () {
                                      print(
                                          'date>>>>>  ${getEventForDay[index].date}');
                                      getExercisesId(
                                          getEventForDay[index].date!);
                                    },
                                    onPressedEdit: () {
                                      Get.to(() => ProgramSetupPage(
                                            day: '1',
                                            workoutName: scheduleResponse!
                                                .data![index]
                                                .programData![0]
                                                .workoutTitle,
                                            workoutId: scheduleResponse
                                                .data![index]
                                                .programData![0]
                                                .workoutId,
                                            exerciseId: scheduleResponse
                                                .data![index]
                                                .programData![0]
                                                .exerciseId,
                                            programData: scheduleResponse
                                                .data![index].programData,
                                            isEdit: true,
                                            workoutProgramId: scheduleResponse
                                                .data![index].userProgramId,
                                          ));
                                    });
                              },
                              child: Icon(
                                Icons.more_horiz_sharp,
                                color: ColorUtils.kTint,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),
    ),
  );
}

Tab tabBarCommonTab({IconData? icon, String? tabName}) {
  return Tab(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: Get.height * .02,
        ),
        SizedBox(width: Get.height * .006),
        Text(
          tabName!,
          style: TextStyle(fontSize: Get.height * .017),
        ),
      ],
    ),
  );
}

void openBottomSheet(
    {Schedule? event,
    required BuildContext context,
    Function()? onPressedView,
    Function()? onPressedEdit,
    Function()? onPressedStart,
    String? date,
    RemoveWorkoutProgramViewModel? removeWorkoutProgramViewModel,
    ScheduleByDateViewModel? scheduleByDateViewModel}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(8),
      height: Get.height * .5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.5), color: ColorUtils.kBlack),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: Get.width * .1),
          Center(
            child: Text('${event!.programData![0].workoutTitle}',
                style: FontTextStyle.kWhite20BoldRoboto
                    .copyWith(fontSize: Get.height * .024),
                textAlign: TextAlign.center),
          ),
          SizedBox(height: Get.width * 0.02),
          Divider(
            color: ColorUtils.kTint,
          ),
          TextButton(
              onPressed: onPressedStart,
              child: Text(
                'Start Workout',
                style: FontTextStyle.kTint24W400Roboto,
              )),
          Divider(
            color: ColorUtils.kTint,
          ),
          TextButton(
              onPressed: onPressedView,
              child: Text(
                'View Workout',
                style: FontTextStyle.kTint24W400Roboto,
              )),
          Divider(
            color: ColorUtils.kTint,
          ),
          TextButton(
              onPressed: onPressedEdit,
              child: Text(
                'Edit Workout',
                style: FontTextStyle.kTint24W400Roboto,
              )),
          InkWell(
            onTap: () {
              print('Cancel');

              Get.back();
            },
            child: Container(
              alignment: Alignment.center,
              height: Get.height * .075,
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Cancel',
                style: FontTextStyle.kTint24W400Roboto
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    ),
    backgroundColor: ColorUtils.kBottomSheetGray,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

confirmAlertDialog(
    {BuildContext? context,
    Schedule? event,
    RemoveWorkoutProgramViewModel? removeWorkoutProgramViewModel,
    ScheduleByDateViewModel? scheduleByDateViewModel}) {
  Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: ColorUtils.kBlack,
        actionsOverflowDirection: VerticalDirection.down,
        title: Column(children: [
          Text('Delete Workout',
              style: FontTextStyle.kBlack24W400Roboto.copyWith(
                  fontWeight: FontWeight.bold, color: ColorUtils.kTint)),
          SizedBox(height: 20),
          Text(
            'Are you sure you want to delete workout from schedule?',
            style: FontTextStyle.kBlack16W300Roboto
                .copyWith(color: ColorUtils.kTint),
          ),
        ]),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return ColorUtils.kTint.withOpacity(0.2);
                        return null;
                      },
                    ),
                  ),
                  child: Text('Cancel',
                      style: FontTextStyle.kBlack24W400Roboto
                          .copyWith(color: ColorUtils.kTint)),
                  onPressed: () {
                    Get.back();
                  }),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return ColorUtils.kRed.withOpacity(0.2);
                      return null;
                    },
                  ),
                ),
                child: Text('Delete',
                    style: FontTextStyle.kBlack24W400Roboto.copyWith(
                        color: ColorUtils.kRed, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  RemoveWorkoutProgramRequestModel _request =
                      RemoveWorkoutProgramRequestModel();
                  _request.userWorkoutProgramId = '${event!.userProgramId}';
                  await removeWorkoutProgramViewModel!
                      .removeWorkoutProgramViewModel(_request);
                  print('goes');
                  Get.back();
                  if (removeWorkoutProgramViewModel.apiResponse.status ==
                      Status.COMPLETE) {
                    print(
                        '${removeWorkoutProgramViewModel.apiResponse.status}');
                    RemoveWorkoutProgramResponseModel removeWorkoutResponse =
                        removeWorkoutProgramViewModel.apiResponse.data;
                    if (removeWorkoutResponse.success == true &&
                        removeWorkoutResponse.msg != null) {
                      print('${removeWorkoutResponse.msg}');

                      Get.showSnackbar(GetSnackBar(
                        message: '${removeWorkoutResponse.msg}',
                        duration: Duration(seconds: 2),
                      ));

                      print(
                          'hello ================= ${removeWorkoutResponse.msg}');
                      scheduleByDateViewModel!
                          .dateRangePickerController.selectedDates = [];
                      scheduleByDateViewModel
                          .dateRangePickerController.selectedDates!
                          .clear();
                      scheduleByDateViewModel.dayList.clear();
                      scheduleByDateViewModel.dayList = [];

                      await scheduleByDateViewModel.getScheduleByDateDetails(
                          userId: PreferenceManager.getUId());

                      print('${removeWorkoutResponse.msg} ------------ ');
                    } else if (removeWorkoutResponse.success == true &&
                        removeWorkoutResponse.msg == null) {
                      Get.showSnackbar(GetSnackBar(
                        message: '${removeWorkoutResponse.msg}',
                        duration: Duration(seconds: 2),
                      ));
                    }
                  } else if (removeWorkoutProgramViewModel.apiResponse.status ==
                      Status.ERROR) {
                    print(
                        '${removeWorkoutProgramViewModel.apiResponse.status}');

                    Get.showSnackbar(GetSnackBar(
                      message: 'Something went wrong!!!',
                      duration: Duration(seconds: 2),
                    ));
                  }

                  print("api recall successfully");
                },
              ),
            ],
          ),
        ],
      ),
      barrierColor: ColorUtils.kBlack.withOpacity(0.6));
}

getExercisesId(String time) async {
  log("called 123");
  log('hello........................3');
  await _userWorkoutsDateViewModel.getUserWorkoutsDateDetails(
      userId: PreferenceManager.getUId(), date: time.split(" ").first);

  if (_userWorkoutsDateViewModel.apiResponse.status == Status.COMPLETE) {
    log("complete api call");
    UserWorkoutsDateResponseModel resp =
        _userWorkoutsDateViewModel.apiResponse.data;

    log("--------------- dates ${resp.msg}");

    log("success ------------- true");

    if (resp.success == true) {
      _userWorkoutsDateViewModel.supersetExerciseId.clear();
      _userWorkoutsDateViewModel.exerciseId.clear();

      _userWorkoutsDateViewModel.exerciseId = resp.data!.exercisesIds!;

      if (resp.data!.supersetExercisesIds! != [] ||
          resp.data!.supersetExercisesIds!.isNotEmpty) {
        _userWorkoutsDateViewModel.supersetExerciseId =
            resp.data!.supersetExercisesIds!;
      } else {
        _userWorkoutsDateViewModel.supersetExerciseId = [];
      }

      // _userWorkoutsDateViewModel.supersetExerciseId = ["2", "5", "7", "10"];

      await _exerciseByIdViewModel.getExerciseByIdDetails(
          id: _userWorkoutsDateViewModel
                  .exerciseId[_userWorkoutsDateViewModel.exeIdCounter] ??
              '1');

      ExerciseByIdResponseModel exerciseResponse =
          _exerciseByIdViewModel.apiResponse.data;

      await _workoutByIdViewModel.getWorkoutByIdDetails(
          id: resp.data!.workoutId ?? '1');

      WorkoutByIdResponseModel workoutResponse =
          _workoutByIdViewModel.apiResponse.data;

      Get.to(() => WorkoutHomeScreen(
            exeData: exerciseResponse.data!,
            data: workoutResponse.data!,
          ));
      log('workoutResponse>>>>>>  ${workoutResponse.data}');
    } else {
      log("success ------------- false");
    }
  }
}
