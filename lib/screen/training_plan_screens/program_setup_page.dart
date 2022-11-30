import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/request_model/training_plan_request_model/remove_workout_program_request_model.dart';
import 'package:tcm/model/request_model/training_plan_request_model/save_workout_program_request_model.dart';
import 'package:tcm/model/response_model/schedule_response_model/schedule_by_date_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/remove_workout_program_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/save_workout_program_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/repo/workout_repo/user_workouts_date_repo.dart';
import 'package:tcm/screen/New/workout_home_new.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/day_based_exercise_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/remove_workout_program_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_workout_program_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/workout_exercise_conflict_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';

class ProgramSetupPage extends StatefulWidget {
  final String? exerciseId;
  final String? day;
  final String? workoutId;
  final List<ProgramSchedule>? programData;
  bool? isEdit;
  final String? workoutProgramId;

  final String? workoutName;
  ProgramSetupPage(
      {Key? key,
      this.exerciseId,
      this.workoutId,
      this.day,
      this.workoutName,
      this.programData,
      this.isEdit,
      this.workoutProgramId})
      : super(key: key);
  @override
  State<ProgramSetupPage> createState() => _ProgramSetupPageState();
}

class _ProgramSetupPageState extends State<ProgramSetupPage> {
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
  bool changeDate=true;
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
  List duplicateDayData = [];
  DayBasedExerciseViewModel _dayBasedExerciseViewModel =
      Get.put(DayBasedExerciseViewModel());

  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());
 /* SaveWorkoutProgramViewModel _saveWorkoutProgramViewModel =
      Get.put(SaveWorkoutProgramViewModel());*/
  WorkoutExerciseConflictViewModel _workoutExerciseConflictViewModel =
      Get.put(WorkoutExerciseConflictViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  RemoveWorkoutProgramViewModel _removeWorkoutProgramViewModel =
      Get.put(RemoveWorkoutProgramViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();
    data.clear();
    selectedDay.clear();
    // _workoutByIdViewModel.defSelectedList.clear();
    // gh();
    workout();
    conflig();
    if (widget.isEdit == null) widget.isEdit = false;
    widget.exerciseId != null && widget.day == null
        ? _exerciseByIdViewModel.getExerciseByIdDetails(id: widget.exerciseId)
        : callApi();
  }
Future<void> workout() async {
 await _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.workoutId);
}
Future<void> conflig()
async {
 await  _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails();
}
  /*gh()async{
    await _workoutByIdViewModel.getWorkoutByIdDetails(id: widget.workoutId);

    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      WorkoutByIdResponseModel res = _workoutByIdViewModel.apiResponse.data;

        updateWithSelection(
            weekLength: res.data![0].daysAllData!.length,
            startDate: DateTime.now());
    }
  }*/

  callApi() async {
    await _dayBasedExerciseViewModel.getDayBasedExerciseDetails(
        id: widget.workoutId, day: widget.day);
    if (_dayBasedExerciseViewModel.apiResponse.status == Status.COMPLETE) {
      DayBasedExerciseResponseModel responseDayBased =
          _dayBasedExerciseViewModel.apiResponse.data;
      print(
          'responseDayBased.data![0].exercises![0].exerciseId ${responseDayBased.data}');
      if (responseDayBased.data!.isEmpty) {
      } else {
        await _exerciseByIdViewModel.getExerciseByIdDetails(
            id: responseDayBased.data![0].exercises![0].exerciseId);
      }
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

  Map<String, dynamic> addList = {
    'day0': '',
    'day1': '',
    'day2': '',
    'day3': '',
    'day4': '',
    'day5': '',
    'day6': '',
  };

  updateWithSelection({required int weekLength, required DateTime startDate}) {

    if (_workoutByIdViewModel.apiResponse.status == Status.LOADING) {
    return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {

      DateTime todayDate = startDate == null ? DateTime.now() : startDate;
      List<int> weekDay = [];
      print("start date ------------- $startDate");
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
        _workoutByIdViewModel.defSelectedList.clear();
        _workoutByIdViewModel
            .dateRangePickerController
            .selectedDates?.clear();
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

        /*_workoutByIdViewModel.defSelectedList = days;*/

        _workoutByIdViewModel.listUpdate(value: days);
        if(changeDate==true){
          _workoutByIdViewModel
              .dateRangePickerController
              .selectedDates=_workoutByIdViewModel.defSelectedList;

        }


        print('defselected list ><< ${_workoutByIdViewModel.defSelectedList}');

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

      String? daysFromApi;

      if (widget.isEdit == true) {
        daysFromApi = '${widget.programData![0].selectedWeekDays}';
      } else {
        daysFromApi = '${res.data![0].selectedDays!}';
      }
      List<String> listOfDaysFromApi = daysFromApi.split(",");
      print('>>listOfDaysFromApi >>> $listOfDaysFromApi');
      if (_workoutByIdViewModel.callOneTimeApiCall == true) {
        _workoutByIdViewModel.dayAddedList = listOfDaysFromApi;
        setNumber();
      }
      _workoutByIdViewModel.callOneTimeApiCall = false;

      print('user selected date ----------------- $userSelectedDate');

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

   /* if (_workoutByIdViewModel.apiResponse.status == Status.COMPLETE) {
      WorkoutByIdResponseModel res = _workoutByIdViewModel.apiResponse.data;
      updateWithSelection(
          weekLength: res.data![0].daysAllData!.length,
          startDate: DateTime.now());
    }*/
  /*  WidgetsBinding.instance?.addPostFrameCallback((_) {
      duplicateDayData = _workoutByIdViewModel.defSelectedList;
      print('duplicateDayData >>>> $duplicateDayData');
    });*/
    print("print is edit ------------------- ${widget.isEdit}");

    DateTime initialDisplayDate;
    if (widget.isEdit == true) {
      initialDisplayDate =
          DateTime.parse('${widget.programData![0].programStartDate}');
      print("initial display date $initialDisplayDate");
    } else {
      initialDisplayDate = DateTime.now();
    }
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        print("hello ${details.localPosition}");
        print("hello ${details.localPosition.dx}");
        print("hello ${details.globalPosition.distance}");

        if (details.localPosition.dx < 50.0) {
          //SWIPE FROM RIGHT DETECTION
          print("hello ");
          _workoutByIdViewModel.callOneTimeApiCall = true;
          _workoutByIdViewModel.dateRangePickerController.selectedDates!
              .clear();
          _workoutByIdViewModel.changeConflict(false);
          Get.back();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          _workoutByIdViewModel.callOneTimeApiCall = true;
          _workoutByIdViewModel.dateRangePickerController.selectedDates!
              .clear();
          _workoutByIdViewModel.changeConflict(false);
          return Future.value(true);
        },
        child: GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
          return control.isOnline
              ? GetBuilder<DayBasedExerciseViewModel>(
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
                  child: Text(
                    'Server error',
                    style: FontTextStyle.kTine17BoldRoboto,
                  ),
                );
              }
              if (controller.apiResponse.status == Status.COMPLETE) {
                return GetBuilder<ExerciseByIdViewModel>(
                    builder: (controllerExe) {
                      if (controllerExe.apiResponse.status ==
                          Status.LOADING) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorUtils.kTint,
                          ),
                        );
                      }
                      if (controllerExe.apiResponse.status == Status.ERROR) {
                        return Center(
                          child: Text(
                            'Server error',
                            style: FontTextStyle.kTine17BoldRoboto,
                          ),
                        );
                      }
                      if (controllerExe.apiResponse.status ==
                          Status.COMPLETE) {
                        ExerciseByIdResponseModel response =
                            controllerExe.apiResponse.data;
                        return Scaffold(
                          backgroundColor: ColorUtils.kBlack,
                          appBar: AppBar(
                            elevation: 0,
                            leading: IconButton(
                                onPressed: () {
                                  Get.back();
                                  _workoutByIdViewModel.callOneTimeApiCall =
                                  true;
                                  _workoutByIdViewModel
                                      .dateRangePickerController
                                      .selectedDates!
                                      .clear();
                                  _workoutByIdViewModel.changeConflict(false);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: ColorUtils.kTint,
                                )),
                            backgroundColor: ColorUtils.kBlack,
                            title: !widget.isEdit!
                                ? Text('Setup Program',
                                style: FontTextStyle.kWhite16BoldRoboto)
                                : Text('Edit Program',
                                style: FontTextStyle.kWhite16BoldRoboto),
                            centerTitle: true,
                          ),
                          body:
                          response.data!.isNotEmpty && response.data != []
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
                                    child: Text(
                                      'Server error',
                                      style: FontTextStyle
                                          .kTine17BoldRoboto,
                                    ),
                                  );
                                }
                                if (controllerWork.apiResponse.status ==
                                    Status.COMPLETE) {
                                  WorkoutByIdResponseModel
                                  workResponse =
                                      controllerWork.apiResponse.data;

                                  List daysPerWeekCount = workResponse
                                      .data![0].selectedDays!
                                      .split(",");

                                  String finalDayString = controllerWork
                                      .dayAddedList
                                      .join(",");
                                  print(
                                      'finalDayList ----------------- $finalDayString');
                                  String apiDayDataString = workResponse
                                      .data![0].selectedDays!;
                                  List tmpList =
                                  apiDayDataString.split(",");
                                  for (int i = 0;
                                  i < tmpList.length;
                                  i++) {
                                    if (apiDayDataList.contains(i)) {
                                      apiDayDataList.remove(i);
                                      apiDayDataList.add(tmpList[i]);
                                    }
                                  }
                                  print(
                                      'apiDayDataList ------------- $apiDayDataList');
                                  return GetBuilder<
                                      SaveWorkoutProgramViewModel>(
                                    builder: (saveWorkoutController) {
                                      if (controllerWork
                                          .isCallOneTime) {
                                        if (widget.isEdit == true) {
                                          dateByUser = DateTime.parse(
                                              '${widget.programData![0].programStartDate}');
                                        }
                                        multiSelectionDay(
                                            userSelectedDate:
                                            dateByUser == null
                                                ? DateTime.now()
                                                : dateByUser!);
                                      }
                                      controllerWork.isCallOneTime =
                                      false;
                                      String endDate(
                                          List<DateTime> dates) {
                                        DateTime maxDate = dates[0];
                                        dates.forEach((date) {
                                          if (date.isAfter(maxDate)) {
                                            maxDate = date;
                                          }
                                        });
                                        final DateFormat formatter =
                                        DateFormat('yyyy-MM-dd');
                                        String endDate =
                                        formatter.format(maxDate);

                                        return endDate;
                                      }

                                      String startDate(
                                          List<DateTime> dates) {
                                        DateTime minDate = dates[0];
                                        dates.forEach((date) {
                                          if (date.isBefore(minDate)) {
                                            minDate = date;
                                          }
                                        });
                                        final DateFormat formatter =
                                        DateFormat('yyyy-MM-dd');
                                        String startDate =
                                        formatter.format(minDate);

                                        return startDate;
                                      }

                                      String daysFromApi =
                                          '${workResponse.data![0].selectedDays!}';
                                      List<String> listOfDaysFromApi =
                                      daysFromApi.split(",");
                                      _workoutByIdViewModel
                                          .apiDayLength =
                                          listOfDaysFromApi.length;
                                      if (controllerWork.calendarTap ==
                                          true) {
                                        controllerWork
                                            .setDateController(
                                            controllerWork
                                                .defSelectedList);

                                        controllerWork
                                            .changeCalendar(false);
                                      }
                                      return Stack(
                                        children: [
                                          SingleChildScrollView(
                                            physics:
                                            BouncingScrollPhysics(),
                                            child: Padding(
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal: Get
                                                      .width *
                                                      0.06,
                                                  vertical:
                                                  Get.height *
                                                      0.025),
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
                                                          height:
                                                          Get.height *
                                                              0.01),
                                                      Text(
                                                        '${daysPerWeekCount.length} days a week',
                                                        style: FontTextStyle
                                                            .kLightGray16W300Roboto,
                                                      ),
                                                      SizedBox(
                                                          height:
                                                          Get.height *
                                                              0.04),
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
                                                          Get.width *
                                                              0.05,
                                                          vertical:
                                                          Get.height *
                                                              0.045),
                                                      child: Container(
                                                        height:
                                                        Get.height *
                                                            0.61,
                                                        width:
                                                        Get.width,
                                                        child: ListView
                                                            .separated(
                                                            separatorBuilder:
                                                                (_,
                                                                index) {
                                                              return Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01));
                                                            },
                                                            physics:
                                                            NeverScrollableScrollPhysics(),
                                                            shrinkWrap:
                                                            true,
                                                            itemCount: AppText
                                                                .weekDays
                                                                .length,
                                                            itemBuilder:
                                                                (_, index) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                    setState(() {
                                                                      changeDate=false;
                                                                    });
                                                                  _workoutByIdViewModel.setDayAddedList(value: '${AppText.weekDays[index]}');
                                                                  updateWithSelection(weekLength: workResponse.data![0].daysAllData!.length, startDate: dateByUser == null ? DateTime.now() : dateByUser!);
                                                                  controllerWork.setDateController(controllerWork.defSelectedList);

                                                                  log('_workoutByIdViewModel.dayAddedList[0]  ${_workoutByIdViewModel.dayAddedList}');
                                                                  setNumber();
                                                                  log('DATA>>>>>$data');

                                                                  await _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails(date: dateString(), userId: PreferenceManager.getUId());
                                                                  if (_workoutExerciseConflictViewModel.apiResponse.status == Status.COMPLETE) {
                                                                    WorkoutExerciseConflictResponseModel resConflict = _workoutExerciseConflictViewModel.apiResponse.data;

                                                                    if (resConflict.data != [] && resConflict.msg == "You are already following another program on these dates. Choose below if you want to follow them both.") {
                                                                      conflictWorkoutList = resConflict.data!;
                                                                      warningmsg = '${resConflict.msg}';

                                                                      print('-------------- msg${resConflict.msg}');

                                                                      print('conflict called on week days');

                                                                      controllerWork.changeConflict(true);
                                                                    } else {
                                                                      controllerWork.changeConflict(false);
                                                                    }
                                                                  }

                                                                  print('------------- days 123 ${_workoutByIdViewModel.defSelectedList}');

                                                                  log('----show day list ${_workoutByIdViewModel.dayAddedList}');
                                                                },
                                                                child:
                                                                Container(
                                                                  height: Get.height * 0.065,
                                                                  width: Get.width,
                                                                  decoration: BoxDecoration(
                                                                      gradient: _workoutByIdViewModel.dayAddedList.contains(AppText.weekDays[index])
                                                                          ? LinearGradient(
                                                                        begin: Alignment.topCenter,
                                                                        end: Alignment.bottomCenter,
                                                                        stops: [0.0, 1.0],
                                                                        colors: ColorUtilsGradient.kTintGradient,
                                                                      )
                                                                          : null,
                                                                      color: controllerWork.dayAddedList.contains(AppText.weekDays[index]) ? null : ColorUtils.kBlack,
                                                                      borderRadius: BorderRadius.circular(6),
                                                                      border: _workoutByIdViewModel.dayAddedList.contains(AppText.weekDays[index]) ? null : Border.all(color: ColorUtils.kTint)),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        data[index] == 0
                                                                            ? Container(
                                                                          height: Get.height * .05,
                                                                          width: Get.height * .05,
                                                                        )
                                                                            : Container(
                                                                          alignment: Alignment.center,
                                                                          height: Get.height * .05,
                                                                          width: Get.height * .05,
                                                                          decoration: BoxDecoration(color: ColorUtils.kBlack, shape: BoxShape.circle),
                                                                          child: Center(
                                                                            child: Text(
                                                                              data[index].toString(),
                                                                              style: FontTextStyle.kTint20BoldRoboto,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child: Text(AppText.weekDays[index], style: controllerWork.dayAddedList.contains(AppText.weekDays[index]) ? FontTextStyle.kBlack20BoldRoboto : FontTextStyle.kTint20BoldRoboto),
                                                                        ),
                                                                        /* apiDayDataList.contains(AppText.weekDays[index])
                                                                                        // &&
                                                                                        //     _workoutByIdViewModel
                                                                                        //         .dayAddedList
                                                                                        //         .contains(
                                                                                        //             AppText.weekDays[index])
                                                                                        ? Container(
                                                                                            alignment: Alignment.center,
                                                                                            height: Get.height * 0.05,
                                                                                            width: Get.height * 0.05,
                                                                                            decoration: BoxDecoration(color: ColorUtils.kBlack, shape: BoxShape.circle),
                                                                                            child: Text('Rec.', style: FontTextStyle.kTint12BoldRoboto),
                                                                                          )
                                                                                        :*/ SizedBox(
                                                                          height: Get.height * 0.05,
                                                                          width: Get.height * 0.05,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      )),
                                                  Divider(
                                                    color: ColorUtils
                                                        .kGray,
                                                    thickness: 2,
                                                    height: Get.height *
                                                        0.04,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top:
                                                        Get.height *
                                                            .02,
                                                        left:
                                                        Get.width *
                                                            .03,
                                                        right:
                                                        Get.width *
                                                            .03),
                                                    child: SizedBox(
                                                      height:
                                                      Get.height *
                                                          .55,
                                                      child:
                                                      SfDateRangePicker(
                                                        view:
                                                        DateRangePickerView
                                                            .month,
                                                        allowViewNavigation:
                                                        false,
                                                        showNavigationArrow:
                                                        true,
                                                        enablePastDates:
                                                        false,
                                                        controller:
                                                        controllerWork
                                                            .dateRangePickerController,

                                                        initialDisplayDate:
                                                        initialDisplayDate,

                                                        todayHighlightColor:
                                                        ColorUtils
                                                            .kTint,
                                                        selectionRadius:
                                                        17,
                                                        selectionColor:ColorUtils.kTint
                                                        // selectionColor:Colors.transparent

                                                        ,minDate:
                                                      DateTime.utc(
                                                          2019,
                                                          01,
                                                          01),
                                                        maxDate:
                                                        DateTime.utc(
                                                            2099,
                                                            12,
                                                            31),
                                                        selectionTextStyle:
                                                        FontTextStyle
                                                            .kBlack18w600Roboto,
                                                        enableMultiView:
                                                        false,
                                                        yearCellStyle: DateRangePickerYearCellStyle(
                                                            textStyle:
                                                            FontTextStyle
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
                                                              color:
                                                              Colors.transparent),
                                                          disabledDatesTextStyle:
                                                          FontTextStyle
                                                              .kLightGray16W300Roboto,
                                                          textStyle:
                                                          FontTextStyle
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
                                                    /*    cellBuilder: (BuildContext
                                                        context,
                                                            DateRangePickerCellDetails
                                                            details) {
                                                          return   Padding(
                                                            padding:
                                                            EdgeInsets.all(4),
                                                            child: Container(
                                                              alignment:
                                                              Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient: controllerWork
                                                                      .defSelectedList
                                                                      .contains(
                                                                      details
                                                                          .date)
                                                                      ? LinearGradient(
                                                                      colors: ColorUtilsGradient
                                                                          .kTintGradient,
                                                                      begin: Alignment.topCenter,
                                                                      end: Alignment.bottomCenter,
                                                                      stops: [
                                                                        0.0,
                                                                        0.7
                                                                      ])
                                                                      : LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .transparent,
                                                                        Colors
                                                                            .transparent
                                                                      ]),
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Text(
                                                                  details.date.day
                                                                      .toString(),
                                                                  style: controllerWork
                                                                      .defSelectedList
                                                                      .contains(
                                                                      details
                                                                          .date)
                                                                      ? FontTextStyle
                                                                      .kBlack18w600Roboto
                                                                      : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                                                      .isAfter(details
                                                                      .date)
                                                                      ? FontTextStyle
                                                                      .kGrey18BoldRoboto
                                                                      : FontTextStyle
                                                                      .kWhite17W400Roboto),
                                                            ),
                                                          );
                                                        },*/
                                                        onSelectionChanged:
                                                            (DateRangePickerSelectionChangedArgs
                                                        args) async {
                                                          print('day121s>>>> ${args.value.last}');
                                                          days = args
                                                              .value;
                                                          setState(() {
                                                            dateByUser =
                                                                days.last;
                                                          });
                                                          multiSelectionDay(
                                                              userSelectedDate:
                                                              dateByUser!);
                                                          controllerWork
                                                              .setDateController(
                                                              controllerWork
                                                                  .defSelectedList);
                                                          await _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails(
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

                                                            if (resConflict.data !=
                                                                [] &&
                                                                resConflict.msg ==
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
                                                            setState(() {

                                                            });
                                                          }
                                                        },
                                                        monthViewSettings:
                                                        DateRangePickerMonthViewSettings(
                                                          firstDayOfWeek:
                                                          1,
                                                          dayFormat:
                                                          'EEE',
                                                          viewHeaderStyle:
                                                          DateRangePickerViewHeaderStyle(
                                                              textStyle:
                                                              FontTextStyle.kWhite17W400Roboto),
                                                        ),
                                                        headerStyle:
                                                        DateRangePickerHeaderStyle(
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                          textStyle:
                                                          FontTextStyle
                                                              .kWhite20BoldRoboto,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  widget.isEdit ==
                                                      true
                                                      ? SizedBox()
                                                      : controllerWork
                                                      .isConflict
                                                      ? Column(
                                                    children: [
                                                      Divider(
                                                        color: ColorUtils
                                                            .kGray,
                                                        thickness:
                                                        2,
                                                        height:
                                                        Get.height *
                                                            .05,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(
                                                            vertical:
                                                            Get.height * .03),
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        height: Get
                                                            .height *
                                                            .045,
                                                        width: Get
                                                            .width *
                                                            .27,
                                                        decoration: BoxDecoration(
                                                            color: ColorUtils
                                                                .kRed,
                                                            borderRadius:
                                                            BorderRadius.circular(40)),
                                                        child:
                                                        Text(
                                                          'WARNING',
                                                          style: FontTextStyle
                                                              .kWhite17BoldRoboto,
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                          itemCount: conflictWorkoutList!.length,
                                                          shrinkWrap: true,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemBuilder: (_, index) {
                                                            return Column(
                                                                children: [
                                                                  conflictWorkoutList![index].workoutTitle! == widget.programData?[0].workoutTitle
                                                                      ? Text(
                                                                    'You are already following ${conflictWorkoutList![index].workoutTitle!} on this dates\nPlease select another dates',
                                                                    style: FontTextStyle.kWhite16BoldRoboto,
                                                                    textAlign: TextAlign.center,
                                                                  )
                                                                      : Text(
                                                                    warningmsg!,
                                                                    style: FontTextStyle.kWhite16BoldRoboto,
                                                                    maxLines: 2,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(vertical: Get.height * .02),
                                                                    child: Text(
                                                                      conflictWorkoutList![index].workoutTitle!,
                                                                      style: FontTextStyle.kWhite20BoldRoboto,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          UserWorkoutsDateResponseModel responseApi = await UserWorkoutsDateRepo().userWorkoutsDateRepo(date: DateTime.now().toString().split(' ').first, userId: PreferenceManager.getUId());
                                                                          try {
                                                                            _userWorkoutsDateViewModel.withWarmupExercisesList.clear();
                                                                            _userWorkoutsDateViewModel.withWarmupExercisesList.clear();
                                                                            _userWorkoutsDateViewModel.superSetList.clear();
                                                                            _userWorkoutsDateViewModel.warmUpList.clear();
                                                                            _userWorkoutsDateViewModel.superSetsRound = "";
                                                                            _userWorkoutsDateViewModel.userProgramDatesId = "";
                                                                            _userWorkoutsDateViewModel.restTime = "";
                                                                            responseApi.data!.selectedWarmup!.forEach((element) {
                                                                              _userWorkoutsDateViewModel.withWarmupExercisesList.add(element);
                                                                              _userWorkoutsDateViewModel.warmUpList.add(element);
                                                                            });

                                                                            responseApi.data!.supersetExercisesIds!.forEach((element) {
                                                                              _userWorkoutsDateViewModel.superSetList.add(element);
                                                                            });
                                                                            _userWorkoutsDateViewModel.allExercisesList.clear();
                                                                            _userWorkoutsDateViewModel.withOutWarmupAllExercisesList.clear();

                                                                            responseApi.data!.selectedWarmup!.forEach((element) {
                                                                              _userWorkoutsDateViewModel.allExercisesList.add(element);
                                                                            });
                                                                            print('allExercisesList warmup >>> ${_userWorkoutsDateViewModel.allExercisesList}');
                                                                            responseApi.data!.exercisesIds!.forEach((element) {
                                                                              _userWorkoutsDateViewModel.allExercisesList.add(element);
                                                                              _userWorkoutsDateViewModel.withOutWarmupAllExercisesList.add(element);
                                                                            });
                                                                            print('allExercisesList >>> ${_userWorkoutsDateViewModel.allExercisesList}');
                                                                            print('withOutWarmupAllExercisesList >>> ${_userWorkoutsDateViewModel.withOutWarmupAllExercisesList}');

                                                                            _userWorkoutsDateViewModel.superSetsRound = responseApi.data!.round;
                                                                            _userWorkoutsDateViewModel.userProgramDatesId = responseApi.data!.userProgramDatesId!;
                                                                            _userWorkoutsDateViewModel.restTime = responseApi.data!.restTime!;
                                                                          } catch (e) {}
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => WorkoutHomeNew(
                                                                                userProgramDate: responseApi.data!.userProgramDatesId!,
                                                                                superSetRound: responseApi.data!.round!,
                                                                                warmUpList: responseApi.data!.selectedWarmup!,
                                                                                withoutWarmUpExercisesList: _userWorkoutsDateViewModel.withOutWarmupAllExercisesList,
                                                                                superSetList: responseApi.data!.supersetExercisesIds!,
                                                                                exercisesList: _userWorkoutsDateViewModel.allExercisesList,
                                                                                workoutId: responseApi.data!.workoutId.toString(),
                                                                                exerciseId: responseApi.data!.exercisesIds![0].toString(),
                                                                              ),
                                                                            ),
                                                                          );

                                                                          /* Get.to(WorkoutHomeScreen(
                                                                                          data: workResponse.data!,
                                                                                          exeData: response.data!,
                                                                                          workoutId: widget.workoutId,
                                                                                          date: DateTime.now().toString().split(' ').first,
                                                                                        ));*/

                                                                          Get.showSnackbar(GetSnackBar(
                                                                            message: 'Your old workout ${workResponse.data![0].workoutTitle} is not removed from schedule',
                                                                            duration: Duration(seconds: 2),
                                                                          ));
                                                                          controllerWork.changeConflict(false);
                                                                          print('Keep Pressed');
                                                                          print('keep ${controllerWork.isConflict}');
                                                                        },
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          height: Get.height * .05,
                                                                          width: Get.width * .3,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(6),
                                                                              gradient: LinearGradient(
                                                                                begin: Alignment.topCenter,
                                                                                end: Alignment.bottomCenter,
                                                                                stops: [0.0, 1.0],
                                                                                colors: ColorUtilsGradient.kTintGradient,
                                                                              )),
                                                                          child: Text(
                                                                            'Keep',
                                                                            style: FontTextStyle.kBlack18w600Roboto,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: Get.width * .05),
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          RemoveWorkoutProgramRequestModel _request = RemoveWorkoutProgramRequestModel();
                                                                          _request.userWorkoutProgramId = conflictWorkoutList![index].userWorkoutProgramId;
                                                                          await _removeWorkoutProgramViewModel.removeWorkoutProgramViewModel(_request);
                                                                          if (_removeWorkoutProgramViewModel.apiResponse.status == Status.COMPLETE) {
                                                                            RemoveWorkoutProgramResponseModel removeWorkoutResponse = _removeWorkoutProgramViewModel.apiResponse.data;
                                                                            if (removeWorkoutResponse.success == true && removeWorkoutResponse.msg != null) {
                                                                              Get.showSnackbar(GetSnackBar(
                                                                                message: '${removeWorkoutResponse.msg}',
                                                                                duration: Duration(seconds: 2),
                                                                              ));
                                                                              controllerWork.changeConflict(false);
                                                                            } else if (removeWorkoutResponse.success == true && removeWorkoutResponse.msg == null) {
                                                                              Get.showSnackbar(GetSnackBar(
                                                                                message: '${removeWorkoutResponse.msg}',
                                                                                duration: Duration(seconds: 2),
                                                                              ));
                                                                            }
                                                                          } else if (saveWorkoutController.apiResponse.status == Status.ERROR) {
                                                                            Get.showSnackbar(GetSnackBar(
                                                                              message: 'Something went wrong!!!',
                                                                              duration: Duration(seconds: 2),
                                                                            ));
                                                                          }

                                                                          // controllerWork.changeConflict(false);
                                                                          await _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails(date: dateString(), userId: PreferenceManager.getUId());
                                                                          if (_workoutExerciseConflictViewModel.apiResponse.status == Status.COMPLETE) {
                                                                            WorkoutExerciseConflictResponseModel resConflict = _workoutExerciseConflictViewModel.apiResponse.data;

                                                                            if (resConflict.data != [] && resConflict.msg == "You are already following another program on these dates. Choose below if you want to follow them both.") {
                                                                              conflictWorkoutList = resConflict.data!;
                                                                              warningmsg = '${resConflict.msg}';

                                                                              print('-------------- msg${resConflict.msg}');

                                                                              print('conflict called on week days');

                                                                              controllerWork.changeConflict(true);
                                                                            } else {
                                                                              controllerWork.changeConflict(false);
                                                                            }
                                                                          }
                                                                          print('Remove Pressed');
                                                                        },
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          height: Get.height * .05,
                                                                          width: Get.width * .3,
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: ColorUtils.kTint, width: 1.5)),
                                                                          child: Text(
                                                                            'Remove',
                                                                            style: FontTextStyle.kTine17BoldRoboto,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: Get.height * 0.05)
                                                                ]);
                                                          }),
                                                    ],
                                                  )
                                                      : SizedBox(),
                                                  Divider(
                                                    color: ColorUtils
                                                        .kGray,
                                                    thickness: 2,
                                                    height: Get.height *
                                                        0.05,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                          AppText
                                                              .getByEmail,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              Get.height *
                                                                  .02)),
                                                      Spacer(),
                                                      CupertinoSwitch(
                                                        activeColor:
                                                        ColorUtils
                                                            .kTint,
                                                        value: controllerWork
                                                            .switchValue,
                                                        onChanged:
                                                            (value) {
                                                          controllerWork
                                                              .emailToggle(
                                                              value);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                        Get.width *
                                                            .05,
                                                        right:
                                                        Get.width *
                                                            .05,
                                                        top:
                                                        Get.height *
                                                            .03,
                                                        bottom:
                                                        Get.height *
                                                            .02),
                                                    child:
                                                    GestureDetector(
                                                      onTap: () async {
                                                        {
                                                          await _workoutExerciseConflictViewModel.getWorkoutExerciseConflictDetails(
                                                              date:
                                                              dateString(),
                                                              userId: PreferenceManager
                                                                  .getUId(),
                                                              isLoading:
                                                              true);
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
                                                            print(
                                                                'START-------------- msg${resConflict.msg}');

                                                            if (resConflict.data ==
                                                                [] ||
                                                                resConflict.msg !=
                                                                    "No Conflicts available") {
                                                              conflictWorkoutList =
                                                              resConflict
                                                                  .data!;
                                                              warningmsg =
                                                              '${resConflict.msg}';

                                                              print(
                                                                  ' -------------- msg ${resConflict.msg}');

                                                              print(
                                                                  'conflict called on week days');

                                                              controllerWork
                                                                  .changeConflict(
                                                                  true);
                                                              Get.showSnackbar(
                                                                  GetSnackBar(
                                                                    message:
                                                                    '${resConflict.msg}',
                                                                    duration:
                                                                    Duration(seconds: 1),
                                                                  ));
                                                            } else {
                                                              _confirmationAlertDialog(onTapCancel:
                                                                  () {
                                                                Get.back();
                                                              }, onTapConfirmation:
                                                                  () async {
                                                                Get.back();
                                                                controllerWork
                                                                    .changeConflict(false);
                                                                if (controllerWork.apiResponse.status != Status.LOADING ||
                                                                    controllerWork.apiResponse.status !=
                                                                        Status.ERROR) {
                                                                  SaveWorkoutProgramRequestModel
                                                                  _request =
                                                                  SaveWorkoutProgramRequestModel();
                                                                  _request.userId =
                                                                      PreferenceManager.getUId();
                                                                  _request.workoutId = workResponse
                                                                      .data![0]
                                                                      .workoutId;
                                                                  _request.exerciseId =
                                                                  "0";
                                                                  _request.startDate =
                                                                      startDate(controllerWork.defSelectedList);
                                                                  _request.endDate =
                                                                      endDate(controllerWork.defSelectedList);
                                                                  _request.selectedWeekDays =
                                                                      finalDayString;
                                                                  _request.selectedDates =
                                                                      dateString();
                                                                  print(
                                                                      'print is edit ------------ ${widget.isEdit}');
                                                                  if (widget.isEdit ==
                                                                      true) {
                                                                    _request.workoutProgramId =
                                                                        widget.workoutProgramId;
                                                                  }
                                                                  await saveWorkoutController
                                                                      .saveWorkoutProgramViewModel(_request);
                                                                  if (saveWorkoutController.apiResponse.status ==
                                                                      Status.COMPLETE) {
                                                                    SaveWorkoutProgramResponseModel
                                                                    saveWorkoutResponse =
                                                                        saveWorkoutController.apiResponse.data;
                                                                    if (saveWorkoutResponse.success == true &&
                                                                        saveWorkoutResponse.msg != null) {
                                                                      Get.showSnackbar(GetSnackBar(
                                                                        message: '${saveWorkoutResponse.msg}',
                                                                        duration: Duration(seconds: 2),
                                                                      ));
                                                                      /*  Get.showSnackbar(GetSnackBar(
                                                                                message: 'Your old workout ${workResponse.data![0].workoutTitle} is not removed from schedule',
                                                                                duration: Duration(seconds: 2),
                                                                              ));*/
                                                                      controllerWork.changeConflict(false);
                                                                      print('Keep Pressed');
                                                                      print('keep ${controllerWork.isConflict}');
                                                                      try {
                                                                        print('tryyyyyyy');
                                                                        UserWorkoutsDateResponseModel responseApi = await UserWorkoutsDateRepo().userWorkoutsDateRepo(date: DateTime.now().toString().split(' ').first, userId: PreferenceManager.getUId());
                                                                        _userWorkoutsDateViewModel.withWarmupExercisesList.clear();
                                                                        _userWorkoutsDateViewModel.withWarmupExercisesList.clear();
                                                                        _userWorkoutsDateViewModel.superSetList.clear();
                                                                        _userWorkoutsDateViewModel.warmUpList.clear();
                                                                        _userWorkoutsDateViewModel.superSetsRound = "";
                                                                        _userWorkoutsDateViewModel.userProgramDatesId = "";
                                                                        _userWorkoutsDateViewModel.restTime = "";
                                                                        responseApi.data!.selectedWarmup!.forEach((element) {
                                                                          _userWorkoutsDateViewModel.withWarmupExercisesList.add(element);
                                                                          _userWorkoutsDateViewModel.warmUpList.add(element);
                                                                        });

                                                                        responseApi.data!.supersetExercisesIds!.forEach((element) {
                                                                          _userWorkoutsDateViewModel.superSetList.add(element);
                                                                        });
                                                                        _userWorkoutsDateViewModel.allExercisesList.clear();
                                                                        _userWorkoutsDateViewModel.withOutWarmupAllExercisesList.clear();

                                                                        responseApi.data!.selectedWarmup!.forEach((element) {
                                                                          _userWorkoutsDateViewModel.allExercisesList.add(element);
                                                                        });
                                                                        print('allExercisesList warmup >>> ${_userWorkoutsDateViewModel.allExercisesList}');
                                                                        responseApi.data!.exercisesIds!.forEach((element) {
                                                                          _userWorkoutsDateViewModel.allExercisesList.add(element);
                                                                          _userWorkoutsDateViewModel.withOutWarmupAllExercisesList.add(element);
                                                                        });
                                                                        print('allExercisesList >>> ${_userWorkoutsDateViewModel.allExercisesList}');
                                                                        print('withOutWarmupAllExercisesList >>> ${_userWorkoutsDateViewModel.withOutWarmupAllExercisesList}');

                                                                        _userWorkoutsDateViewModel.superSetsRound = responseApi.data!.round;
                                                                        _userWorkoutsDateViewModel.userProgramDatesId = responseApi.data!.userProgramDatesId!;
                                                                        _userWorkoutsDateViewModel.restTime = responseApi.data!.restTime!;
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => WorkoutHomeNew(
                                                                              userProgramDate: responseApi.data!.userProgramDatesId!,
                                                                              superSetRound: responseApi.data!.round!,
                                                                              warmUpList: responseApi.data!.selectedWarmup!,
                                                                              withoutWarmUpExercisesList: _userWorkoutsDateViewModel.withOutWarmupAllExercisesList,
                                                                              superSetList: responseApi.data!.supersetExercisesIds!,
                                                                              exercisesList: _userWorkoutsDateViewModel.allExercisesList,
                                                                              workoutId: responseApi.data!.workoutId.toString(),
                                                                              exerciseId: responseApi.data!.exercisesIds![0].toString(),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } catch (e) {
                                                                        print('catchhhh');

                                                                        Get.offAll(HomeScreen(id: PreferenceManager.getUId()));
                                                                      }
                                                                      /* Get.to(WorkoutHomeScreen(
                                                                                data: workResponse.data!,
                                                                                exeData: response.data!,
                                                                                workoutId: widget.workoutId,
                                                                                date: DateTime.now().toString().split(' ').first,
                                                                              ));*/

                                                                      widget.isEdit = false;
                                                                    }
                                                                  } else if (saveWorkoutController.apiResponse.status ==
                                                                      Status.ERROR) {
                                                                    Get.showSnackbar(GetSnackBar(
                                                                      message: 'Something went wrong!!!',
                                                                      duration: Duration(seconds: 2),
                                                                    ));
                                                                  }
                                                                }
                                                              });
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        height:
                                                        Get.height *
                                                            .06,
                                                        width:
                                                        Get.width,
                                                        decoration:
                                                        BoxDecoration(
                                                            gradient:
                                                            LinearGradient(
                                                              begin:
                                                              Alignment.topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              stops: [
                                                                0.0,
                                                                1.0
                                                              ],
                                                              colors:
                                                              ColorUtilsGradient.kTintGradient,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius.circular(6)),
                                                        child: !widget
                                                            .isEdit!
                                                            ? Text(
                                                            'Start Program',
                                                            style: FontTextStyle
                                                                .kBlack20BoldRoboto)
                                                            : Text(
                                                            'Edit Program',
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
                                              if (controller.apiResponse
                                                  .status ==
                                                  Status.LOADING) {
                                                return Container(
                                                  height: Get.height,
                                                  width: Get.width,
                                                  color: Colors.black54,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                        color:
                                                        ColorUtils
                                                            .kTint),
                                                  ),
                                                );
                                              }
                                              return SizedBox();
                                            },
                                          ),
                                          GetBuilder<
                                              RemoveWorkoutProgramViewModel>(
                                            builder: (controller) {
                                              if (controller.apiResponse
                                                  .status ==
                                                  Status.LOADING) {
                                                return Container(
                                                  height: Get.height,
                                                  width: Get.width,
                                                  color: Colors.black54,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                        color:
                                                        ColorUtils
                                                            .kTint),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: noData(),
                                      ));
                                }
                              })
                              : Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: noData(),
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
                            title: !widget.isEdit!
                                ? Text('Setup Program',
                                style: FontTextStyle.kWhite16BoldRoboto)
                                : Text('Edit Program',
                                style:
                                FontTextStyle.kWhite16BoldRoboto),
                            centerTitle: true,
                          ),
                          body: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: noData(),
                            ),),);
                      }
                    });
              } else {
                return Center(
                  child: noData(),
                );
              }
            },
          )
              : ConnectionCheckScreen();
        }),
      ),
    );
  }

  _confirmationAlertDialog(
      {Function()? onTapCancel, Function()? onTapConfirmation}) {
    Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: ColorUtils.kBlack,
          actionsOverflowDirection: VerticalDirection.down,
          title: Column(children: [
            Text('Please Confirm',
                style: FontTextStyle.kBlack24W400Roboto.copyWith(
                    fontWeight: FontWeight.bold, color: ColorUtils.kTint)),
            SizedBox(height: 20),
            !widget.isEdit!
                ? Text(
                    'Are you sure you want to Save this Workout Program!',
                    textAlign: TextAlign.center,
                    style: FontTextStyle.kBlack16W300Roboto
                        .copyWith(color: ColorUtils.kTint),
                  )
                : Text(
                    'Are you sure you want to Edit this Workout Program!',
                    textAlign: TextAlign.center,
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
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
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
                    onPressed: onTapCancel),
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
                  child: !widget.isEdit!
                      ? Text('Save',
                          style: FontTextStyle.kTint24W400Roboto
                              .copyWith(fontWeight: FontWeight.bold))
                      : Text('Edit',
                          style: FontTextStyle.kTint24W400Roboto
                              .copyWith(fontWeight: FontWeight.bold)),
                  onPressed: onTapConfirmation,
                ),
              ],
            ),
          ],
        ),
        barrierColor: ColorUtils.kBlack.withOpacity(0.6));
  }
}
