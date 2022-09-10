import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/custom_habit_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/custom_habit_response_model.dart';
import 'package:tcm/repo/habit_tracker_repo/custom_habit_repo.dart';

class CustomHabitViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late CustomHabitResponseModel response;
  Future<void> customHabitViewModel(CustomHabitRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==CustomHabitViewModel=>');
      response = await CustomHabitRepo().customHabitRepo(model.toJson());
      print('==CustomHabitViewModel=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... CustomHabitViewModel ===== $e");
    }
    update();
  }
}
