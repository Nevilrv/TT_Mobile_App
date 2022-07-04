import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/get_habit_record_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_response_model.dart';
import 'package:tcm/repo/habit_tracker_repo/get_habit_record_repo.dart';

class GetHabitRecordViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late GetHabitRecordResponseModel response;
  Future<void> getHabitRecordViewModel(Map<String, dynamic> body) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      print('==GetHabitRecord=>');
      response = await GetHabitRecordRepo().getHabitRecordRepo(body);
      print('==GetHabitRecord=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... GetHabitRecord ===== $e");
    }
    update();
  }
}
