import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/user_habit_tracker_status_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/user_habit_tracker_status_response_model.dart';
import 'package:tcm/repo/habit_tracker_repo/user_habit_track_status_repo.dart';

class UserHabitTrackStatusViewModel extends GetxController {
  int? selectedIndex = 0;

  List<DateTime> defSelectedList = [];
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  setDateController(List<DateTime>? date) {
    dateRangePickerController.selectedDates!.addAll(date!);
    update();
  }

  frequencySelect({int? value}) {
    selectedIndex = value;
    update();
  }

  String selectedStatus = "daily";

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late UserHabitTrackStatusResponseModel response;
  Future<void> userHabitTrackStatusViewModel(
      UserHabitTrackStatusRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==UserHabitTrackStatusViewModel=>');
      response = await UserHabitTrackStatusRepo()
          .userHabitTrackStatusRepo(model.toJson());
      print('==UserHabitTrackStatusViewModel=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... UserHabitTrackStatusViewModel ===== $e");
    }
    update();
  }
}
