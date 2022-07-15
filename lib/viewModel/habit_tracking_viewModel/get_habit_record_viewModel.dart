import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/get_habit_record_date_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart';
import 'package:tcm/repo/habit_tracker_repo/get_habit_record_repo.dart';

class GetHabitRecordDateViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late GetHabitRecordDateResponseModel response;
  Future<void> getHabitRecordDateViewModel(
      GetHabitRecordDateRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");

    try {
      print('==GetHabitRecordDate=>');
      response =
          await GetHabitRecordDateRepo().getHabitRecordDateRepo(model.toJson());
      print('==GetHabitRecordDate=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... GetHabitRecord ===== $e");
    }
    update();
  }
}
