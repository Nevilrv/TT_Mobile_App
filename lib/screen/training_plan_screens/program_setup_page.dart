import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/request_model/training_plan_request_model/save_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
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
  // DateTime _focusedDay = DateTime.now();

  // CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime? _selectedDay;

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
  bool keepExercise = true;

  DayBasedExerciseViewModel _dayBasedExerciseViewModel =
      Get.put(DayBasedExerciseViewModel());

  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());

  WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());

  SaveWorkoutProgramViewModel _saveWorkoutProgramViewModel =
      Get.put(SaveWorkoutProgramViewModel());

  WorkoutExerciseConflictViewModel _workoutExerciseConflictViewModel =
      Get.put(WorkoutExerciseConflictViewModel());

  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();

  @override
  void initState() {
    super.initState();
    _workoutByIdViewModel.dayAddedList.clear();
    // print('workout id ------------------ ${widget.workoutId}');
    // print('exerciseId id ------------------ ${widget.exerciseId}');
    // print('day ------------------ ${widget.day}');

    _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.workoutId);
    _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails();

    widget.exerciseId != null && widget.day == null
        ? _exerciseByIdViewModel.getExerciseByIdDetails(id: widget.exerciseId)
        : callApi();
    // _selectedDay = _focusedDay;

    // log('DAY FROM API $dayAddedList');
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

  bool isSelected = false;
  bool _switchValue = true;
  // List<String> dayAddedList = [];
  List apiDayAddedList = [];
  // List<int> weekDay = [];

  // week() {
  //   DateTime startDate = DateTime.now();
  //   DateTime endDate =
  //       DateTime(startDate.year, startDate.month, startDate.day + 7);
  //   List<DateTime> days = [];
  //   DateTime tmp = DateTime(startDate.year, startDate.month, startDate.day);
  //   while (DateTime(tmp.year, tmp.month, tmp.day) != endDate) {
  //     if (tmp.weekday == 1) {
  //       days.add(DateTime(tmp.year, tmp.month, tmp.day));
  //     }
  //     tmp = tmp.add(new Duration(days: 1));
  //   }
  //   log('days list --------- $days');
  //   log('temp date -------------  $tmp');
  // }
  List<DateTime> defSelectedList = [];
  List saveDay = [];
  setAllDat() {
    saveDay.forEach((element) {
      setDay(index: element);
    });
  }

  setDay({required int index}) {
    startIndex = 0;
    showList1 = [];
    if (addList['day$index'] == index) {
      addList['day$index'] = '';
      showList.remove(index);
    } else {
      addList['day$index'] = index;
      showList.add(index);
    }
    // log('listview add list ----- ${addList.toString()}');
    // log('listview show list ----- ${showList.toString()}');

    showList = List.generate(showList.length, (index) => index++);
    // log('DATA:-$addList');
    // log('addList gen :-$showList');

    addList.forEach((key, value) {
      if (value == '') {
        showList1.add(9);
      } else {
        showList1.add(showList[startIndex]);
        startIndex = startIndex + 1;
      }
    });
    // log('----show list 1 $showList1');

    if (_workoutByIdViewModel.dayAddedList
        .contains('${AppText.weekDays[index]}')) {
      _workoutByIdViewModel.dayAddedList.remove('${AppText.weekDays[index]}');
    } else {
      _workoutByIdViewModel.dayAddedList.add('${AppText.weekDays[index]}');
    }
    // log('111111111111111 ----show day list ${_workoutByIdViewModel.dayAddedList}');
  }

  updateWithSelection({required int weekLength}) {
    if (_workoutByIdViewModel.apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      DateTime todayDate = DateTime.now();
      List weekDay = [];

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

      print('days week number ------------------  $weekDay');
      print(
          '----------------- ${weekDay.reduce((curr, next) => curr < next ? curr : next)}');

      for (int week = 1; week <= weekLength; week++) {
        DateTime endDate =
            DateTime(todayDate.year, todayDate.month, todayDate.day + 7 * week);
        List<DateTime> days = [];

        DateTime tmp = DateTime(todayDate.year, todayDate.month, todayDate.day);
        while (DateTime(tmp.year, tmp.month, tmp.day) != endDate) {
          for (int apiDay = 0; apiDay < weekDay.length; apiDay++) {
            if (tmp.weekday == weekDay[apiDay]) {
              days.add(DateTime(tmp.year, tmp.month, tmp.day));
            }
          }
          tmp = tmp.add(new Duration(days: 1));
        }
        // log('days list --------- $days');
        // log('temp date -------------  $tmp');

        defSelectedList = days;
        // log('find week number +++++  ----- ${todayDate}');
        print('defSelectedList list --------- $defSelectedList');
      }
    }
  }

  multiSelectionDay() {
    // log('now time ----------- ${todayDate.weekday}');
    // todayDate.add(Duration(days: 7, hours: 23));
    // log('find week number ----- ${todayDate}');

    if (_workoutByIdViewModel.apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      WorkoutByIdResponseModel res = _workoutByIdViewModel.apiResponse.data;

      String daysFromApi = '${res.data![0].selectedDays!}';
      List<String> listOfDaysFromApi = daysFromApi.split(",");

      listOfDaysFromApi.forEach((element) {
        if (element == 'Monday') {
          saveDay.add(0);
        } else if (element == 'Tuesday') {
          saveDay.add(1);
        } else if (element == 'Wednesday') {
          saveDay.add(2);
        } else if (element == 'Thursday') {
          saveDay.add(3);
        } else if (element == 'Friday') {
          saveDay.add(4);
        } else if (element == 'Saturday') {
          saveDay.add(5);
        } else if (element == 'Sunday') {
          saveDay.add(6);
        }
      });
      setAllDat();
      _workoutByIdViewModel.dayAddedList = listOfDaysFromApi;

      print(
          'dayAddedList list api list added --------- ${_workoutByIdViewModel.dayAddedList}');
      print('days from api ------------------  $listOfDaysFromApi');

      updateWithSelection(weekLength: res.data![0].daysAllData!.length);
    }
  }

  @override
  void dispose() {
    _workoutByIdViewModel.isCallOneTime = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loader = false;

    List finalDateSelectedList = [];
    defSelectedList.forEach((element) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(element);
      finalDateSelectedList.add(formatted);
    });

    String finalDateSelectedString = finalDateSelectedList.join(",");

    print("final string of dates $finalDateSelectedString");

    return GetBuilder<DayBasedExerciseViewModel>(
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

                        if (controllerWork.apiResponse.status == Status.ERROR) {
                          return Center(
                            child: noDataLottie(),
                          );
                        }
                        if (controllerWork.apiResponse.status ==
                            Status.COMPLETE) {
                          WorkoutByIdResponseModel workResponse =
                              controllerWork.apiResponse.data;

                          // for (int i = 0;
                          //     i <
                          //         workResponse
                          //             .data![0].daysAllData![0].days!.length;
                          //     i++) {
                          //   apiDayAddedList.add(
                          //       '${workResponse.data![0].daysAllData![0].days![i].day.toString()}');
                          // }

                          String finalDayList =
                              _workoutByIdViewModel.dayAddedList.join(",");
                          // log('finalDayList -------------- $finalDayList');
                          // log('selectedDayList -------------- ${_selectedDay.toString()}');

                          return GetBuilder<SaveWorkoutProgramViewModel>(
                            builder: (saveWorkoutController) {
                              if (_workoutByIdViewModel.isCallOneTime) {
                                multiSelectionDay();
                              }
                              _workoutByIdViewModel.isCallOneTime = false;

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

                                print('start date ======= $endDate');

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

                                print('start date ======= $startDate');

                                return startDate;
                              }

                              String daysFromApi =
                                  '${workResponse.data![0].selectedDays!}';
                              List<String> listOfDaysFromApi =
                                  daysFromApi.split(",");
                              print(
                                  'list of days from api element ${listOfDaysFromApi}');
                              // endDate(defSelectedList);
                              // startDate(defSelectedList);

                              return SingleChildScrollView(
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
                                          SizedBox(height: Get.height * 0.01),
                                          Text(
                                            '${workResponse.data![0].workoutDuration} days a week',
                                            style: FontTextStyle
                                                .kLightGray16W300Roboto,
                                          ),
                                          SizedBox(height: Get.height * 0.04),
                                          Text(
                                            'What days do you want to workout?',
                                            style: FontTextStyle
                                                .kWhite16BoldRoboto,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.05,
                                              vertical: Get.height * 0.045),
                                          child: Container(
                                            height: Get.height * 0.61,
                                            width: Get.width,
                                            child: ListView.separated(
                                                separatorBuilder: (_, index) {
                                                  return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  Get.height *
                                                                      0.01));
                                                },
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    AppText.weekDays.length,
                                                itemBuilder: (_, index) {
                                                  // log('day added from api -------$dayAddedList ');

                                                  return InkWell(
                                                    onTap: () {
                                                      startIndex = 0;
                                                      showList1 = [];
                                                      if (addList[
                                                              'day$index'] ==
                                                          index) {
                                                        addList['day$index'] =
                                                            '';
                                                        showList.remove(index);
                                                      } else {
                                                        addList['day$index'] =
                                                            index;
                                                        showList.add(index);
                                                      }

                                                      showList = List.generate(
                                                          showList.length,
                                                          (index) => index++);

                                                      addList.forEach(
                                                          (key, value) {
                                                        if (value == '') {
                                                          showList1.add(9);
                                                        } else {
                                                          showList1.add(
                                                              showList[
                                                                  startIndex]);
                                                          startIndex =
                                                              startIndex + 1;
                                                        }
                                                      });
                                                      _workoutByIdViewModel
                                                          .setAndRemove(
                                                              keyValue:
                                                                  '${AppText.weekDays[index]}');
                                                      // multiSelectionDay();
                                                      updateWithSelection(
                                                          weekLength:
                                                              workResponse
                                                                  .data![0]
                                                                  .daysAllData!
                                                                  .length);
                                                      // setState(() {});
                                                      _dateRangePickerController
                                                              .selectedDates =
                                                          defSelectedList;

                                                      print(
                                                          '------------- days 123 $defSelectedList');

                                                      log('----show day list ${_workoutByIdViewModel.dayAddedList}');
                                                    },
                                                    child: Container(
                                                      height:
                                                          Get.height * 0.065,
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
                                                          color:
                                                              _workoutByIdViewModel.dayAddedList.contains(AppText.weekDays[index])
                                                                  ? null
                                                                  : ColorUtils
                                                                      .kBlack,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  Get.height *
                                                                      0.1),
                                                          border: _workoutByIdViewModel
                                                                  .dayAddedList
                                                                  .contains(AppText.weekDays[index])
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
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  Get.height *
                                                                      0.05,
                                                              width:
                                                                  Get.height *
                                                                      0.05,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      ColorUtils
                                                                          .kBlack,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              // child:
                                                              // Text(
                                                              //   '${addList['day$index'] == index ? showList1[index] + 1 : ''}',
                                                              //   style: FontTextStyle.kTint20BoldRoboto,
                                                              // ),
                                                              child: Text(
                                                                '${addList['day$index'] == index ? showList1[index] + 1 : ''}',
                                                                style: FontTextStyle
                                                                    .kTint20BoldRoboto,
                                                              ),
                                                            ),
                                                            Text(
                                                                AppText.weekDays[
                                                                    index],
                                                                style: _workoutByIdViewModel
                                                                        .dayAddedList
                                                                        .contains(AppText.weekDays[
                                                                            index])
                                                                    ? FontTextStyle
                                                                        .kBlack20BoldRoboto
                                                                    : FontTextStyle
                                                                        .kTint20BoldRoboto),
                                                            _workoutByIdViewModel
                                                                    .dayAddedList
                                                                    .contains(AppText
                                                                            .weekDays[
                                                                        index])
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height:
                                                                        Get.height *
                                                                            0.05,
                                                                    width:
                                                                        Get.height *
                                                                            0.05,
                                                                    decoration: BoxDecoration(
                                                                        color: ColorUtils
                                                                            .kBlack,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child: Text(
                                                                        'Rec.',
                                                                        style: FontTextStyle
                                                                            .kTint12BoldRoboto),
                                                                  )
                                                                : SizedBox(
                                                                    height:
                                                                        Get.height *
                                                                            0.05,
                                                                    width:
                                                                        Get.height *
                                                                            0.05,
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
                                        child: SfDateRangePicker(
                                          view: DateRangePickerView.month,
                                          showNavigationArrow: true,
                                          controller:
                                              _dateRangePickerController,
                                          initialDisplayDate: DateTime.now(),
                                          todayHighlightColor: ColorUtils.kTint,
                                          selectionRadius: 15,
                                          selectionColor: ColorUtils.kTint,
                                          minDate: DateTime.utc(2018, 01, 01),
                                          maxDate: DateTime.utc(2030, 12, 31),
                                          selectionTextStyle:
                                              FontTextStyle.kBlack18w600Roboto,

                                          // cellBuilder: (BuildContext context,
                                          //     DateRangePickerCellDetails
                                          //         details) {
                                          //   return Container(
                                          //     margin: EdgeInsets.all(2),
                                          //     padding: EdgeInsets.only(top: 10),
                                          //   );
                                          // },
                                          monthCellStyle:
                                              DateRangePickerMonthCellStyle(
                                            textStyle: FontTextStyle
                                                .kWhite17W400Roboto,
                                            todayTextStyle: FontTextStyle
                                                .kWhite17W400Roboto,
                                          ),
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .multiple,
                                          initialSelectedDates: defSelectedList,

                                          onSelectionChanged:
                                              (DateRangePickerSelectionChangedArgs
                                                  args) {
                                            log('date args ----- ${args.value.toString()}');
                                            // defSelectedList.add(args.value);
                                            // setState(() {});
                                          },
                                          monthViewSettings:
                                              DateRangePickerMonthViewSettings(
                                            firstDayOfWeek: 1,
                                            dayFormat: 'EEE',

                                            // viewHeaderHeight: 50,
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
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: Get.height * .02,
                                      //       horizontal: Get.width * .03),
                                      //   child: TableCalendar(
                                      //     calendarStyle: CalendarStyle(
                                      //         markerSize: 0,
                                      //         outsideDaysVisible: false,
                                      //         weekendTextStyle: FontTextStyle
                                      //             .kWhite17W400Roboto,
                                      //         defaultTextStyle: FontTextStyle
                                      //             .kWhite17W400Roboto,
                                      //         selectedTextStyle: FontTextStyle
                                      //             .kBlack18w600Roboto,
                                      //         selectedDecoration: BoxDecoration(
                                      //             color: ColorUtils.kTint,
                                      //             shape: BoxShape.circle),
                                      //         todayTextStyle: FontTextStyle
                                      //             .kWhite17W400Roboto,
                                      //         todayDecoration: BoxDecoration(
                                      //           color: Colors.transparent,
                                      //         )),
                                      //     daysOfWeekHeight: Get.height * .05,
                                      //     // daysOfWeekStyle: DaysOfWeekStyle(
                                      //     //     weekdayStyle: FontTextStyle
                                      //     //         .kWhite17W400Roboto,
                                      //     //     weekendStyle: FontTextStyle
                                      //     //         .kWhite17W400Roboto),
                                      //     // headerStyle: HeaderStyle(
                                      //     //   titleTextStyle: FontTextStyle
                                      //     //       .kWhite20BoldRoboto,
                                      //     //   leftChevronIcon: Icon(
                                      //     //     Icons.arrow_back_ios_sharp,
                                      //     //     color: ColorUtils.kTint,
                                      //     //     size: Get.height * .025,
                                      //     //   ),
                                      //     //   rightChevronIcon: Icon(
                                      //     //     Icons.arrow_forward_ios_sharp,
                                      //     //     color: ColorUtils.kTint,
                                      //     //     size: Get.height * .025,
                                      //     //   ),
                                      //     //   formatButtonVisible: false,
                                      //     //   titleCentered: true,
                                      //     // ),
                                      //     // rangeSelectionMode:
                                      //     //     RangeSelectionMode.enforced,
                                      //     // rangeStartDay: _focusedDay,
                                      //     rangeEndDay: DateTime.now(),
                                      //     onRangeSelected: (start, end, idk) {
                                      //       // log('range ------ start $start ==== end $end === idk $idk');
                                      //     },
                                      //     // availableGestures:
                                      //     //     AvailableGestures.horizontalSwipe,
                                      //     // startingDayOfWeek:
                                      //     // StartingDayOfWeek.monday,
                                      //     // focusedDay: _focusedDay,
                                      //     firstDay: DateTime.utc(2018, 01, 01),
                                      //     lastDay: DateTime.utc(2030, 12, 31),
                                      //     // calendarFormat: _calendarFormat,
                                      //     onFormatChanged: (format) {
                                      //       // if (_calendarFormat != format) {
                                      //       //   setState(() {
                                      //       //     _calendarFormat = format;
                                      //       //   });
                                      //       // }
                                      //     },
                                      //     // selectedDayPredicate: (day) {
                                      //     //   // log('_selectedDay --- $_selectedDay === day --- $day ');
                                      //     //
                                      //     //   // return isSameDay(_selectedDay, day);
                                      //     // },
                                      //     onDaySelected:
                                      //         (selectedDay, focusedDay) {
                                      //       // if (!isSameDay(
                                      //       //     _selectedDay, selectedDay)) {
                                      //       //   // log('selectedDay --- $selectedDay === _selectedDay $_selectedDay');
                                      //       //
                                      //       //   setState(() {
                                      //       //     // _selectedDay = selectedDay;
                                      //       //     // _focusedDay = focusedDay;
                                      //       //   });
                                      //       // }
                                      //     },
                                      //     onPageChanged: (focusedDay) {
                                      //       // _focusedDay = focusedDay;
                                      //       // log('focusedDay --- $focusedDay');
                                      //     },
                                      //     focusedDay: DateTime.now(),
                                      //   ),
                                      // ),
                                      keepExercise
                                          ? Column(children: [
                                              Divider(
                                                color: ColorUtils.kGray,
                                                thickness: 2,
                                                height: Get.height * .09,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: Get.height * .03),
                                                alignment: Alignment.center,
                                                height: Get.height * .045,
                                                width: Get.width * .27,
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.kRed,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                child: Text(
                                                  'WARNING',
                                                  style: FontTextStyle
                                                      .kWhite17BoldRoboto,
                                                ),
                                              ),
                                              Text(
                                                AppText.warning,
                                                style: FontTextStyle
                                                    .kWhite16BoldRoboto,
                                                maxLines: 2,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: Get.height * .02),
                                                child: Text(
                                                  AppText.powerLifting,
                                                  style: FontTextStyle
                                                      .kWhite20BoldRoboto,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        keepExercise = false;
                                                      });
                                                      print('Keep Pressed');
                                                      print(
                                                          'keep $keepExercise');
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: Get.height * .05,
                                                      width: Get.width * .3,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  40),
                                                          gradient: LinearGradient(
                                                              colors: ColorUtilsGradient
                                                                  .kTintGradient,
                                                              begin: Alignment
                                                                  .center,
                                                              end: Alignment
                                                                  .center)),
                                                      child: Text(
                                                        'Keep',
                                                        style: FontTextStyle
                                                            .kBlack18w600Roboto,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: Get.width * .05),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                      print('Remove pressed');
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: Get.height * .05,
                                                      width: Get.width * .3,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          border: Border.all(
                                                              color: ColorUtils
                                                                  .kTint,
                                                              width: 1.5)),
                                                      child: Text(
                                                        'Remove',
                                                        style: FontTextStyle
                                                            .kTine17BoldRoboto,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ])
                                          : SizedBox(),
                                      Divider(
                                        color: ColorUtils.kGray,
                                        thickness: 2,
                                        height: Get.height * 0.1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(AppText.getByEmail,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Get.height * .02)),
                                          Spacer(),
                                          CupertinoSwitch(
                                            activeColor: ColorUtils.kTint,
                                            value: _switchValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _switchValue = value;
                                              });
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
                                            // Get.to(WorkoutHomeScreen(
                                            //   data: response.data!,
                                            //   workoutId: widget.workoutId,
                                            // ));
                                            // log('Start Program pressed');

                                            await _workoutExerciseConflictViewModel
                                                .getWorkoutExerciseConflictDetails(
                                                    date: startDate(
                                                        defSelectedList));

                                            if (_workoutExerciseConflictViewModel
                                                    .apiResponse.status ==
                                                Status.COMPLETE) {
                                              WorkoutExerciseConflictResponseModel
                                                  res =
                                                  _workoutExerciseConflictViewModel
                                                      .apiResponse.data;
                                              if (res.success == true) {
                                                setState(() {
                                                  loader = true;
                                                });

                                                if (controllerWork.apiResponse
                                                            .status !=
                                                        Status.LOADING ||
                                                    controllerWork.apiResponse
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
                                                          .data![0].workoutId;
                                                  _request.exerciseId = response
                                                      .data![0].exerciseId;

                                                  _request.startDate =
                                                      startDate(
                                                          defSelectedList);
                                                  _request.endDate =
                                                      endDate(defSelectedList);
                                                  _request.selectedWeekDays =
                                                      finalDayList;
                                                  _request.selectedDates =
                                                      finalDateSelectedString;

                                                  await saveWorkoutController
                                                      .saveWorkoutProgramViewModel(
                                                          _request);

                                                  // log('=====saveWorkoutViewModel.apiResponse.status===========${saveWorkoutController.apiResponse.status}');
                                                  if (saveWorkoutController
                                                          .apiResponse.status ==
                                                      Status.COMPLETE) {
                                                    SaveWorkoutProgramResponseModel
                                                        saveWorkoutResponse =
                                                        saveWorkoutController
                                                            .apiResponse.data;
                                                    // log('================$loader');
                                                    setState(() {
                                                      loader = false;
                                                    });

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
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ));
                                                      Get.to(WorkoutHomeScreen(
                                                        data: response.data!,
                                                        workoutId:
                                                            widget.workoutId,
                                                      ));
                                                    } else if (saveWorkoutResponse
                                                                .success ==
                                                            true &&
                                                        saveWorkoutResponse
                                                                .msg ==
                                                            null) {
                                                      setState(() {
                                                        loader = false;
                                                      });
                                                      // log("============ res null ${saveWorkoutResponse.msg}");
                                                      Get.showSnackbar(
                                                          GetSnackBar(
                                                        message:
                                                            '${saveWorkoutResponse.msg}',
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ));
                                                    }
                                                  } else if (saveWorkoutController
                                                          .apiResponse.status ==
                                                      Status.ERROR) {
                                                    setState(() {
                                                      loader = false;
                                                    });
                                                    Get.showSnackbar(
                                                        GetSnackBar(
                                                      message:
                                                          'Something went wrong!!!',
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ));
                                                  }
                                                }
                                              } else {
                                                Get.showSnackbar(GetSnackBar(
                                                  message: '${res.msg}',
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                              }
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: Get.height * .06,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: ColorUtilsGradient
                                                        .kTintGradient,
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.topCenter),
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
    );
  }
}
