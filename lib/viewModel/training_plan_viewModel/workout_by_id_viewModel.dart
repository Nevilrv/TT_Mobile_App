import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/repo/training_plan_repo/workout_by_id_repo.dart';

import '../../model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';
import '../../utils/app_text.dart';

class WorkoutByIdViewModel extends GetxController {
  @override
  onInit() {
    defSelectedList.clear();
    dayAddedList.clear();
    // print('workout id ------------------ ${widget.workoutId}');
    // print('exerciseId id ------------------ ${widget.exerciseId}');
    // print('day ------------------ ${widget.day}');
    getWorkoutByIdDetails(id: "5");
    super.onInit();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutByIdDetails({String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      WorkoutByIdResponseModel response =
          await WorkoutByIdRepo().workoutByIdRepo(id: id);
      print('workout by id try ====> $response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("workout by id catch ====>$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  bool isCallOneTime = true;
  bool callOneTimeApiCall = true;
  int apiDayLength = 0;

  List<DateTime> defSelectedList = [];
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  setDateController(List<DateTime>? date) {
    dateRangePickerController.selectedDates!.clear();
    dateRangePickerController.selectedDates!.addAll(date!);
    update();
  }

  listUpdate({required List<DateTime> value}) {
    print('old defSelectedList $defSelectedList');
    defSelectedList = value;
    // update();

    print('NEW defSelectedList $defSelectedList');

    // update();
  }

  List<String> dayAddedList = [];
  setDayAddedList({required String value}) {
    if (dayAddedList.contains(value)) {
    } else {
      dayAddedList.add(value);
    }
    if (dayAddedList.length > apiDayLength) {
      dayAddedList.removeAt(0);
    }
    log('day added list ======= $dayAddedList');
    update();
  }

  DateTime? dateByUser;
  List saveDay = [];
  bool isSelected = false;
  bool switchValue = true;
  bool calendarTap = false;
  // List<String> dayAddedList = [];
  List apiDayAddedList = [];
  List<Conflict>? conflictWorkoutList = [];
  String? warningmsg = '';
  bool isConflict = false;

  void changeConflict(bool value) {
    isConflict = value;
    update();
  }

  void changeCalendar(bool value) {
    print(" controller bool $calendarTap  start");
    calendarTap = value;

    print(" controller bool $calendarTap  end");
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

  updateWithSelection1({required int weekLength, required DateTime startDate}) {
    if (apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (apiResponse.status == Status.COMPLETE) {
      DateTime todayDate = startDate == null ? DateTime.now() : startDate;
      List<int> weekDay = [];

      // print(
      //     'today date week day and date ======== $todayDate ------- ${todayDate.weekday}');

      dayAddedList.forEach((element) {
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
      //
      // print('days week number ------------------  $weekDay');
      // print(
      //     '----------------- ${weekDay.reduce((curr, next) => curr < next ? curr : next)}');

      String smallestDate =
          '${weekDay.reduce((curr, next) => curr < next ? curr : next)}';

      // int week = 2;
      int end = 0;
      int start = 0;

      if (todayDate.weekday < int.parse(smallestDate)) {
        end = 7 + int.parse(smallestDate);
        start = 7 - int.parse(smallestDate);
        print("end is $end and start is $start");
      }

      // print("weekLength ---------------- $weekLength");

      for (int week = 1; week <= weekLength; week++) {
        // print('week ---------------------- $week');
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
        // setState(() {
        // });
        if (isCallOneTime) {
          multiSelectionDay(
              userSelectedDate:
                  dateByUser == null ? DateTime.now() : dateByUser!);
        }
        isCallOneTime = false;

        listUpdate(value: days);

        // _dateRangePickerController.selectedDates = defSelectedList;
        // log('find week number +++++  ----- ${todayDate}');
        print(
            'defSelectedList list ---------  11111155656565655 ${defSelectedList}');
      }
    }
    update();
  }

  updateWithSelection({required int weekLength, required DateTime startDate}) {
    if (apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (apiResponse.status == Status.COMPLETE) {
      DateTime todayDate = startDate == null ? DateTime.now() : startDate;
      List<int> weekDay = [];

      // print(
      //     'today date week day and date ======== $todayDate ------- ${todayDate.weekday}');

      dayAddedList.forEach((element) {
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
      //
      // print('days week number ------------------  $weekDay');
      // print(
      //     '----------------- ${weekDay.reduce((curr, next) => curr < next ? curr : next)}');

      String smallestDate =
          '${weekDay.reduce((curr, next) => curr < next ? curr : next)}';

      // int week = 2;
      int end = 0;
      int start = 0;

      if (todayDate.weekday < int.parse(smallestDate)) {
        end = 7 + int.parse(smallestDate);
        start = 7 - int.parse(smallestDate);
        print("end is $end and start is $start");
      }

      // print("weekLength ---------------- $weekLength");

      for (int week = 1; week <= weekLength; week++) {
        // print('week ---------------------- $week');
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
        // setState(() {
        // });
        if (isCallOneTime) {
          // multiSelectionDay(
          //     userSelectedDate:
          //         dateByUser == null ? DateTime.now() : dateByUser!);
        }
        isCallOneTime = false;

        defSelectedList = days;

        // _dateRangePickerController.selectedDates = defSelectedList;
        // log('find week number +++++  ----- ${todayDate}');
        print('defSelectedList list --------- ${defSelectedList}');
      }
    }
    update();
  }

  multiSelectionDay({required DateTime userSelectedDate}) {
    if (apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (apiResponse.status == Status.COMPLETE) {
      WorkoutByIdResponseModel res = apiResponse.data;

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
      dayAddedList = listOfDaysFromApi;

      // print(
      //     'dayAddedList list api list added --------- ${dayAddedList}');
      // print('days from api ------------------  $listOfDaysFromApi');
      print('userSelectedDate ------------------  $userSelectedDate');

      updateWithSelection(
          weekLength: res.data![0].daysAllData!.length,
          startDate: userSelectedDate);
    }
    update();
  }

  multiSelectionDay1({required DateTime userSelectedDate}) {
    if (apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (apiResponse.status == Status.COMPLETE) {
      WorkoutByIdResponseModel res = apiResponse.data;

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
      dayAddedList = listOfDaysFromApi;

      // print(
      //     'dayAddedList list api list added --------- ${dayAddedList}');
      // print('days from api ------------------  $listOfDaysFromApi');
      print('userSelectedDate 11111 ------------------ $userSelectedDate');

      updateWithSelection1(
          weekLength: res.data![0].daysAllData!.length,
          startDate: userSelectedDate);
    }
    update();
  }

  setAllDat() {
    saveDay.forEach((element) {
      setDay(index: element);
    });
    update();
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

    if (dayAddedList.contains('${AppText.weekDays[index]}')) {
      dayAddedList.remove('${AppText.weekDays[index]}');
    } else {
      dayAddedList.add('${AppText.weekDays[index]}');
    }
    update();

    // log('111111111111111 ----show day list ${dayAddedList}');
  }

// setAndRemove({required String keyValue}) {
//   if (dayAddedList.contains(keyValue)) {
//     dayAddedList.remove(keyValue);
//   } else {
//     dayAddedList.add(keyValue);
//   }
//   print('controller call -------');
//   update();
// }
}
