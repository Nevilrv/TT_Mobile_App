import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/request_model/training_plan_request_model/remove_workout_program_request_model.dart';
import 'package:tcm/model/request_model/training_plan_request_model/save_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/remove_workout_program_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/save_workout_program_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/workout_screen/workout_home.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/training_plan_viewModel/day_based_exercise_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/remove_workout_program_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_workout_program_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_exercise_conflict_viewModel.dart';

class ProgramSetupPage extends StatefulWidget {
  final String? exerciseId;
  final String? day;
  final String? workoutId;
  final String? workoutDay;
  final String? workoutName;
  ProgramSetupPage(
      {Key? key,
      this.exerciseId,
      this.workoutId,
      this.day,
      this.workoutDay,
      this.workoutName})
      : super(key: key);

  @override
  State<ProgramSetupPage> createState() => _ProgramSetupPageState();
}

class _ProgramSetupPageState extends State<ProgramSetupPage> {
  DayBasedExerciseViewModel _dayBasedExerciseViewModel =
      Get.put(DayBasedExerciseViewModel());

  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());

  WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());

  SaveWorkoutProgramViewModel _saveWorkoutProgramViewModel =
      Get.put(SaveWorkoutProgramViewModel());

  WorkoutExerciseConflictViewModel _workoutExerciseConflictViewModel =
      Get.put(WorkoutExerciseConflictViewModel());

  RemoveWorkoutProgramViewModel _removeWorkoutProgramViewModel =
      Get.put(RemoveWorkoutProgramViewModel());

  @override
  void initState() {
    super.initState();
    data.clear();
    selectedDay.clear();

    _workoutByIdViewModel.defSelectedList.clear();
    _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.workoutId);
    _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails();

    widget.exerciseId != null && widget.day == null
        ? _exerciseByIdViewModel.getExerciseByIdDetails(id: widget.exerciseId)
        : callApi();
  }

  callApi() async {
    await _dayBasedExerciseViewModel.getDayBasedExerciseDetails(
        id: widget.workoutId, day: widget.day);
    if (_dayBasedExerciseViewModel.apiResponse.status == Status.COMPLETE) {
      DayBasedExerciseResponseModel responseDayBased =
          _dayBasedExerciseViewModel.apiResponse.data;
      await _exerciseByIdViewModel.getExerciseByIdDetails(
          id: responseDayBased.data![0].exercises![0].exerciseId);
    }
  }

  conflictApi() async {
    await _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails(
        date: dateString(), userId: PreferenceManager.getUId());
    if (_workoutExerciseConflictViewModel.apiResponse.status ==
        Status.COMPLETE) {
      WorkoutExerciseConflictResponseModel resConflict =
          _workoutExerciseConflictViewModel.apiResponse.data;

      if (resConflict.data != [] &&
          resConflict.msg ==
              "You are already following another program on these dates. Choose below if you want to follow them both.") {
        conflictWorkoutList = resConflict.data!;
        warningmsg = '${resConflict.msg}';

        print('-------------- msg${resConflict.msg}');

        print('conflict called on week days');
        print('conflict called -=--=-=-=-=-=-=-=-=-=-=-==--=-=');

        _workoutByIdViewModel.changeConflict(true);
      } else {
        _workoutByIdViewModel.changeConflict(false);
        print('conflict else part called -=--=-=-=-=-=-=-=-=-=-=-==--=-=');
      }
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Map<String, dynamic> addList = {
    'day0': '',
    'day1': '',
    'day2': '',
    'day3': '',
    'day4': '',
    'day5': '',
    'day6': '',
  };
  int startIndex = 0;
  List<int> showList = [];
  List<int> showList1 = [];
  List apiDayDataList = [0, 1, 2, 3, 4, 5, 6];
  bool isStart = false;
  bool isSelected = false;
  List finalDateSelectedList = [];
  List apiDayAddedList = [];
  List days = [];
  List<Conflict>? conflictWorkoutList = [];
  String? warningmsg = '';
  bool calendarTap = false;
  DateTime? dateByUser;
  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List selectedDay = [];
  List data = [];
  updateWithSelection({required int weekLength, required DateTime startDate}) {
    if (_workoutByIdViewModel.apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      DateTime todayDate = startDate == null ? DateTime.now() : startDate;
      List<int> weekDay = [];
      print("start date ------------- ${startDate}");
      _workoutByIdViewModel.dayAddedList.forEach((element) {
        if (element == 'Monday') {
          weekDay.add(1);
        } else if (element == 'Tuesday') {
          weekDay.add(2);
        } else if (element == 'Wednesday') {
          weekDay.add(3);
        } else if (element == 'Thursday') {
          weekDay.add(4);
        } else if (element == 'Friday') {
          weekDay.add(5);
        } else if (element == 'Saturday') {
          weekDay.add(6);
        } else if (element == 'Sunday') {
          weekDay.add(7);
        }
      });
      int nextWeekCal = 0;
      int smallestDay =
          weekDay.reduce((curr, next) => curr < next ? curr : next);
      print("week day === ${startDate.weekday}");
      print("week day list ======= $weekDay");
      if (smallestDay < startDate.weekday) {
        print(
            " this week day number is $smallestDay and its starts from ${startDate.weekday} and date is $startDate");
        for (int i = 1; i <= 7; i++) {
          if (startDate.weekday == i) {
            nextWeekCal = (8 - i);
          }
        }
      }
      print('cal ------ $nextWeekCal');
      print('smallestDay ----------------- ${smallestDay}');
      for (int week = 1; week <= weekLength; week++) {
        DateTime weekEndDate = DateTime(
            todayDate.year, todayDate.month, todayDate.day + nextWeekCal);
        DateTime endDate = DateTime(
            weekEndDate.year, weekEndDate.month, weekEndDate.day + 7 * week);
        print('end date  ---------------------- ${weekEndDate.day + 7 * week}');
        List<DateTime> days = [];
        DateTime tmp = DateTime(
            todayDate.year, todayDate.month, todayDate.day + nextWeekCal);
        print('tmp date ------------- $tmp');
        while (DateTime(tmp.year, tmp.month, tmp.day) != endDate) {
          for (int apiDay = 0; apiDay < weekDay.length; apiDay++) {
            if (tmp.weekday == weekDay[apiDay]) {
              days.add(DateTime(tmp.year, tmp.month, tmp.day));
            }
          }
          tmp = tmp.add(new Duration(days: 1));
        }
        log('days list --------- $days');
        _workoutByIdViewModel.listUpdate(value: days);
        conflictApi();
      }
    }
  }

  multiSelectionDay({required DateTime userSelectedDate}) {
    if (_workoutByIdViewModel.apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      WorkoutByIdResponseModel res = _workoutByIdViewModel.apiResponse.data;
      String daysFromApi = '${res.data![0].selectedDays!}';
      List<String> listOfDaysFromApi = daysFromApi.split(",");
      if (_workoutByIdViewModel.callOneTimeApiCall == true) {
        _workoutByIdViewModel.dayAddedList = listOfDaysFromApi;
        setNumber();
      }
      _workoutByIdViewModel.callOneTimeApiCall = false;
      updateWithSelection(
          weekLength: res.data![0].daysAllData!.length,
          startDate: userSelectedDate);
    }
  }

  void setNumber() {
    data.clear();
    selectedDay.clear();
    weekDays.forEach((element) {
      if (_workoutByIdViewModel.dayAddedList.contains(element)) {
        selectedDay.add(element);
        log('weekDays  $element');
        log('aaaaa  $selectedDay');
      } else {
        log('weekDays 1 $element');
      }
    });
    if (selectedDay.length == 1) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else {
          data.add(0);
        }
      });
    } else if (selectedDay.length == 2) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else if (element.contains(selectedDay[1])) {
          data.add(2);
        } else {
          data.add(0);
        }
      });
    } else if (selectedDay.length == 3) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else if (element.contains(selectedDay[1])) {
          data.add(2);
        } else if (element.contains(selectedDay[2])) {
          data.add(3);
        } else {
          data.add(0);
        }
      });
    } else if (selectedDay.length == 4) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else if (element.contains(selectedDay[1])) {
          data.add(2);
        } else if (element.contains(selectedDay[2])) {
          data.add(3);
        } else if (element.contains(selectedDay[3])) {
          data.add(4);
        } else {
          data.add(0);
        }
      });
    } else if (selectedDay.length == 5) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else if (element.contains(selectedDay[1])) {
          data.add(2);
        } else if (element.contains(selectedDay[2])) {
          data.add(3);
        } else if (element.contains(selectedDay[3])) {
          data.add(4);
        } else if (element.contains(selectedDay[4])) {
          data.add(5);
        } else {
          data.add(0);
        }
      });
    } else if (selectedDay.length == 6) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else if (element.contains(selectedDay[1])) {
          data.add(2);
        } else if (element.contains(selectedDay[2])) {
          data.add(3);
        } else if (element.contains(selectedDay[3])) {
          data.add(4);
        } else if (element.contains(selectedDay[4])) {
          data.add(5);
        } else if (element.contains(selectedDay[5])) {
          data.add(6);
        } else {
          data.add(0);
        }
      });
    } else if (selectedDay.length == 7) {
      AppText.weekDays.forEach((element) {
        print('ELEMENT>>>>> $element');
        if (element.contains(selectedDay[0])) {
          data.add(1);
        } else if (element.contains(selectedDay[1])) {
          data.add(2);
        } else if (element.contains(selectedDay[2])) {
          data.add(3);
        } else if (element.contains(selectedDay[3])) {
          data.add(4);
        } else if (element.contains(selectedDay[4])) {
          data.add(5);
        } else if (element.contains(selectedDay[5])) {
          data.add(6);
        } else if (element.contains(selectedDay[6])) {
          data.add(7);
        }
      });
    }
    log('DATA>>>>>$data');
  }

  @override
  void dispose() {
    _workoutByIdViewModel.isCallOneTime = true;
    super.dispose();
  }

  String dateString() {
    finalDateSelectedList.clear();
    _workoutByIdViewModel.defSelectedList.forEach((element) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(element);
      finalDateSelectedList.add(formatted);
    });
    String finalDateSelectedString = finalDateSelectedList.join(", ");
    return finalDateSelectedString;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _workoutByIdViewModel.callOneTimeApiCall = true;
        _workoutByIdViewModel.dateRangePickerController.selectedDates!.clear();
        _workoutByIdViewModel.changeConflict(false);
        return true;
      },
      child: GetBuilder<DayBasedExerciseViewModel>(
        builder: (controller) {
          if (controller.apiResponse.status == Status.LOADING) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorUtils.kTint,
              ),
            );
          }
          if (controller.apiResponse.status == Status.ERROR) {
            return Center(
              child: noDataLottie(),
            );
          }
          if (controller.apiResponse.status == Status.COMPLETE) {
            return GetBuilder<ExerciseByIdViewModel>(builder: (controllerExe) {
              if (controllerExe.apiResponse.status == Status.LOADING) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  ),
                );
              }
              if (controllerExe.apiResponse.status == Status.ERROR) {
                return Center(
                  child: noDataLottie(),
                );
              }
              if (controllerExe.apiResponse.status == Status.COMPLETE) {
                ExerciseByIdResponseModel response =
                    controllerExe.apiResponse.data;
                return Scaffold(
                  backgroundColor: ColorUtils.kBlack,
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () {
                          Get.back();
                          _workoutByIdViewModel.callOneTimeApiCall = true;
                          _workoutByIdViewModel
                              .dateRangePickerController.selectedDates!
                              .clear();
                          _workoutByIdViewModel.changeConflict(false);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          color: ColorUtils.kTint,
                        )),
                    backgroundColor: ColorUtils.kBlack,
                    title: Text('Setup Program',
                        style: FontTextStyle.kWhite16BoldRoboto),
                    centerTitle: true,
                  ),
                  body: response.data!.isNotEmpty && response.data != []
                      ? GetBuilder<WorkoutByIdViewModel>(
                          builder: (controllerWork) {
                          if (controllerWork.apiResponse.status ==
                              Status.LOADING) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorUtils.kTint,
                              ),
                            );
                          }
                          if (controllerWork.apiResponse.status ==
                              Status.ERROR) {
                            return Center(
                              child: noDataLottie(),
                            );
                          }
                          if (controllerWork.apiResponse.status ==
                              Status.COMPLETE) {
                            WorkoutByIdResponseModel workResponse =
                                controllerWork.apiResponse.data;
                            String finalDayString =
                                controllerWork.dayAddedList.join(",");
                            print(
                                'finalDayList ----------------- $finalDayString');
                            String apiDayDataString =
                                workResponse.data![0].selectedDays!;
                            List tmpList = apiDayDataString.split(",");
                            for (int i = 0; i < tmpList.length; i++) {
                              if (apiDayDataList.contains(i)) {
                                apiDayDataList.remove(i);
                                apiDayDataList.add(tmpList[i]);
                              }
                            }
                            print(
                                'apiDayDataList ------------- $apiDayDataList');
                            return GetBuilder<SaveWorkoutProgramViewModel>(
                              builder: (saveWorkoutController) {
                                if (controllerWork.isCallOneTime) {
                                  multiSelectionDay(
                                      userSelectedDate: dateByUser == null
                                          ? DateTime.now()
                                          : dateByUser!);
                                }
                                controllerWork.isCallOneTime = false;
                                String endDate(List<DateTime> dates) {
                                  DateTime maxDate = dates[0];
                                  dates.forEach((date) {
                                    if (date.isAfter(maxDate)) {
                                      maxDate = date;
                                    }
                                  });
                                  final DateFormat formatter =
                                      DateFormat('yyyy-MM-dd');
                                  String endDate = formatter.format(maxDate);

                                  return endDate;
                                }

                                String startDate(List<DateTime> dates) {
                                  DateTime minDate = dates[0];
                                  dates.forEach((date) {
                                    if (date.isBefore(minDate)) {
                                      minDate = date;
                                    }
                                  });
                                  final DateFormat formatter =
                                      DateFormat('yyyy-MM-dd');
                                  String startDate = formatter.format(minDate);

                                  return startDate;
                                }

                                String daysFromApi =
                                    '${workResponse.data![0].selectedDays!}';
                                List<String> listOfDaysFromApi =
                                    daysFromApi.split(",");
                                _workoutByIdViewModel.apiDayLength =
                                    listOfDaysFromApi.length;
                                if (controllerWork.calendarTap == true) {
                                  controllerWork.setDateController(
                                      controllerWork.defSelectedList);

                                  controllerWork.changeCalendar(false);
                                }
                                return Stack(
                                  children: [
                                    SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.06,
                                            vertical: Get.height * 0.025),
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  '${workResponse.data![0].workoutTitle}',
                                                  style: FontTextStyle
                                                      .kWhite20BoldRoboto,
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.01),
                                                Text(
                                                  '${workResponse.data![0].workoutDuration} days a week',
                                                  style: FontTextStyle
                                                      .kLightGray16W300Roboto,
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.04),
                                                Text(
                                                  'What days do you want to workout?',
                                                  style: FontTextStyle
                                                      .kWhite16BoldRoboto,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Get.width * 0.05,
                                                    vertical:
                                                        Get.height * 0.045),
                                                child: Container(
                                                  height: Get.height * 0.61,
                                                  width: Get.width,
                                                  child: ListView.separated(
                                                      separatorBuilder:
                                                          (_, index) {
                                                        return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: Get
                                                                            .height *
                                                                        0.01));
                                                      },
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: AppText
                                                          .weekDays.length,
                                                      itemBuilder: (_, index) {
                                                        return InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              _workoutByIdViewModel
                                                                  .setDayAddedList(
                                                                      value:
                                                                          '${AppText.weekDays[index]}');
                                                              updateWithSelection(
                                                                  weekLength:
                                                                      workResponse
                                                                          .data![
                                                                              0]
                                                                          .daysAllData!
                                                                          .length,
                                                                  startDate: dateByUser ==
                                                                          null
                                                                      ? DateTime
                                                                          .now()
                                                                      : dateByUser!);
                                                              controllerWork
                                                                  .setDateController(
                                                                      controllerWork
                                                                          .defSelectedList);

                                                              log('_workoutByIdViewModel.dayAddedList[0]  ${_workoutByIdViewModel.dayAddedList}');

                                                              setNumber();
                                                              log('DATA>>>>>$data');
                                                            });
                                                            await _workoutExerciseConflictViewModel
                                                                .getWorkoutExerciseConflictDetails(
                                                                    date:
                                                                        dateString(),
                                                                    userId: PreferenceManager
                                                                        .getUId());
                                                            if (_workoutExerciseConflictViewModel
                                                                    .apiResponse
                                                                    .status ==
                                                                Status
                                                                    .COMPLETE) {
                                                              WorkoutExerciseConflictResponseModel
                                                                  resConflict =
                                                                  _workoutExerciseConflictViewModel
                                                                      .apiResponse
                                                                      .data;

                                                              if (resConflict
                                                                          .data !=
                                                                      [] &&
                                                                  resConflict
                                                                          .msg ==
                                                                      "You are already following another program on these dates. Choose below if you want to follow them both.") {
                                                                conflictWorkoutList =
                                                                    resConflict
                                                                        .data!;
                                                                warningmsg =
                                                                    '${resConflict.msg}';

                                                                print(
                                                                    '-------------- msg${resConflict.msg}');

                                                                print(
                                                                    'conflict called on week days');

                                                                controllerWork
                                                                    .changeConflict(
                                                                        true);
                                                              } else {
                                                                controllerWork
                                                                    .changeConflict(
                                                                        false);
                                                              }
                                                            }
                                                            print(
                                                                '------------- days 123 ${_workoutByIdViewModel.defSelectedList}');

                                                            log('----show day list ${_workoutByIdViewModel.dayAddedList}');
                                                          },
                                                          child: Container(
                                                            height: Get.height *
                                                                0.065,
                                                            width: Get.width,
                                                            decoration: BoxDecoration(
                                                                gradient: _workoutByIdViewModel.dayAddedList.contains(AppText.weekDays[index])
                                                                    ? LinearGradient(
                                                                        colors: ColorUtilsGradient
                                                                            .kTintGradient,
                                                                        begin: Alignment
                                                                            .topCenter,
                                                                        end: Alignment
                                                                            .bottomCenter)
                                                                    : null,
                                                                color: controllerWork.dayAddedList.contains(AppText.weekDays[index])
                                                                    ? null
                                                                    : ColorUtils
                                                                        .kBlack,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Get.height *
                                                                            0.1),
                                                                border: _workoutByIdViewModel
                                                                        .dayAddedList
                                                                        .contains(
                                                                            AppText.weekDays[index])
                                                                    ? null
                                                                    : Border.all(color: ColorUtils.kTint)),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          Get.width *
                                                                              0.04),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  data[index] ==
                                                                          0
                                                                      ? SizedBox()
                                                                      : Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              Get.height * .05,
                                                                          width:
                                                                              Get.height * .05,
                                                                          decoration: BoxDecoration(
                                                                              color: ColorUtils.kBlack,
                                                                              shape: BoxShape.circle),
                                                                          child:
                                                                              Text(
                                                                            data[index].toString(),
                                                                            style:
                                                                                FontTextStyle.kTint20BoldRoboto,
                                                                          ),
                                                                        ),
                                                                  Text(
                                                                      AppText.weekDays[
                                                                          index],
                                                                      style: controllerWork.dayAddedList.contains(AppText.weekDays[
                                                                              index])
                                                                          ? FontTextStyle
                                                                              .kBlack20BoldRoboto
                                                                          : FontTextStyle
                                                                              .kTint20BoldRoboto),
                                                                  apiDayDataList
                                                                          .contains(
                                                                              AppText.weekDays[index])
                                                                      // &&
                                                                      //     _workoutByIdViewModel
                                                                      //         .dayAddedList
                                                                      //         .contains(
                                                                      //             AppText.weekDays[index])
                                                                      ? Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              Get.height * 0.05,
                                                                          width:
                                                                              Get.height * 0.05,
                                                                          decoration: BoxDecoration(
                                                                              color: ColorUtils.kBlack,
                                                                              shape: BoxShape.circle),
                                                                          child: Text(
                                                                              'Rec.',
                                                                              style: FontTextStyle.kTint12BoldRoboto),
                                                                        )
                                                                      : SizedBox(
                                                                          height:
                                                                              Get.height * 0.05,
                                                                          width:
                                                                              Get.height * 0.05,
                                                                        )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                )),
                                            Divider(
                                              color: ColorUtils.kGray,
                                              thickness: 2,
                                              height: Get.height * 0.04,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: Get.height * .02,
                                                  left: Get.width * .03,
                                                  right: Get.width * .03),
                                              child: SizedBox(
                                                height: Get.height * .55,
                                                child: SfDateRangePicker(
                                                  view:
                                                      DateRangePickerView.month,
                                                  showNavigationArrow: true,
                                                  enablePastDates: false,
                                                  controller: controllerWork
                                                      .dateRangePickerController,
                                                  initialDisplayDate:
                                                      DateTime.now(),
                                                  todayHighlightColor:
                                                      ColorUtils.kTint,
                                                  selectionRadius: 17,
                                                  selectionColor:
                                                      ColorUtils.kTint,
                                                  minDate: DateTime.utc(
                                                      2019, 01, 01),
                                                  maxDate: DateTime.utc(
                                                      2099, 12, 31),
                                                  selectionTextStyle:
                                                      FontTextStyle
                                                          .kBlack18w600Roboto,
                                                  enableMultiView: false,
                                                  yearCellStyle: DateRangePickerYearCellStyle(
                                                      textStyle: FontTextStyle
                                                          .kWhite17W400Roboto,
                                                      todayTextStyle:
                                                          FontTextStyle
                                                              .kWhite17W400Roboto,
                                                      disabledDatesTextStyle:
                                                          FontTextStyle
                                                              .kLightGray16W300Roboto),
                                                  monthCellStyle:
                                                      DateRangePickerMonthCellStyle(
                                                    todayCellDecoration:
                                                        BoxDecoration(
                                                            color: Colors
                                                                .transparent),
                                                    disabledDatesTextStyle:
                                                        FontTextStyle
                                                            .kLightGray16W300Roboto,
                                                    textStyle: FontTextStyle
                                                        .kWhite17W400Roboto,
                                                    todayTextStyle:
                                                        FontTextStyle
                                                            .kWhite17W400Roboto,
                                                  ),
                                                  selectionMode:
                                                      DateRangePickerSelectionMode
                                                          .multiple,
                                                  initialSelectedDates:
                                                      controllerWork
                                                          .defSelectedList,
                                                  onSelectionChanged:
                                                      (DateRangePickerSelectionChangedArgs
                                                          args) async {
                                                    days = args.value;
                                                    dateByUser = days.last;
                                                    multiSelectionDay(
                                                        userSelectedDate:
                                                            dateByUser!);
                                                    controllerWork
                                                        .setDateController(
                                                            controllerWork
                                                                .defSelectedList);
                                                    await _workoutExerciseConflictViewModel
                                                        .getWorkoutExerciseConflictDetails(
                                                            date: dateString(),
                                                            userId:
                                                                PreferenceManager
                                                                    .getUId());
                                                    if (_workoutExerciseConflictViewModel
                                                            .apiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      WorkoutExerciseConflictResponseModel
                                                          resConflict =
                                                          _workoutExerciseConflictViewModel
                                                              .apiResponse.data;

                                                      if (resConflict.data !=
                                                              [] &&
                                                          resConflict.msg ==
                                                              "You are already following another program on these dates. Choose below if you want to follow them both.") {
                                                        conflictWorkoutList =
                                                            resConflict.data!;
                                                        warningmsg =
                                                            '${resConflict.msg}';

                                                        print(
                                                            '-------------- msg${resConflict.msg}');

                                                        print(
                                                            'conflict called on week days');

                                                        controllerWork
                                                            .changeConflict(
                                                                true);
                                                      } else {
                                                        controllerWork
                                                            .changeConflict(
                                                                false);
                                                      }
                                                    }
                                                  },
                                                  monthViewSettings:
                                                      DateRangePickerMonthViewSettings(
                                                    firstDayOfWeek: 1,
                                                    dayFormat: 'EEE',
                                                    viewHeaderStyle:
                                                        DateRangePickerViewHeaderStyle(
                                                            textStyle: FontTextStyle
                                                                .kWhite17W400Roboto),
                                                  ),
                                                  headerStyle:
                                                      DateRangePickerHeaderStyle(
                                                    textAlign: TextAlign.center,
                                                    textStyle: FontTextStyle
                                                        .kWhite20BoldRoboto,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            controllerWork.isConflict
                                                ? Column(
                                                    children: [
                                                      Divider(
                                                        color: ColorUtils.kGray,
                                                        thickness: 2,
                                                        height:
                                                            Get.height * .05,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    Get.height *
                                                                        .03),
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            Get.height * .045,
                                                        width: Get.width * .27,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                ColorUtils.kRed,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                        child: Text(
                                                          'WARNING',
                                                          style: FontTextStyle
                                                              .kWhite17BoldRoboto,
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                          itemCount:
                                                              conflictWorkoutList!
                                                                  .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (_, index) {
                                                            return Column(
                                                                children: [
                                                                  Text(
                                                                    warningmsg!,
                                                                    style: FontTextStyle
                                                                        .kWhite16BoldRoboto,
                                                                    maxLines: 2,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            Get.height *
                                                                                .02),
                                                                    child: Text(
                                                                      conflictWorkoutList![
                                                                              index]
                                                                          .workoutTitle!,
                                                                      style: FontTextStyle
                                                                          .kWhite20BoldRoboto,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(
                                                                              WorkoutHomeScreen(
                                                                            data:
                                                                                workResponse.data!,
                                                                            exeData:
                                                                                response.data!,
                                                                            workoutId:
                                                                                widget.workoutId,
                                                                          ));
                                                                          Get.showSnackbar(
                                                                              GetSnackBar(
                                                                            message:
                                                                                'Your old workout ${workResponse.data![0].workoutTitle} is not removed from schedule',
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                          ));
                                                                          controllerWork
                                                                              .changeConflict(false);
                                                                          print(
                                                                              'Keep Pressed');
                                                                          print(
                                                                              'keep ${controllerWork.isConflict}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              Get.height * .05,
                                                                          width:
                                                                              Get.width * .3,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                              gradient: LinearGradient(colors: ColorUtilsGradient.kTintGradient, begin: Alignment.center, end: Alignment.center)),
                                                                          child:
                                                                              Text(
                                                                            'Keep',
                                                                            style:
                                                                                FontTextStyle.kBlack18w600Roboto,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              Get.width * .05),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          RemoveWorkoutProgramRequestModel
                                                                              _request =
                                                                              RemoveWorkoutProgramRequestModel();
                                                                          _request.userWorkoutProgramId =
                                                                              conflictWorkoutList![index].userWorkoutProgramId;
                                                                          await _removeWorkoutProgramViewModel
                                                                              .removeWorkoutProgramViewModel(_request);
                                                                          if (_removeWorkoutProgramViewModel.apiResponse.status ==
                                                                              Status.COMPLETE) {
                                                                            RemoveWorkoutProgramResponseModel
                                                                                removeWorkoutResponse =
                                                                                _removeWorkoutProgramViewModel.apiResponse.data;
                                                                            if (removeWorkoutResponse.success == true &&
                                                                                removeWorkoutResponse.msg != null) {
                                                                              Get.showSnackbar(GetSnackBar(
                                                                                message: '${removeWorkoutResponse.msg}',
                                                                                duration: Duration(seconds: 2),
                                                                              ));
                                                                              controllerWork.changeConflict(false);
                                                                            } else if (removeWorkoutResponse.success == true &&
                                                                                removeWorkoutResponse.msg == null) {
                                                                              Get.showSnackbar(GetSnackBar(
                                                                                message: '${removeWorkoutResponse.msg}',
                                                                                duration: Duration(seconds: 2),
                                                                              ));
                                                                            }
                                                                          } else if (saveWorkoutController.apiResponse.status ==
                                                                              Status.ERROR) {
                                                                            Get.showSnackbar(GetSnackBar(
                                                                              message: 'Something went wrong!!!',
                                                                              duration: Duration(seconds: 2),
                                                                            ));
                                                                          }

                                                                          controllerWork
                                                                              .changeConflict(false);
                                                                          print(
                                                                              'Remove Pressed');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              Get.height * .05,
                                                                          width:
                                                                              Get.width * .3,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                              border: Border.all(color: ColorUtils.kTint, width: 1.5)),
                                                                          child:
                                                                              Text(
                                                                            'Remove',
                                                                            style:
                                                                                FontTextStyle.kTine17BoldRoboto,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: Get
                                                                              .height *
                                                                          0.05)
                                                                ]);
                                                          }),
                                                    ],
                                                  )
                                                : SizedBox(),
                                            Divider(
                                              color: ColorUtils.kGray,
                                              thickness: 2,
                                              height: Get.height * 0.05,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(AppText.getByEmail,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Get.height * .02)),
                                                Spacer(),
                                                CupertinoSwitch(
                                                  activeColor: ColorUtils.kTint,
                                                  value: controllerWork
                                                      .switchValue,
                                                  onChanged: (value) {
                                                    controllerWork
                                                        .emailToggle(value);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Get.width * .05,
                                                  right: Get.width * .05,
                                                  top: Get.height * .03,
                                                  bottom: Get.height * .02),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await _workoutExerciseConflictViewModel
                                                      .getWorkoutExerciseConflictDetails(
                                                          date: dateString(),
                                                          userId:
                                                              PreferenceManager
                                                                  .getUId(),
                                                          isLoading: true);
                                                  if (_workoutExerciseConflictViewModel
                                                          .apiResponse.status ==
                                                      Status.COMPLETE) {
                                                    WorkoutExerciseConflictResponseModel
                                                        resConflict =
                                                        _workoutExerciseConflictViewModel
                                                            .apiResponse.data;
                                                    print(
                                                        'START-------------- msg${resConflict.msg}');

                                                    if (resConflict.data ==
                                                            [] ||
                                                        resConflict.msg !=
                                                            "No Conflicts available") {
                                                      conflictWorkoutList =
                                                          resConflict.data!;
                                                      warningmsg =
                                                          '${resConflict.msg}';

                                                      print(
                                                          ' -------------- msg ${resConflict.msg}');

                                                      print(
                                                          'conflict called on week days');

                                                      controllerWork
                                                          .changeConflict(true);
                                                    } else {
                                                      controllerWork
                                                          .changeConflict(
                                                              false);
                                                      if (controllerWork
                                                                  .apiResponse
                                                                  .status !=
                                                              Status.LOADING ||
                                                          controllerWork
                                                                  .apiResponse
                                                                  .status !=
                                                              Status.ERROR) {
                                                        SaveWorkoutProgramRequestModel
                                                            _request =
                                                            SaveWorkoutProgramRequestModel();
                                                        _request.userId =
                                                            PreferenceManager
                                                                .getUId();
                                                        _request.workoutId =
                                                            workResponse
                                                                .data![0]
                                                                .workoutId;
                                                        _request.exerciseId =
                                                            "0";
                                                        _request.startDate =
                                                            startDate(controllerWork
                                                                .defSelectedList);
                                                        _request.endDate =
                                                            endDate(controllerWork
                                                                .defSelectedList);
                                                        _request.selectedWeekDays =
                                                            finalDayString;
                                                        _request.selectedDates =
                                                            dateString();
                                                        await saveWorkoutController
                                                            .saveWorkoutProgramViewModel(
                                                                _request);
                                                        if (saveWorkoutController
                                                                .apiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          SaveWorkoutProgramResponseModel
                                                              saveWorkoutResponse =
                                                              saveWorkoutController
                                                                  .apiResponse
                                                                  .data;
                                                          if (saveWorkoutResponse
                                                                      .success ==
                                                                  true &&
                                                              saveWorkoutResponse
                                                                      .msg !=
                                                                  null) {
                                                            Get.showSnackbar(
                                                                GetSnackBar(
                                                              message:
                                                                  '${saveWorkoutResponse.msg}',
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ));
                                                            Get.to(
                                                                WorkoutHomeScreen(
                                                              data: workResponse
                                                                  .data!,
                                                              exeData: response
                                                                  .data!,
                                                              workoutId: widget
                                                                  .workoutId,
                                                            ));
                                                          }
                                                          // else if (saveWorkoutResponse
                                                          //             .success ==
                                                          //         false &&
                                                          //     saveWorkoutResponse
                                                          //             .msg ==
                                                          //         "This Workout with Same exercise already exists") {
                                                          //   print(
                                                          //       'success true msg ==== ${resConflict.msg}');
                                                          //
                                                          //   print(
                                                          //       'isConflict status true  ==== ${controllerWork.isConflict}');
                                                          //
                                                          //   conflictWorkoutList =
                                                          //       resConflict.data!;
                                                          //
                                                          //   print(
                                                          //       'the data of conflict ${saveWorkoutResponse.data}');
                                                          //
                                                          //   print(
                                                          //       'warningmsg ==== ${warningmsg}');
                                                          //   warningmsg =
                                                          //       '${saveWorkoutResponse.msg}';
                                                          //
                                                          //   Get.showSnackbar(
                                                          //       GetSnackBar(
                                                          //     message:
                                                          //         '$warningmsg',
                                                          //     duration: Duration(
                                                          //         seconds: 2),
                                                          //     backgroundColor:
                                                          //         ColorUtils.kRed,
                                                          //   ));
                                                          //
                                                          //   // controllerWork
                                                          //   //     .changeConflict(
                                                          //   //         true);
                                                          // }
                                                        } else if (saveWorkoutController
                                                                .apiResponse
                                                                .status ==
                                                            Status.ERROR) {
                                                          Get.showSnackbar(
                                                              GetSnackBar(
                                                            message:
                                                                'Something went wrong!!!',
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ));
                                                        }
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: Get.height * .06,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors:
                                                              ColorUtilsGradient
                                                                  .kTintGradient,
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .topCenter),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Get.height * .1)),
                                                  child: Text('Start Program',
                                                      style: FontTextStyle
                                                          .kBlack20BoldRoboto),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GetBuilder<
                                        WorkoutExerciseConflictViewModel>(
                                      builder: (controller) {
                                        if (controller.apiResponse.status ==
                                            Status.LOADING) {
                                          return Container(
                                            height: Get.height,
                                            width: Get.width,
                                            color: Colors.black54,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  color: ColorUtils.kTint),
                                            ),
                                          );
                                        }
                                        return SizedBox();
                                      },
                                    ),
                                    GetBuilder<RemoveWorkoutProgramViewModel>(
                                      builder: (controller) {
                                        if (controller.apiResponse.status ==
                                            Status.LOADING) {
                                          return Container(
                                            height: Get.height,
                                            width: Get.width,
                                            color: Colors.black54,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  color: ColorUtils.kTint),
                                            ),
                                          );
                                        }
                                        return SizedBox();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: noDataLottie(),
                            ));
                          }
                        })
                      : Center(
                          child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: noDataLottie(),
                        )),
                );
              } else {
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
                      title: Text('Setup Program',
                          style: FontTextStyle.kWhite16BoldRoboto),
                      centerTitle: true,
                    ),
                    body: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: noDataLottie(),
                    )));
              }
            });
          } else {
            return Center(
              child: noDataLottie(),
            );
          }
        },
      ),
    );
  }
}
