import 'dart:developer';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/repo/training_plan_repo/workout_by_id_repo.dart';

import '../../model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';

class WorkoutByIdViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutByIdDetails({String? id}) async {
    if (_apiResponse.status == Status.INITIAL) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
      update();
    }

    // _apiResponse = ApiResponse.loading(message: 'Loading');

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
    defSelectedList = value;
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

  void emailToggle(bool value) {
    switchValue = value;
    update();
  }
}
